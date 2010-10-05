//
//  BubblePOCAppDelegate.h
//  BubblePOC
//
//  Created by Matt Weight on 10/5/10.
//  Copyright 2010 Digitaria. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BubblePOCViewController;

@interface BubblePOCAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    BubblePOCViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet BubblePOCViewController *viewController;

@end

