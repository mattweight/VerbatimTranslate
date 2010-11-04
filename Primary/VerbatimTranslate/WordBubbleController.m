//
//  WordBubbleController.m
//  BubblePOC
//
//  Created by Matt Weight on 10/5/10.
//  Copyright 2010 Digitaria. All rights reserved.
//

#import "WordBubbleController.h"
#import "AutoSuggestProtoViewController.h"


@implementation WordBubbleController

@synthesize bubbleTextView;
@synthesize topArrowImageView;
@synthesize bottomArrowImageView;
@synthesize bubbleImageView;
@synthesize autoSuggestController;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nil])) {
		WordBubbleView* bubbleView = (WordBubbleView*)self.view;
		[bubbleView setBackgroundColor:[UIColor clearColor]];
		[bubbleImageView setBackgroundColor:[UIColor clearColor]];

		// TODO this will be driven by the serialized animation schema.
		[bubbleView setAnimationStep:0]; // Starting point means shorties
		[bubbleView setForceStop:YES];
		[bubbleTextView setBackgroundColor:[UIColor clearColor]];
		[bubbleView setAlpha:0.90];
		
		// TODO Just to keep the aspect ration full-sized, so we shrink instead of grow the first time
		//      Need to do this the more correct way.
		[bubbleView animate];
		[bubbleView setCaller:self];
        // Custom initialization
    }
    return self;
}

- (IBAction)expandTextInput:(id)sender {
	AutoSuggestProtoViewController* autoController = [[AutoSuggestProtoViewController alloc] initWithNibName:@"AutoSuggestProtoViewController" bundle:nil];
	[autoController.view setHidden:YES];
//	[autoController.view setCenter:[[self.view superview] center]];
	[[self.view superview] addSubview:autoController.view];
	autoSuggestController = [autoController retain];
	[autoController release];
	autoController = nil;

	NSLog(@"Something else here with the ROPE!");
	NSLog(@"There is something here: %@", autoSuggestController.view.frame);
//	NSLog(@"auto frame: %02f", autoSuggestController.view.frame.size.width);
	[(WordBubbleView*)self.view expandTextViewToFrame:autoSuggestController.view.frame];
}

- (void)displayAutoSuggestView:(id)sender {
	NSLog(@"We are showing it RIGHT NOW!");
	[autoSuggestController.view setHidden:NO];
	[self.view removeFromSuperview];
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
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
	[textView resignFirstResponder];
	return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
	[textView resignFirstResponder];
}

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
