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
		scaleAmount = 0.1;
		isSmall = YES;
	}
	else {
		scaleAmount = 1.0;
		isSmall = NO;
	}
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[self setTransform:CGAffineTransformMakeScale(scaleAmount, scaleAmount)];
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
