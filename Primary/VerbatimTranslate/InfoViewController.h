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
	UITableView* menuTableView;
	UITableView* borderTableView;
	UIImageView* sourceBackgroundView;
	NSArray * _settings;
	FlagsTableViewController* sourceFlagController;
}

@property (nonatomic, retain) IBOutlet UITableView* menuTableView;
@property (nonatomic, retain) IBOutlet UITableView* borderTableView;
@property (nonatomic, retain) IBOutlet FlagsTableViewController* sourceFlagController;
@property (nonatomic, retain) IBOutlet UIImageView* sourceBackgroundView;

- (IBAction)showMainView:(id)sender;
- (void)showQuoteView;
- (void)showHistoryWarning;
- (void)_changeSourceLanguage:(NSString *)language;
- (void)_updateVisibleText;
- (NSString *)_getAboutViewText;
- (NSArray *)_getSettingsArray;

@end
