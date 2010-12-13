//
//  InfoViewController.h
//  InfoProto
//
//  Created by Brandon George on 10/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface InfoViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate> {
	UITableView * _tableView;
	UILabel * _aboutLabel;
	UITextView * _aboutText;
	NSArray * _settings;
}

@property (nonatomic, retain) IBOutlet UITableView * tableView;
@property (nonatomic, retain) IBOutlet UILabel * aboutLabel;
@property (nonatomic, retain) IBOutlet UITextView * aboutText;

- (IBAction)showMainView:(id)sender;
- (void)showQuoteView;
- (void)showHistoryWarning;
@end
