//
//  WordBubbleView.h
//  BubblePOC
//
//  Created by Matt Weight on 10/5/10.
//  Copyright 2010 Digitaria. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WordBubbleView : UIView {
	IBOutlet UIImageView* bubbleImgView;
	BOOL isSmall;
}

@property (nonatomic, retain) UIImageView* bubbleImgView;

- (void)animate;

@end
