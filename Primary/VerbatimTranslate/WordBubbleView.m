//
//  WordBubbleView.m
//  BubblePOC
//
//  Created by Matt Weight on 10/5/10.
//  Copyright 2010 Digitaria. All rights reserved.
//

#import "WordBubbleView.h"


@implementation WordBubbleView

@synthesize caller;
@synthesize textViewRef;
@synthesize imgView;
@synthesize topArrowView;
@synthesize bottomArrowView;

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

- (void)expandTextViewToFrame:(CGRect)textFrame {
	NSLog(@"Expanding text view here: %.02f", textFrame.size.width);
	[topArrowView setHidden:YES];
	[bottomArrowView setHidden:YES];
	[imgView setHidden:YES];
	[self setBackgroundColor:[UIColor whiteColor]];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDidStopSelector:@selector(finalizeExpanding)];
	[imgView setBackgroundColor:[UIColor whiteColor]];
	[self setAlpha:1.0];
	[self setBackgroundColor:[UIColor whiteColor]];
	[textViewRef setBackgroundColor:[UIColor whiteColor]];
	[textViewRef setAlpha:1.0];
	[textViewRef setText:@""];

	// textFrame.size.width + 40.0, textFrame.size.height + 40.0)];
	[self setFrame:CGRectMake(0.0, 0.0, 320.0, 60.0)];

	// textFrame.size.width + 40.0, textFrame.size.height + 40.0)];
	[textViewRef setFrame:CGRectMake(0.0, 0.0, 320.0, 60.0)];

	[UIView commitAnimations];
}

- (void)finalizeExpanding {
	NSLog(@"Should be displaying auto-suggest");
	if (caller != nil && [caller respondsToSelector:@selector(displayAutoSuggestView:)]) {
		[caller displayAutoSuggestView:nil];
	}
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
	NSLog(@"The touches began NOW and not later.");
	if (caller != nil && [caller respondsToSelector:@selector(expandTextInput:)]) {
		[caller expandTextInput:nil];
	}
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
