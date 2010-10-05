//
//  WordBubbleView.m
//  BubblePOC
//
//  Created by Matt Weight on 10/5/10.
//  Copyright 2010 Digitaria. All rights reserved.
//

#import "WordBubbleView.h"


@implementation WordBubbleView

@synthesize bubbleImgView;
@synthesize bubbleTextView;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

- (void)setAnimationStep:(ANIMATION_STEP)currentStep {
	animationStep = currentStep;
}

- (ANIMATION_STEP)getAnimationStep {
	return animationStep;
}

- (void)setForceStop:(BOOL)shouldStop {
	forceStop = shouldStop;
}

- (BOOL)getForceStop {
	return forceStop;
}

- (void)animate {
	CGFloat scaleAmount;
	CGFloat duration;
	
	if ((animationStep % 2) == 1) {
		CGFloat diff = (MAX_BUBBLE_BOUNCE - 1.0) / animationStep;
		scaleAmount = 1.0 + diff;
	}

	if (animationStep == 0) {
		scaleAmount = 0.001;
		duration = 0.5;
	}
	else if (animationStep == MAX_ANIMATION_STEP) {
		scaleAmount = 1.00;
		duration = 0.20;
		forceStop = YES;
	}
	else if ((animationStep % 2) == 0) {
		scaleAmount = 1.00;
		duration = 0.10;
	}
	else if ((animationStep % 2) == 1) {
		// Every odd needs to grow so every even can shrink..
		//scaleAmount = 1.20;
		if (animationStep == 1) {
			duration = 0.20;
		}
		else {
			duration = 0.10;
		}
	}

	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:duration];
	if (forceStop) {
		forceStop = NO;
	}
	else {
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animate)];
	}
	[self setTransform:CGAffineTransformMakeScale(scaleAmount, scaleAmount)];
	[UIView commitAnimations];

	animationStep++;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    [super dealloc];
}


@end
