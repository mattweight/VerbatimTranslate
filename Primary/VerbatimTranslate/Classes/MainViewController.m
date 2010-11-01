//
//  MainViewController.m
//  VerbatimTranslate
//
//  Created by Matt Weight on 10/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"


@implementation MainViewController

@synthesize bgImageView;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
/*
- (void)viewDidLoad {
	[super viewDidLoad];
}
*/

- (void)viewWillAppear:(BOOL)animated {
	ThemeController* theme = [ThemeController sharedController];
	[bgImageView setImage:[UIImage imageNamed:theme.backgroundImageFile]];
	[bgImageView addSubview:theme.inputBubbleController.view];
	[theme.inputBubbleController.bubbleTextView setEditable:YES];
	[theme.inputBubbleController.bubbleTextView setUserInteractionEnabled:YES];
	[theme.inputBubbleController.bubbleTextView setText:@"Tap here to begin typing.."];
	[theme.inputBubbleController animate];
//	[theme.outputBubbleController animate];
}

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)showInfo:(id)sender {
	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void)dealloc {
    [super dealloc];
}


@end