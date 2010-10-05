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
		NSLog(@"the view is HERE!");
    }
    return self;
}

- (void)animate {
	CGFloat scaleAmount;
	if (!isSmall) {
		scaleAmount = 0.001;
		isSmall = YES;
	}
	else {
		scaleAmount = 1.2;
		isSmall = NO;
	}
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(finalizeAnimation)];
	[self setTransform:CGAffineTransformMakeScale(scaleAmount, scaleAmount)];
//	CGContextSaveGState(UIGraphicsGetCurrentContext());
	[UIView commitAnimations];
}

- (void)finalizeAnimation {
	if (isSmall) {
		return;
	}
	NSLog(@"Should bounce here");

	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[self setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
	//	CGContextSaveGState(UIGraphicsGetCurrentContext());
	[UIView commitAnimations];
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
