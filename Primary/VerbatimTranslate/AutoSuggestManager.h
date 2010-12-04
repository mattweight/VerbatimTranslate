//
//  AutoSuggestManager.h
//  ToolbarSearch
//
//  Created by Brandon George on 9/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <sqlite3.h>

// TODO - misnomer (history / common phrases could exist without auto-suggest)
// TODO - "phrase" should be "suggestion"?
@interface AutoSuggestManager : NSObject {

@private
	NSString * _language;
	sqlite3 * _db;
	
	// pre-compiled sql statements
	sqlite3_stmt * _getAllPhrasesStatement;
	sqlite3_stmt * _getHistoryStatement;
	sqlite3_stmt * _checkPhraseStatement;
	sqlite3_stmt * _updateToHistoryStatement;
	sqlite3_stmt * _addHistoryStatement;
	sqlite3_stmt * _clearHistoryStatement;
}

@property (nonatomic, retain) NSString * language;

+ (AutoSuggestManager *)sharedInstanceWithLanguage:(NSString *)language;
- (id)initWithLanguage:(NSString *)language;
- (void)addToHistory:(NSString *)from to:(NSString *)to toLanguage:(NSString *)toLanguage;
- (void)downloadCommonPhrases:(NSString *)toLanguage;
- (NSMutableArray *)getAllPhrases:(NSString *)filterString;
- (NSMutableArray *)getAllPhrases;
- (NSMutableArray *)getHistory;
- (NSString *)getHistoryTranslation:(NSString *)from;
- (void)clearHistory;

@end
