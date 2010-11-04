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
@synthesize themeController;
@synthesize flagController;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
/*
- (void)viewDidLoad {
	[super viewDidLoad];
}
*/

- (void)viewWillAppear:(BOOL)animated {
	ThemeController* theme = [[ThemeController alloc] init]; //[ThemeController sharedController];
	[bgImageView setImage:[UIImage imageNamed:theme.backgroundImageFile]];
	[bgImageView addSubview:theme.inputBubbleController.view];
	[theme.inputBubbleController.bubbleTextView setText:@"Tap here to begin typing.."];
	[theme.inputBubbleController animate];
	themeController = [theme retain];
	[theme release];
	theme = nil;
//	[theme.outputBubbleController animate];
	
	FlagsTableViewController* fController = [[FlagsTableViewController alloc] initWithStyle:UITableViewStylePlain];
	[fController.view setCenter:CGPointMake(-120.0, 40.0)];
	[self.view addSubview:fController.view];
	flagController = [fController retain];
	[fController release];
	fController = nil;

	NSLog(@"You two are something else or what?");
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(displayTranslation:)
												 name:@"__TRANSLATE_COMPLETE__"
											   object:nil];
}

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)displayTranslation:(id)sender {
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	NSString* origText = (NSString*)[defaults stringForKey:@"__VERBATIM_DIGITAL_ORIGINAL_TEXT__"];
	NSString* transText = (NSString*)[defaults stringForKey:@"__VERBATIM_DIGITAL_TRANSLATED_TEXT__"];
	
	NSLog(@"Original text is: %@", origText);
	NSLog(@"Translated text is: %@", transText);
	
	[themeController.inputBubbleController.view removeFromSuperview];
	[themeController.inputBubbleController.autoSuggestController.view removeFromSuperview];
	[themeController.outputBubbleController.view removeFromSuperview];
	[themeController.outputBubbleController.autoSuggestController.view removeFromSuperview];
	
	[themeController release];
	themeController = nil;

	ThemeController* newTheme = [[ThemeController alloc] init];
	[newTheme.inputBubbleController.bubbleTextView setText:origText];
	[newTheme.outputBubbleController.bubbleTextView setText:transText];
	
	[bgImageView addSubview:newTheme.inputBubbleController.view];
	[bgImageView addSubview:newTheme.outputBubbleController.view];
	
	[newTheme.inputBubbleController animate];
	[newTheme.outputBubbleController animate];
	themeController = [newTheme retain];
	[newTheme release];
	newTheme = nil;

	/*
	[(WordBubbleView*)themeController.inputBubbleController.view setAnimationStep:1];
	[themeController.inputBubbleController.bubbleTextView setText:origText];
	
	[(WordBubbleView*)themeController.outputBubbleController.view setAnimationStep:1];
	[themeController.outputBubbleController.bubbleTextView setText:transText];

	[self.view addSubview:themeController.inputBubbleController.view];
	[self.view addSubview:themeController.outputBubbleController.view];
	
	[themeController.inputBubbleController animate];
	[themeController.outputBubbleController animate];
	*/
	/*
	themeController = [newTheme retain];
	[newTheme release];
	newTheme = nil;
	*/
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
