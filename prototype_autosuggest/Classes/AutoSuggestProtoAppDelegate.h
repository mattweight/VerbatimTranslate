//
//  AutoSuggestProtoAppDelegate.h
//  AutoSuggestProto
//
//  Created by Brandon George on 10/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AutoSuggestProtoViewController;

@interface AutoSuggestProtoAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    AutoSuggestProtoViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet AutoSuggestProtoViewController *viewController;

@end

