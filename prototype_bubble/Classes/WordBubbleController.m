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
		NSLog(@"We've just loaded a NIB");
		WordBubbleView* bubbleView = (WordBubbleView*)self.view;
		[bubbleView setBackgroundColor:[UIColor clearColor]];
		[bubbleView.bubbleImgView setBackgroundColor:[UIColor clearColor]];
		[bubbleView setCenter:CGPointMake(160.0, 200.0)];
		[bubbleView animate];
        // Custom initialization
    }
    return self;
}

- (void)animate {
	NSLog(@"Controller animate");
	[(WordBubbleView*)self.view animate];
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
