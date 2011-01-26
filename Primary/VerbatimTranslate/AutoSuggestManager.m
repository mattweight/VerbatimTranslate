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


- (void)_setNewLanguage:(NSString *)newLanguage withLanguageVar:(NSString **)languageVar;
- (void)_createTables;
- (NSString *)_getWritableDBPath;
- (void)_createWritableCopyOfDatabaseIfNeeded;
- (void)_importEnglishCommonPhrases;
- (void)_raiseDBException;
- (void)_closeDatabase;
- (void)_finalizePrecompiledStatements;

@end

@implementation AutoSuggestManager

+ (AutoSuggestManager *)sharedInstance {
	static AutoSuggestManager * instance = nil;
	if (instance == nil) {
		instance = [[AutoSuggestManager alloc] init];
	}
	return instance;
}

- (id)init {
	if (self = [super init]) {
		// connect to database
		[self _createWritableCopyOfDatabaseIfNeeded];
		if (sqlite3_open([[self _getWritableDBPath] UTF8String], &_db) != SQLITE_OK) {
			[self _raiseDBException];
		}
	}
	return self;
}

- (NSString *)sourceLanguage {
	return _sourceLanguage;
}

- (NSString *)destLanguage {
	return _destLanguage;
}

- (void)setSourceLanguage:(NSString *)newSourceLanguage {
	[self _setNewLanguage:newSourceLanguage withLanguageVar:&_sourceLanguage];
}

- (void)setDestLanguage:(NSString *)newDestLanguage {
	[self _setNewLanguage:newDestLanguage withLanguageVar:&_destLanguage];
}

- (NSDictionary *)getAllPhrases:(NSString *)filterString {
	// query db for all common phrases and history, prioritize history
	NSMutableArray * phrases = [NSMutableArray array];
	NSMutableArray * historyPhraseIds = [NSMutableArray array];
	
	// compile statement if necessary
    if (_getAllPhrasesStatement == nil) {
		NSString * sql = [NSString stringWithFormat:@"SELECT rowid, phrase, type FROM original_phrases_%@ WHERE phrase LIKE ? ORDER BY type ASC, time DESC LIMIT %d", _sourceLanguage, kPhraseLimit];
        if (sqlite3_prepare_v2(_db, [sql UTF8String], -1, &_getAllPhrasesStatement, NULL) != SQLITE_OK) {
			[self _raiseDBException];
        }
    }
	
	// bind the filter string
	NSString * likeParam = ([filterString length] > 0 ? [NSString stringWithFormat:@"%%%@%%", filterString] : @"%");
	sqlite3_bind_text(_getAllPhrasesStatement, 1, [likeParam UTF8String], -1, SQLITE_TRANSIENT);
	
    // execute the query
	while (sqlite3_step(_getAllPhrasesStatement) == SQLITE_ROW) {
		[phrases addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(_getAllPhrasesStatement, 1)]];
		int phraseType = sqlite3_column_int(_getAllPhrasesStatement, 2);
		if (phraseType == kPhraseTypeHistory) {
			[historyPhraseIds addObject:[NSNumber numberWithLongLong:sqlite3_column_int64(_getAllPhrasesStatement, 0)]];
		} else {
			[historyPhraseIds addObject:[NSNumber numberWithLongLong:0]];
		}
	}
	sqlite3_reset(_getAllPhrasesStatement);
	
	return [NSDictionary dictionaryWithObjectsAndKeys:phrases, @"phrases", historyPhraseIds, @"historyPhraseIds", nil];
}

