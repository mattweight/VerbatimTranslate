//
//  SpinnerView.m
//  VerbatimTranslate
//
//  Created by Brandon George on 11/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SpinnerView.h"


@implementation SpinnerView


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // transparent background
		self.backgroundColor = [UIColor clearColor];
		
		// text
		UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 84, 20)];
		label.text = NSLocalizedString(@"Submitting...", nil);
		label.font = [UIFont systemFontOfSize:15];
		label.textColor = [UIColor whiteColor];
		label.backgroundColor = self.backgroundColor;
		[self addSubview:label];
		[label release];
		
		// spinner
		UIActivityIndicatorView * spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(25, 40, 50, 50)];
		spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
		[self addSubview:spinner];
		[spinner startAnimating];
		[spinner release];
    }
    return self;
}

// rounded corners
- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetRGBFillColor(context, 0,0,0,0.75);
	
	float radius = 5.0f;
	CGContextMoveToPoint(context, rect.origin.x, rect.origin.y + radius);
	CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + rect.size.height - radius);
	CGContextAddArc(context, rect.origin.x + radius, rect.origin.y + rect.size.height - radius, 
					radius, M_PI / 4, M_PI / 2, 1);
	CGContextAddLineToPoint(context, rect.origin.x + rect.size.width - radius, 
							rect.origin.y + rect.size.height);
	CGContextAddArc(context, rect.origin.x + rect.size.width - radius, 
					rect.origin.y + rect.size.height - radius, radius, M_PI / 2, 0.0f, 1);
	CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + radius);
	CGContextAddArc(context, rect.origin.x + rect.size.width - radius, rect.origin.y + radius, 
					radius, 0.0f, -M_PI / 2, 1);
	CGContextAddLineToPoint(context, rect.origin.x + radius, rect.origin.y);
	CGContextAddArc(context, rect.origin.x + radius, rect.origin.y + radius, radius, 
					-M_PI / 2, M_PI, 1);
	CGContextFillPath(context);
}

- (void)dealloc {
    [super dealloc];
}


@end
