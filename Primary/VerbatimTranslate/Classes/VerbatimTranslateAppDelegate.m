//
//  VerbatimTranslateAppDelegate.m
//  VerbatimTranslate
//
//  Created by Matt Weight on 10/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "VerbatimTranslateAppDelegate.h"
#import "MainViewController.h"
#import "ThemeManager.h"
#import "VerbatimConstants.h"

@implementation VerbatimTranslateAppDelegate

@synthesize window;
@synthesize mainViewController;
@synthesize loadingView;
@synthesize loadingLabel;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
	
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(displayActivityView:)
												 name:DISPLAY_ACTIVITY_VIEW
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(removeActivityView)
												 name:REMOVE_ACTIVITY_VIEW
											   object:nil];
	
	[window addSubview:loadingView];
    [window makeKeyAndVisible];
	
	[self performSelectorInBackground:@selector(doPreLoad:) withObject:nil];
	
    return YES;
}

- (void)displayActivityView:(NSNotification*)notify {
	[self.loadingView setCenter:window.center];
	if ([notify userInfo] != nil) {
		if ([[notify userInfo] objectForKey:@"load-text"] != nil) {
			[self.loadingLabel setText:[[notify userInfo] objectForKey:@"load-text"]];
		}
	}
	[window addSubview:self.loadingView];
}

- (void)removeActivityView {
	[self.loadingView removeFromSuperview];
	[self.loadingLabel setText:@""];
}

- (void)displayGenericError {
	NSString * message = NSLocalizedString(@"We're sorry, an error has occurred.  Please try again.", nil);
	UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Verbatim Translate", nil) message:message delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (void)doPreLoad:(id)sender {
	NSAutoreleasePool* arPool = [[NSAutoreleasePool alloc] init];
	[ThemeManager sharedThemeManager];
	//	NSError* preloadError = nil;
	//	[manager nextThemeUsingName:@"French EU" error:&preloadError];
	[arPool drain];
	[self performSelectorOnMainThread:@selector(didFinishPreLoad:)
						   withObject:nil
						waitUntilDone:NO];
}

- (void)didFinishPreLoad:(NSNotification*)notif {
	[window addSubview:mainViewController.view];
	[self.loadingView removeFromSuperview];
}

//Called by Reachability whenever status changes.
- (void) reachabilityChanged: (NSNotification* )note {
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    BOOL connectionRequired = [curReach connectionRequired];
	
    if (netStatus == kNotReachable && connectionRequired) {
        if (![networkAlert isVisible]) {   
            if (networkAlert != nil) {
                [networkAlert release];
            }
            networkAlert = [[UIAlertView alloc] initWithTitle:@"No Network!"
                                                      message:@"An internet connection is required to continue."
                                                     delegate:self
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
            [networkAlert show];
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
	//	[self applicationWillTerminate:application];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [mainViewController release];
    [window release];
    [super dealloc];
}

@end
