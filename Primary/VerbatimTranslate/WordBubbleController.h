//
//  WordBubbleController.h
//  BubblePOC
//
//  Created by Matt Weight on 10/5/10.
//  Copyright 2010 Digitaria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WordBubbleView.h"
#import "AutoSuggestProtoViewController.h"
#include "VerbatimConstants.h"

@interface WordBubbleController : UIViewController <UITextViewDelegate> {
	IBOutlet UIImageView* bubbleImageView;
	IBOutlet UIImageView* topArrowImageView;
	IBOutlet UIImageView* bottomArrowImageView;
 	IBOutlet UITextView* bubbleTextView;
	AutoSuggestProtoViewController* autoSuggestController;
	CGFloat arrowX;
}

@property (nonatomic, retain) UIImageView* bottomArrowImageView;
@property (nonatomic, retain) UIImageView* topArrowImageView;
@property (nonatomic, retain) UIImageView* bubbleImageView;
@property (nonatomic, retain) UITextView* bubbleTextView;
@property (nonatomic, retain) AutoSuggestProtoViewController* autoSuggestController;

- (IBAction)expandTextInput:(id)sender;
- (void)displayAutoSuggestView:(id)sender;
- (void)animate;
- (void)reset;

// TODO This will be the primary interface for creating word bubble objects. 
// The mainCenter is where the whole view will be positioned on the super view
// and the arrowCenter is where the arrow portion of the bubble should be centered
// on the bubble view
//- (id)initWithCenter:(CGPoint)mainCenter arrowCenter:(CGPoint)aCenter;

@end
