//
//  FlagTableViewCell.h
//  VerbatimTranslate
//
//  Created by Matt Weight on 11/4/10.
//  Copyright 2010 Digitaria. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FlagTableViewCell : UITableViewCell {
	UIImageView* flagImageView;
	UILabel* flagLabel;
	NSInteger flagID;
}

@property (nonatomic, retain) UIImageView* flagImageView;
@property (nonatomic, retain) UILabel* flagLabel;

- (void)setFlagID:(NSInteger)newFlagID;
- (NSInteger)getFlagID;

@end
