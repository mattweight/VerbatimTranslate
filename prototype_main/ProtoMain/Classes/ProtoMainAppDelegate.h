//
//  ProtoMainAppDelegate.h
//  ProtoMain
//
//  Created by Matt Weight on 9/15/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProtoMainViewController;

@interface ProtoMainAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    ProtoMainViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet ProtoMainViewController *viewController;

@end

