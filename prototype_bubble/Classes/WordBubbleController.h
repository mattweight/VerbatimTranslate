//
//  WordBubbleController.h
//  BubblePOC
//
//  Created by Matt Weight on 10/5/10.
//  Copyright 2010 Digitaria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WordBubbleView.h"

#include "VerbatimConstants.h"

@interface WordBubbleController : UIViewController <UITextViewDelegate> {
}

- (void)animate;

// TODO This will be the primary interface for creating word bubble objects. 
// The mainCenter is where the whole view will be positioned on the super view
// and the arrowCenter is where the arrow portion of the bubble should be centered
// on the bubble view
- (id)initWithCenter:(CGPoint)mainCenter arrowCenter:(CGPoint)aCenter;

@end
