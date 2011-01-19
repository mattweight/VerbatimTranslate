//
//  AutoSuggestProtoViewController.h
//  AutoSuggestProto
//
//  Created by Brandon George on 10/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AutoSuggestProtoViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate> {

@private
	UITextView* _textInput;
	UITableView* _suggestionsTable;
	NSMutableData* _translateData;
	NSArray* _suggestions;
	NSArray* _historyPhraseIds;
}

@property (nonatomic, retain) IBOutlet UITextView* textInput;
@property (nonatomic, retain) IBOutlet UITableView* suggestionsTable;
@property (nonatomic, retain) NSArray* suggestions;
@property (nonatomic, retain) NSArray* historyPhraseIds;

@end
