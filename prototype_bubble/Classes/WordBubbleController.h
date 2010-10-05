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

@end
