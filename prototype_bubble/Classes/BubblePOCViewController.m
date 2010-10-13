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

@synthesize wordInputController;
@synthesize wordOutputController;
@synthesize sillyImgView;

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
	WordBubbleController* inController = [[WordBubbleController alloc] initWithNibName:@"WordBubbleInputController" bundle:nil];
	[inController.view setHidden:YES];
	[inController.view setCenter:CGPointMake(186, 112)];
//	[inController.view setFrame:CGRectMake(43, 42, 285, 141)];
	NSLog(@"(1) current point is %02.f", inController.view.center.x);
	NSLog(@"(1) current point is %02.f", inController.view.center.y);

	[self.view addSubview:inController.view];
	wordInputController = [inController retain];
	[inController release];
	inController = nil;
	
	WordBubbleController* outController = [[WordBubbleController alloc] initWithNibName:@"WordBubbleOutputController" bundle:nil];
	[outController.view setHidden:YES];
	[outController.view setCenter:CGPointMake(132, 374)];
//	[outController.view setFrame:CGRectMake(10, 304, 285, 141)];
	NSLog(@"(2) current point is %02.f", outController.view.center.x);
	NSLog(@"(2) current point is %02.f", outController.view.center.y);
	[self.view addSubview:outController.view];
	wordOutputController = [outController retain];
	[outController release];
	outController = nil;
}

- (void)viewDidAppear:(BOOL)animated {
//	[wordInputController.view setHidden:NO];
//	[wordOutputController.view setHidden:NO];
}

- (IBAction)animateBubble:(id)sender {
	if ([wordInputController.view isHidden]) {
		[wordInputController.view setHidden:NO];
	}
	if ([wordOutputController.view isHidden]) {
		[wordOutputController.view setHidden:NO];
	}
	NSLog(@"animateBubble called!");
	[wordInputController animate];
	if (![sillyImgView isHidden]) {
		[wordOutputController animate];
		[sillyImgView setHidden:YES];
	}
	else {
		[self performSelector:@selector(animateOutputBubble:) withObject:nil afterDelay:2.0];
	}
//	WordBubbleView* viewRef = (WordBubbleView*)wordInputController.view;
//	[viewRef animate];
}

- (void)animateOutputBubble:(id)sender {
	[sillyImgView setHidden:NO];
	[wordOutputController animate];
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
	[wordInputController release];
	wordInputController = nil;
	[wordOutputController release];
	wordOutputController = nil;
	
    [super dealloc];
}

@end
