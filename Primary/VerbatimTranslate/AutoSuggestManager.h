//
//  AutoSuggestManager.h
//  ToolbarSearch
//
//  Created by Brandon George on 9/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <sqlite3.h>

@interface AutoSuggestManager : NSObject {

@private
	NSString * _sourceLanguage;
	NSString * _destLanguage;
	sqlite3 * _db;
	
	// pre-compiled sql statements
	sqlite3_stmt * _getAllPhrasesStatement;
	sqlite3_stmt * _checkPhraseStatement;
	sqlite3_stmt * _addTranslatedHistoryStatement;
	sqlite3_stmt * _getTranslatedHistoryStatement;
	sqlite3_stmt * _updateToHistoryStatement;
	sqlite3_stmt * _addHistoryStatement;
	sqlite3_stmt * _clearHistoryStatement;
}

@property (nonatomic, retain) NSString * sourceLanguage;
@property (nonatomic, retain) NSString * destLanguage;

+ (AutoSuggestManager *)sharedInstance;
- (id)init;
- (NSDictionary *)getAllPhrases:(NSString *)filterString;
- (NSString *)getTranslatedPhrase:(long long)originalPhraseId;
- (void)addToHistory:(NSString *)originalText translatedText:(NSString *)translatedText;
- (void)clearHistory;

@end
