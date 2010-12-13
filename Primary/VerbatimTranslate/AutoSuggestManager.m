//
//  AutoSuggestManager.m
//  ToolbarSearch
//
//  Created by Brandon George on 9/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AutoSuggestManager.h"

#define kPhraseTypeHistory 1
#define kPhraseTypeCommon  2
#define kPhraseLimit       1000
#define kDBFilename		   @"verbatim.sql"


@interface AutoSuggestManager (private)

- (NSString *)_getWritableDBPath;
- (void)_createWritableCopyOfDatabaseIfNeeded;
- (void)_closeDatabase;
- (void)_finalizePrecompiledStatements;

@end

// TODO - need to create phrase/history tables (if necessary) - probably on language change
// TODO - nuke the precompiled statements when language is changed
// TODO - method for compiling statements (streamlined)
// TODO - finish addToHistory/implement getHistoryTranslation (id based instead of string based?) - optimize addToHistory as update and insert ignore? (maybe)
// TODO - add a timestamp field to phrases table so we can cutoff old entries and make the most recent ones showup at the top? anything else to sort on (alphabetical, etc)?
// TODO - having to supply language on singleton is odd -- figure this out
// TODO - tons of error handling (on all sql calls -- open, close, prepare, etc -- check for errors and fail gracefully)

@implementation AutoSuggestManager

@synthesize language = _language;

+ (AutoSuggestManager *)sharedInstanceWithLanguage:(NSString *)language {
	static AutoSuggestManager * instance = nil;
	if (instance == nil) {
		instance = [[AutoSuggestManager alloc] initWithLanguage:language];
	} else {
		instance.language = language;
	}
	
	return instance;
}

- (id)initWithLanguage:(NSString *)language {
	if (self = [super init]) {
		self.language = language;
		
		// connect to database
		[self _createWritableCopyOfDatabaseIfNeeded];
		sqlite3_open([[self _getWritableDBPath] UTF8String], &_db);
	}
	return self;
}

- (void)addToHistory:(NSString *)from to:(NSString *)to toLanguage:(NSString *)toLanguage {
    if ([from isEqualToString:@""]) {
        return;
    }
    
	// if already exists of type history, don't add; if already exists of type common phrase, change to history; otherwise, add to history

	// compile statement if necessary
    if (_checkPhraseStatement == nil) {
		NSString * sql = [NSString stringWithFormat:@"SELECT rowid, type FROM phrases_%@ WHERE phrase = ?", self.language];
        if (sqlite3_prepare_v2(_db, [sql UTF8String], -1, &_checkPhraseStatement, NULL) != SQLITE_OK) {
			// TODO - add preparation error
        }
    }
	
	// execute the query
	sqlite3_bind_text(_checkPhraseStatement, 1, [from UTF8String], -1, SQLITE_TRANSIENT);	// TODO - "transient" correct?
	if (sqlite3_step(_checkPhraseStatement) == SQLITE_ROW) {
		int rowid = sqlite3_column_int(_checkPhraseStatement, 0);
		int phraseType = sqlite3_column_int(_checkPhraseStatement, 1);
		if (phraseType == kPhraseTypeCommon) {
			// compile statement if necessary
			if (_updateToHistoryStatement == nil) {
				NSString * sql = [NSString stringWithFormat:@"UPDATE phrases_%@ SET type = %d WHERE rowid = ?", self.language, kPhraseTypeHistory];
				if (sqlite3_prepare_v2(_db, [sql UTF8String], -1, &_updateToHistoryStatement, NULL) != SQLITE_OK) {
					// TODO - add preparation error
				}
			}
			
			sqlite3_bind_int(_updateToHistoryStatement, 1, rowid);
			sqlite3_step(_updateToHistoryStatement);
			sqlite3_reset(_updateToHistoryStatement);			
		}
	} else {
		// compile statement if necessary
		if (_addHistoryStatement == nil) {
			NSString * sql = [NSString stringWithFormat:@"INSERT INTO phrases_%@ VALUES (?, %d)", self.language, kPhraseTypeHistory];
			if (sqlite3_prepare_v2(_db, [sql UTF8String], -1, &_addHistoryStatement, NULL) != SQLITE_OK) {
				// TODO - add preparation error
			}
		}
		
		sqlite3_bind_text(_addHistoryStatement, 1, [from UTF8String], -1, SQLITE_TRANSIENT);	// TODO - "transient" correct?
		sqlite3_step(_addHistoryStatement);
		sqlite3_reset(_addHistoryStatement);
	}
	
	sqlite3_reset(_checkPhraseStatement);
}

- (void)downloadCommonPhrases:(NSString *)toLanguage {
	// download from internet and insert into db
}

- (NSMutableArray *)getAllPhrases {
	return [self getAllPhrases:nil];
}

