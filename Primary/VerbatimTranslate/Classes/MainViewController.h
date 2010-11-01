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
}

@property (nonatomic, retain) UIImageView* bgImageView;

- (IBAction)showInfo:(id)sender;

@end