- (void)addToHistory:(NSString *)originalText translatedText:(NSString *)translatedText {
    if ([originalText isEqualToString:@""]) {
        return;
    }
    
	// if already exists of type history/common phrase, update timestamp and type to history; otherwise, add to history

	// compile statement if necessary
    if (_checkPhraseStatement == nil) {
		NSString * sql = [NSString stringWithFormat:@"SELECT rowid FROM original_phrases_%@ WHERE lower(phrase) = ?", _sourceLanguage];
        if (sqlite3_prepare_v2(_db, [sql UTF8String], -1, &_checkPhraseStatement, NULL) != SQLITE_OK) {
			[self _raiseDBException];
        }
    }
	
	// execute the query
	sqlite3_int64 phraseRowId = 0;
	sqlite3_bind_text(_checkPhraseStatement, 1, [[originalText lowercaseString] UTF8String], -1, SQLITE_TRANSIENT);
	if (sqlite3_step(_checkPhraseStatement) == SQLITE_ROW) {
		phraseRowId = sqlite3_column_int64(_checkPhraseStatement, 0);
		
		// compile statement if necessary
		if (_updateToHistoryStatement == nil) {
			NSString * sql = [NSString stringWithFormat:@"UPDATE original_phrases_%@ SET type = %d, time = strftime('%%s','now') WHERE rowid = ?", _sourceLanguage, kPhraseTypeHistory];
			if (sqlite3_prepare_v2(_db, [sql UTF8String], -1, &_updateToHistoryStatement, NULL) != SQLITE_OK) {
				[self _raiseDBException];
			}
		}
		
		sqlite3_bind_int64(_updateToHistoryStatement, 1, phraseRowId);
		sqlite3_step(_updateToHistoryStatement);
		sqlite3_reset(_updateToHistoryStatement);
	} else {
		// compile statement if necessary
		if (_addHistoryStatement == nil) {
			NSString * sql = [NSString stringWithFormat:@"INSERT INTO original_phrases_%@ VALUES (?, %d, strftime('%%s','now'))", _sourceLanguage, kPhraseTypeHistory];
			if (sqlite3_prepare_v2(_db, [sql UTF8String], -1, &_addHistoryStatement, NULL) != SQLITE_OK) {
				[self _raiseDBException];
			}
		}
		
		sqlite3_bind_text(_addHistoryStatement, 1, [originalText UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_step(_addHistoryStatement);
		phraseRowId = sqlite3_last_insert_rowid(_db);
		sqlite3_reset(_addHistoryStatement);
	}
	
	sqlite3_reset(_checkPhraseStatement);
	
	// add translation to history (if applicable)
	if (phraseRowId != 0) {
		BOOL translatedTextAlreadyInHistory = NO;
		
		// compile statement if necessary
		if (_checkTranslatedHistoryStatement == nil) {
			NSString * sql = [NSString stringWithFormat:@"SELECT rowid FROM translated_phrases_%@_%@ WHERE originalPhraseId = ?", _sourceLanguage, _destLanguage];
			if (sqlite3_prepare_v2(_db, [sql UTF8String], -1, &_checkTranslatedHistoryStatement, NULL) != SQLITE_OK) {
				[self _raiseDBException];
			}
		}
		
		sqlite3_bind_int64(_checkTranslatedHistoryStatement, 1, phraseRowId);
		if (sqlite3_step(_checkTranslatedHistoryStatement) == SQLITE_ROW) {
			translatedTextAlreadyInHistory = YES;
		}
		sqlite3_reset(_checkTranslatedHistoryStatement);
		
		if (translatedTextAlreadyInHistory) {
			return;	// skip adding translation to history if already translated for current destination language
		}
		
		// compile statement if necessary
		if (_addTranslatedHistoryStatement == nil) {
			NSString * sql = [NSString stringWithFormat:@"INSERT INTO translated_phrases_%@_%@ VALUES (?, ?)", _sourceLanguage, _destLanguage];
			if (sqlite3_prepare_v2(_db, [sql UTF8String], -1, &_addTranslatedHistoryStatement, NULL) != SQLITE_OK) {
				[self _raiseDBException];
			}
		}
		
		sqlite3_bind_int64(_addTranslatedHistoryStatement, 1, phraseRowId);
		sqlite3_bind_text(_addTranslatedHistoryStatement, 2, [translatedText UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_step(_addTranslatedHistoryStatement);
		sqlite3_reset(_addTranslatedHistoryStatement);
	}
}

- (NSString *)getTranslatedPhrase:(long long)originalPhraseId {
	NSString * translatedPhrase = nil;
	
	// compile statement if necessary
	if (_getTranslatedHistoryStatement == nil) {
		NSString * sql = [NSString stringWithFormat:@"SELECT translation FROM translated_phrases_%@_%@ WHERE originalPhraseId = ?", _sourceLanguage, _destLanguage];
		if (sqlite3_prepare_v2(_db, [sql UTF8String], -1, &_getTranslatedHistoryStatement, NULL) != SQLITE_OK) {
			[self _raiseDBException];
		}
	}
		
	sqlite3_bind_int64(_getTranslatedHistoryStatement, 1, (sqlite3_int64)originalPhraseId);
	if (sqlite3_step(_getTranslatedHistoryStatement) == SQLITE_ROW) {
		translatedPhrase = [NSString stringWithUTF8String:(char *)sqlite3_column_text(_getTranslatedHistoryStatement, 0)];
	}
	sqlite3_reset(_getTranslatedHistoryStatement);
	
	return translatedPhrase;
}

- (void)clearHistory {
	// go through each table and delete/drop as necessary
	
	// compile statement if necessary
	if (_getTablesStatement == nil) {
		NSString * sql = [NSString stringWithFormat:@"SELECT name FROM sqlite_master WHERE type = 'table'"];
		if (sqlite3_prepare_v2(_db, [sql UTF8String], -1, &_getTablesStatement, NULL) != SQLITE_OK) {
			[self _raiseDBException];
		}
	}
	
	NSMutableArray * tableNames = [NSMutableArray array];
	while (sqlite3_step(_getTablesStatement) == SQLITE_ROW) {
		[tableNames addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(_getTablesStatement, 0)]];
	}
	sqlite3_reset(_getTablesStatement);
	
	// go through all tables and delete/drop
	NSString * currentTranslationHistoryTableName = [NSString stringWithFormat:@"translated_phrases_%@_%@", _sourceLanguage, _destLanguage];
	for (int i = 0; i < [tableNames count]; i++) {
		NSString * tableName = [tableNames objectAtIndex:i];
		NSRange originalPhrasesRange = [tableName rangeOfString:@"original_phrases_"];
		NSRange translatedPhrasesRange = [tableName rangeOfString:@"translated_phrases_"];
		if (originalPhrasesRange.location != NSNotFound || [tableName isEqualToString:currentTranslationHistoryTableName]) {
			// do not drop the current translation history table because we will still need it when the user returns to the main view (translation history tables are only created on dest language switch)
			sqlite3_stmt* deleteTableStatement = nil;
			NSString * sql = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
			if (sqlite3_prepare_v2(_db, [sql UTF8String], -1, &deleteTableStatement, NULL) != SQLITE_OK) {
				[self _raiseDBException];
			}
			 
			sqlite3_step(deleteTableStatement);
			sqlite3_finalize(deleteTableStatement);
		} else if (translatedPhrasesRange.location != NSNotFound) {
			sqlite3_stmt* dropTableStatement = nil;
			NSString * sql = [NSString stringWithFormat:@"DROP TABLE %@", tableName];
			if (sqlite3_prepare_v2(_db, [sql UTF8String], -1, &dropTableStatement, NULL) != SQLITE_OK) {
				[self _raiseDBException];
			}
			
			sqlite3_step(dropTableStatement);
			sqlite3_finalize(dropTableStatement);
		}
	}
	
	[self _importEnglishCommonPhrases];
}

// private methods

- (void)_setNewLanguage:(NSString *)newLanguage withLanguageVar:(NSString **)languageVar {
	// set new language
	if (newLanguage == nil) {
		return;
	} else if (*languageVar == nil) {
		*languageVar = [newLanguage retain];
	} else if ([*languageVar isEqualToString:newLanguage]) {
		return;
	} else {
		[*languageVar release];
		*languageVar = [newLanguage retain];
	}
	
	// precompiled statements are based on both source/dest languages
	[self _finalizePrecompiledStatements];
	
	// create new suggestion/history tables (if applicable)
	[self _createTables];
}

- (void)_createTables {
	// phrase table
	if (_sourceLanguage) {
		NSString * phraseTableSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS original_phrases_%@ (phrase varchar(500), type tinyint, time int)", _sourceLanguage];
		sqlite3_exec(_db, [phraseTableSql UTF8String], NULL, NULL, NULL);
	}
	
	// history table
	if (_sourceLanguage && _destLanguage) {
		NSString * historyTableSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS translated_phrases_%@_%@ (originalPhraseId int64, translation varchar(1000))", _sourceLanguage, _destLanguage];
		sqlite3_exec(_db, [historyTableSql UTF8String], NULL, NULL, NULL);
	}
}

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
			[self _raiseDBException];
		}
	}
}

