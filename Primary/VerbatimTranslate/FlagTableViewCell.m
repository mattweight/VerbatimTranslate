//
//  FlagTableViewCell.m
//  VerbatimTranslate
//
//  Created by Matt Weight on 11/4/10.
//  Copyright 2010 Digitaria. All rights reserved.
//

#import "FlagTableViewCell.h"


@implementation FlagTableViewCell

@synthesize flagImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
		[self setBackgroundColor:[UIColor clearColor]];
		[self setFrame:CGRectMake(0.0, 0.0, 40.0, 40.0)];
		for (UIView* subView in [self subviews]) {
			[subView removeFromSuperview];
		}
		UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 27.0, 40.0)];
		[imgView setCenter:self.center];
		[self addSubview:imgView];
		flagImageView = [imgView retain];
		[imgView release];
		imgView = nil;
    }
    return self;
}

- (NSInteger)getFlagID {
	return flagID;
}

- (void)setFlagID:(NSInteger)newFlagID {
	flagID = newFlagID;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
    [super dealloc];
}


@end
