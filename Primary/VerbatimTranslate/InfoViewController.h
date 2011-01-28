//
//  InfoViewController.h
//  InfoProto
//
//  Created by Brandon George on 10/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlagsTableViewController.h"

@interface InfoViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate> {
	UITableView * _tableView;
	UITableView* borderTableView;
	UILabel * _aboutLabel;
	UITextView * _aboutText;
	NSArray * _settings;
	FlagsTableViewController* sourceFlagController;
}

@property (nonatomic, retain) IBOutlet UITableView * tableView;
@property (nonatomic, retain) IBOutlet UILabel * aboutLabel;
@property (nonatomic, retain) IBOutlet UITextView * aboutText;
@property (nonatomic, retain) IBOutlet UITableView* borderTableView;
@property (nonatomic, retain) IBOutlet FlagsTableViewController* sourceFlagController;

- (IBAction)showMainView:(id)sender;
- (void)showQuoteView;
- (void)showHistoryWarning;
- (void)_changeSourceLanguage:(NSString *)language;
- (void)_removeActivityView:(NSTimer *)timer;

@end