- (void)_importEnglishCommonPhrases {
	NSString* commonPhrasesFilePath = [[NSBundle mainBundle] pathForResource:@"commonPhrases" ofType:@"csv" inDirectory:nil forLocalization:@"en"];
	NSError* error;
	NSString* commonPhrasesString = [NSString stringWithContentsOfFile:commonPhrasesFilePath encoding:NSUTF8StringEncoding error:&error];
	if (commonPhrasesString != nil) {
		NSArray* commonPhrases = [commonPhrasesString componentsSeparatedByString:@","];

		// compile statement if necessary
		if (_importCommonPhrasesStatement == nil) {
			NSString * sql = [NSString stringWithFormat:@"INSERT INTO original_phrases_en VALUES (?, %d, 0)", kPhraseTypeCommon];
			if (sqlite3_prepare_v2(_db, [sql UTF8String], -1, &_importCommonPhrasesStatement, NULL) != SQLITE_OK) {
				[self _raiseDBException];
			}
		}
		
		for (int i = 0; i < [commonPhrases count]; i++) {
			NSString* commonPhrase = [commonPhrases objectAtIndex:i];
			sqlite3_bind_text(_importCommonPhrasesStatement, 1, [commonPhrase UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_step(_importCommonPhrasesStatement);
			sqlite3_reset(_importCommonPhrasesStatement);
		}
	}
}

- (void)_raiseDBException
{
	[NSException raise:@"db_error" format:@"db_error"];
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

	if (_checkPhraseStatement) {
        sqlite3_finalize(_checkPhraseStatement);
        _checkPhraseStatement = nil;
    }

	if (_checkTranslatedHistoryStatement) {
        sqlite3_finalize(_checkTranslatedHistoryStatement);
        _checkTranslatedHistoryStatement = nil;
    }
	
	if (_addTranslatedHistoryStatement) {
        sqlite3_finalize(_addTranslatedHistoryStatement);
        _addTranslatedHistoryStatement = nil;
    }
	
	if (_getTranslatedHistoryStatement) {
        sqlite3_finalize(_getTranslatedHistoryStatement);
        _getTranslatedHistoryStatement = nil;
    }
	
	if (_updateToHistoryStatement) {
        sqlite3_finalize(_updateToHistoryStatement);
        _updateToHistoryStatement = nil;
    }

	if (_addHistoryStatement) {
        sqlite3_finalize(_addHistoryStatement);
        _addHistoryStatement = nil;
    }

	if (_getTablesStatement) {
        sqlite3_finalize(_getTablesStatement);
        _getTablesStatement = nil;
    }

	if (_importCommonPhrasesStatement) {
        sqlite3_finalize(_importCommonPhrasesStatement);
        _importCommonPhrasesStatement = nil;
    }
}

- (void)dealloc {
	[self _closeDatabase];
	[_sourceLanguage release];
	[_destLanguage release];
	[super dealloc];
}

@end
