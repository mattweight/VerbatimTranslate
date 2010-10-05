//
//  WordBubbleController.m
//  BubblePOC
//
//  Created by Matt Weight on 10/5/10.
//  Copyright 2010 Digitaria. All rights reserved.
//

#import "WordBubbleController.h"


@implementation WordBubbleController

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		WordBubbleView* bubbleView = (WordBubbleView*)self.view;
		[bubbleView setBackgroundColor:[UIColor clearColor]];
		[bubbleView.bubbleImgView setBackgroundColor:[UIColor clearColor]];
		// TODO this will be driven by the serialized animation schema.
		[bubbleView setCenter:CGPointMake(181.0, 105.0)];
		[bubbleView setAnimationStep:0]; // Starting point means shorties
		[bubbleView setForceStop:YES];
		[bubbleView.bubbleTextView setBackgroundColor:[UIColor clearColor]];
		[bubbleView setAlpha:0.7];
		
		// TODO Just to keep the aspect ration full-sized, so we shrink instead of grow the first time
		//      Need to do this the more correct way.
		[bubbleView animate]; 
        // Custom initialization
    }
    return self;
}

- (void)animate {
	NSLog(@"Controller animate");
	WordBubbleView* theView = (WordBubbleView*)self.view;

	// Already large
	if ([theView getAnimationStep] >= MAX_ANIMATION_STEP) {
		[theView setAnimationStep:0];
		[theView setForceStop:YES];
	}
	else if ([theView getAnimationStep] == 0) {
		// Use the first step AFTER the zero-size
		[theView setAnimationStep:1];
		[theView setForceStop:NO];
	}
	[theView animate];
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
- (void)viewWillAppear:(BOOL)animated {
	NSLog(@"The word bubble controller view is going to appear");
}
*/

#
#pragma mark UITextViewDelegate
#


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