- (NSMutableArray *)getAllPhrases:(NSString *)filterString {
	// query db for all common phrases and history, prioritize history
	NSMutableArray * items = [NSMutableArray array];
	
	// compile statement if necessary
    if (_getAllPhrasesStatement == nil) {
		NSString * sql = [NSString stringWithFormat:@"SELECT phrase FROM phrases_%@ WHERE phrase LIKE ? ORDER BY type ASC, LENGTH(phrase) ASC LIMIT %d", self.language, kPhraseLimit];
        if (sqlite3_prepare_v2(_db, [sql UTF8String], -1, &_getAllPhrasesStatement, NULL) != SQLITE_OK) {
			// TODO - add preparation error
        }
    }
	
	// bind the filter string
	NSString * likeParam = ([filterString length] > 0 ? [NSString stringWithFormat:@"%%%@%%", filterString] : @"%");
	sqlite3_bind_text(_getAllPhrasesStatement, 1, [likeParam UTF8String], -1, SQLITE_TRANSIENT);	// TODO - "transient" correct?

    // execute the query
	while (sqlite3_step(_getAllPhrasesStatement) == SQLITE_ROW) {
		[items addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(_getAllPhrasesStatement, 0)]];
	}
	
	sqlite3_reset(_getAllPhrasesStatement);
	
	return items;
}

- (NSMutableArray *)getHistory {
	NSMutableArray * items = [NSMutableArray array];
	
	// compile statement if necessary
    if (_getHistoryStatement == nil) {
		NSString * sql = [NSString stringWithFormat:@"SELECT phrase FROM phrases_%@ WHERE type = %d LIMIT %d", self.language, kPhraseTypeHistory, kPhraseLimit];
        if (sqlite3_prepare_v2(_db, [sql UTF8String], -1, &_getHistoryStatement, NULL) != SQLITE_OK) {
			// TODO - add preparation error
        }
    }
	
    // execute the query
	while (sqlite3_step(_getHistoryStatement) == SQLITE_ROW) {
		[items addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(_getHistoryStatement, 0)]];
	}
	
	sqlite3_reset(_getHistoryStatement);
	
	return items;
}

- (NSString *)getHistoryTranslation:(NSString *)from {
	// query db
	return nil;
}

- (void)clearHistory {
	// compile statement if necessary
	if (_clearHistoryStatement == nil) {
		// TODO - only delete history types or common phrases too?  If only history types, do we restore common phrases that are history types back to common phrase types?
		// TODO - current language, or all languages? (probably all, but it doesn't really matter)
		// TODO - need to also delete history tables
		NSString * sql = [NSString stringWithFormat:@"DELETE FROM phrases_%@", self.language];
		if (sqlite3_prepare_v2(_db, [sql UTF8String], -1, &_clearHistoryStatement, NULL) != SQLITE_OK) {
			// TODO - add preparation error
		}
	}
	
	sqlite3_step(_clearHistoryStatement);
	sqlite3_reset(_clearHistoryStatement);	
}

// private methods

- (NSString *)_getWritableDBPath {
	NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString * documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:kDBFilename];
}

- (void)_createWritableCopyOfDatabaseIfNeeded {
	// check for existance of a writable db copy
	NSFileManager * fileManager = [NSFileManager defaultManager];
	NSString * writableDBPath = [self _getWritableDBPath];
	if ([fileManager fileExistsAtPath:writableDBPath]) {
		return;
	} else {
		// create a writable db copy (necessary for changing the db contents)
		NSString * bundledDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kDBFilename];
		if (![fileManager copyItemAtPath:bundledDBPath toPath:writableDBPath error:nil]) {
			// TODO - add copy error
		}
	}
}

- (void)_closeDatabase {
	[self _finalizePrecompiledStatements];
	sqlite3_close(_db);
}

- (void)_finalizePrecompiledStatements {
	if (_getAllPhrasesStatement) {
        sqlite3_finalize(_getAllPhrasesStatement);
        _getAllPhrasesStatement = nil;
    }

	if (_getHistoryStatement) {
        sqlite3_finalize(_getHistoryStatement);
        _getHistoryStatement = nil;
    }

	if (_checkPhraseStatement) {
        sqlite3_finalize(_checkPhraseStatement);
        _checkPhraseStatement = nil;
    }

	if (_updateToHistoryStatement) {
        sqlite3_finalize(_updateToHistoryStatement);
        _updateToHistoryStatement = nil;
    }

	if (_addHistoryStatement) {
        sqlite3_finalize(_addHistoryStatement);
        _addHistoryStatement = nil;
    }

	if (_clearHistoryStatement) {
        sqlite3_finalize(_clearHistoryStatement);
        _clearHistoryStatement = nil;
    }	
}

- (void)dealloc {
	[self _closeDatabase];
	[_language release];
	[super dealloc];
}

@end
