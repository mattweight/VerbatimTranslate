//
//  MainViewController.h
//  VerbatimTranslate
//
//  Created by Matt Weight on 10/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FlipsideViewController.h"
#import "ThemeController.h"
#import "FlagsTableViewController.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate> {
	IBOutlet UIImageView* bgImageView;
	ThemeController* themeController;
	FlagsTableViewController* flagController;
}

@property (nonatomic, retain) UIImageView* bgImageView;
@property (nonatomic, retain) ThemeController* themeController;
@property (nonatomic, retain) FlagsTableViewController* flagController;

- (IBAction)showInfo:(id)sender;
- (void)displayTranslation:(id)sender;

@end
