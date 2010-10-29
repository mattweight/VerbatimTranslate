//
//  InfoProtoAppDelegate.h
//  InfoProto
//
//  Created by Brandon George on 10/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InfoProtoViewController;

@interface InfoProtoAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    InfoProtoViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet InfoProtoViewController *viewController;

@end

