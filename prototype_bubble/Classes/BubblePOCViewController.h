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
	WordBubbleController* wordInputController;
	WordBubbleController* wordOutputController;
	IBOutlet UIImageView* sillyImgView;
}

@property (nonatomic, retain) WordBubbleController* wordInputController;
@property (nonatomic, retain) WordBubbleController* wordOutputController;
@property (nonatomic, retain) UIImageView* sillyImgView;

- (IBAction)animateBubble:(id)sender;
- (void)animateOutputBubble:(id)sender;

@end

