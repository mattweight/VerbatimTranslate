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
	IBOutlet UITextView* textViewRef;
	IBOutlet UIImageView* imgView;
	IBOutlet UIImageView* topArrowView;
	IBOutlet UIImageView* bottomArrowView;
	ANIMATION_STEP animationStep;

	CGRect originalViewFrame;
	CGRect originalTextFrame;
	CGFloat originalViewAlpha;
	CGFloat originalTextAlpha;
	BOOL isTopArrow;
	BOOL forceStop;
	NSObject* caller;
}

@property (nonatomic, retain) NSObject* caller;
@property (nonatomic, retain) UITextView* textViewRef;
@property (nonatomic, retain) UIImageView* imgView;
@property (nonatomic, retain) UIImageView* topArrowView;
@property (nonatomic, retain) UIImageView* bottomArrowView;

- (void)animate;
- (void)reverseAnimate;

- (void)setAnimationStep:(ANIMATION_STEP)currentStep;
- (ANIMATION_STEP)getAnimationStep;

- (void)setForceStop:(BOOL)shouldStop;
- (BOOL)getForceStop;

- (void)expandTextViewToFrame:(CGRect)textFrame;
- (void)finalizeExpanding;

@end
