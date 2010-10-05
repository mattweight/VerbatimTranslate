//
//  WordBubbleView.h
//  BubblePOC
//
//  Created by Matt Weight on 10/5/10.
//  Copyright 2010 Digitaria. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "VerbatimConstants.h"

@interface WordBubbleView : UIView {
	IBOutlet UIImageView* bubbleImgView;
	IBOutlet UITextView* bubbleTextView;
	ANIMATION_STEP animationStep;
	BOOL forceStop;
}

@property (nonatomic, retain) UIImageView* bubbleImgView;
@property (nonatomic, retain) UITextView* bubbleTextView;

- (void)animate;

- (void)setAnimationStep:(ANIMATION_STEP)currentStep;
- (ANIMATION_STEP)getAnimationStep;

- (void)setForceStop:(BOOL)shouldStop;
- (BOOL)getForceStop;

@end
