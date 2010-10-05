//
//  BubblePOCViewController.m
//  BubblePOC
//
//  Created by Matt Weight on 10/5/10.
//  Copyright 2010 Digitaria. All rights reserved.
//

#import "BubblePOCViewController.h"
#import "WordBubbleView.h"

@implementation BubblePOCViewController

@synthesize wordController;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

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


- (void)viewWillAppear:(BOOL)animated {
	WordBubbleController* aController = [[WordBubbleController alloc] initWithNibName:@"WordBubbleController" bundle:nil];
	[self.view addSubview:aController.view];
	wordController = [aController retain];
	[aController release];
	aController = nil;
}

- (IBAction)animateBubble:(id)sender {
	NSLog(@"animateBubble called!");
	[wordController animate];
//	WordBubbleView* viewRef = (WordBubbleView*)wordController.view;
//	[viewRef animate];
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
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
