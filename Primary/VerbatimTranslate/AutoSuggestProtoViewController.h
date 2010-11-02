//
//  AutoSuggestProtoViewController.h
//  AutoSuggestProto
//
//  Created by Brandon George on 10/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AutoSuggestProtoViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UIAlertViewDelegate> {

@private
	UITextView* _textInput;
	UITableView* _suggestionsTable;
	NSArray* _suggestions;
}

@property (nonatomic, retain) IBOutlet UITextView* textInput;
@property (nonatomic, retain) IBOutlet UITableView* suggestionsTable;
@property (nonatomic, retain) NSArray* suggestions;

- (void)submitText:(NSString *)text;
- (void)_filterSuggestionsWithString:(NSString *)filterString;

@end

