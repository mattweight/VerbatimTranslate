//
//  MainViewController.h
//  VerbatimTranslate
//
//  Created by Matt Weight on 10/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ThemeController.h"
#import "FlagsTableViewController.h"

@interface MainViewController : UIViewController <UIAlertViewDelegate> {
	IBOutlet UIImageView* bgImageView;
	ThemeController* themeController;
	FlagsTableViewController* flagController;
}

@property (nonatomic, retain) UIImageView* bgImageView;
@property (nonatomic, retain) ThemeController* themeController;
@property (nonatomic, retain) FlagsTableViewController* flagController;

- (IBAction)showInfo:(id)sender;
- (void)displayTranslation:(id)sender;
- (void)cancelTranslation:(id)sender;
- (void)updateTheme:(NSNotification*)notif;

@end
