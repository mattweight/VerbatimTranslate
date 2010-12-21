//
//  FlagTableViewCell.m
//  VerbatimTranslate
//
//  Created by Matt Weight on 11/4/10.
//  Copyright 2010 Digitaria. All rights reserved.
//

#import "FlagTableViewCell.h"
#import "math.h"

@implementation FlagTableViewCell

static inline double radians (double degrees) {return degrees * M_PI/180;}

@synthesize flagImageView;
@synthesize flagLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
		[self setBackgroundColor:[UIColor clearColor]];
		//[self setFrame:CGRectMake(0.0, 0.0, 40.0, 40.0)];
		for (UIView* subView in [self subviews]) {
			[subView removeFromSuperview];
		}
		UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 27.0, 40.0)];
		[imgView setCenter:CGPointMake(((imgView.frame.size.width / 2.0) + 2.0), self.center.y)];
		[imgView setBackgroundColor:[UIColor clearColor]];
		[self addSubview:imgView];
		flagImageView = [imgView retain];
		[imgView release];
		imgView = nil;
	
		UILabel* imgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 40.0, 26.0)];
		[imgLabel setFont:[UIFont systemFontOfSize:8.0]];
		[imgLabel setNumberOfLines:2];
		[imgLabel setTransform:CGAffineTransformMakeRotation(radians(-90))];
		[imgLabel setCenter:CGPointMake(((27.0 + (26.0 / 2.0)) + 2.0), self.center.y)];
		[imgLabel setTextAlignment:UITextAlignmentCenter];
		[self addSubview:imgLabel];
		flagLabel = [imgLabel retain];
		[imgLabel release];
		imgLabel = nil;
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
