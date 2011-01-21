//
//  VerbatimTranslateAppDelegate.h
//  VerbatimTranslate
//
//  Created by Matt Weight on 10/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@class MainViewController;

@interface VerbatimTranslateAppDelegate : NSObject <UIApplicationDelegate, UIAlertViewDelegate> {
    UIWindow *window;
    MainViewController *mainViewController;
	UIAlertView* networkAlert;
	UIView* loadingView;
	UILabel* loadingLabel;
}

@property (nonatomic, retain) IBOutlet UIView* loadingView;
@property (nonatomic, retain) IBOutlet UILabel* loadingLabel;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MainViewController *mainViewController;

- (void)doPreLoad:(id)sender;
- (void)didFinishPreLoad:(NSNotification*)notif;
- (void)displayActivityView:(NSNotification*)notify;
- (void)removeActivityView;
- (void)displayGenericError;

@end

