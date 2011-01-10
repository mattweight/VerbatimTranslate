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
	NSMutableData* _translateData;
	NSArray* _suggestions;
}

@property (nonatomic, retain) IBOutlet UITextView* textInput;
@property (nonatomic, retain) IBOutlet UITableView* suggestionsTable;
@property (nonatomic, retain) NSArray* suggestions;

- (void)submitText:(NSString *)text;
- (void)_filterSuggestionsWithString:(NSString *)filterString;
- (void)_onCancelButton:(id)sender;
- (void)_onClearButton:(id)sender;

@end

