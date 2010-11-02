//
//  MainViewController.h
//  VerbatimTranslate
//
//  Created by Matt Weight on 10/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FlipsideViewController.h"
#import "ThemeController.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate> {
	IBOutlet UIImageView* bgImageView;
	ThemeController* themeController;
}

@property (nonatomic, retain) UIImageView* bgImageView;
@property (nonatomic, retain) ThemeController* themeController;

- (IBAction)showInfo:(id)sender;
- (void)displayTranslation:(id)sender;

@end
