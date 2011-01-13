//
//  MainViewController.h
//  VerbatimTranslate
//
//  Created by Matt Weight on 10/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FlagsTableViewController.h"
#import "WordBubbleController.h"

@interface MainViewController : UIViewController <UIAlertViewDelegate> {
	IBOutlet UIImageView* bgImageView;
	FlagsTableViewController* flagController;
	WordBubbleController* inController;
	WordBubbleController* outController;
	NSMutableString* currentLanguage;
}

@property (nonatomic, retain) UIImageView* bgImageView;
@property (nonatomic, retain) FlagsTableViewController* flagController;
@property (nonatomic, retain) IBOutlet WordBubbleController* inController;
@property (nonatomic, retain) IBOutlet WordBubbleController* outController;
@property (nonatomic, retain) NSMutableString* currentLanguage;


- (IBAction)showInfo:(id)sender;
- (void)displayTranslation:(id)sender;
- (void)cancelTranslation:(id)sender;
- (void)updateTheme:(NSNotification*)notif;

@end
