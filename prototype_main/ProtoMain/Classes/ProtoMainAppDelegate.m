//
//  ProtoMainAppDelegate.m
//  ProtoMain
//
//  Created by Matt Weight on 9/15/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "ProtoMainAppDelegate.h"
#import "ProtoMainViewController.h"

@implementation ProtoMainAppDelegate

@synthesize window;
@synthesize viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after app launch    
	return YES;
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
