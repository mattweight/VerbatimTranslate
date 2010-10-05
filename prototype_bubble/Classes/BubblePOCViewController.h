//
//  BubblePOCViewController.h
//  BubblePOC
//
//  Created by Matt Weight on 10/5/10.
//  Copyright 2010 Dig	itaria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WordBubbleController.h"


@interface BubblePOCViewController : UIViewController {
	WordBubbleController* wordController;
}

@property (nonatomic, retain) WordBubbleController* wordController;

- (IBAction)animateBubble:(id)sender;

@end

