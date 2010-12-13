//
//  MainViewController.m
//  VerbatimTranslate
//
//  Created by Matt Weight on 10/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "InfoViewController.h"

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
	if (themeController == nil || (themeController != nil && [themeController getNeedsThemeUpdate])) {
		if (themeController != nil && [themeController.inputBubbleController isViewLoaded]) {
			[themeController.inputBubbleController.view removeFromSuperview];
		}
		if (themeController != nil && [themeController.outputBubbleController isViewLoaded]) {
			[themeController.outputBubbleController.view removeFromSuperview];
		}
		
		ThemeController* theme = [[ThemeController alloc] init]; //[ThemeController sharedController];
		[bgImageView setImage:[UIImage imageNamed:theme.backgroundImageFile]];
		[bgImageView addSubview:theme.inputBubbleController.view];
		themeController = [theme retain];
		[theme release];
		theme = nil;
		
		[themeController.inputBubbleController.bubbleTextView setText:NSLocalizedString(@"Tap here to begin typing..", nil)];
		[themeController.inputBubbleController animate];
	}

	if (flagController == nil) {
		FlagsTableViewController* fController = [[FlagsTableViewController alloc] initWithStyle:UITableViewStylePlain];
		[fController.view setCenter:CGPointMake(-120.0, 400.0)];
		[self.view addSubview:fController.view];
		flagController = [fController retain];
		[fController release];
		fController = nil;
	}
		
	NSLog(@"You two are something else or what?");
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(displayTranslation:)
												 name:@"__TRANSLATE_COMPLETE__"
											   object:nil];

	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(cancelTranslation:)
												 name:@"__TRANSLATE_CANCEL__"
											   object:nil];
	

}

/*
- (void)viewWillDisappear:(BOOL)animated {
	[themeController.inputBubbleController release];
	[themeController.outputBubbleController release];
	[themeController release];
	themeController = nil;
	[flagController release];
	flagController = nil;
}
*/

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
}

- (void)cancelTranslation:(id)sender {
	// TODO - MATT please cleanup... (probably want the previous translation to be displayed...)
	
	[themeController.inputBubbleController.view removeFromSuperview];
	[themeController.inputBubbleController.autoSuggestController.view removeFromSuperview];
	[themeController.outputBubbleController.view removeFromSuperview];
	[themeController.outputBubbleController.autoSuggestController.view removeFromSuperview];
	
	[themeController release];
	themeController = nil;
	
	ThemeController* newTheme = [[ThemeController alloc] init];
	[newTheme.inputBubbleController.bubbleTextView setText:NSLocalizedString(@"Tap here to begin typing..", nil)];
	[bgImageView addSubview:newTheme.inputBubbleController.view];
	
	[newTheme.inputBubbleController animate];
	themeController = [newTheme retain];
	[newTheme release];
	newTheme = nil;
}

- (IBAction)showInfo:(id)sender {
	InfoViewController * infoController = [[InfoViewController alloc] initWithNibName:@"InfoViewController" bundle:[NSBundle mainBundle]];
	infoController.title = NSLocalizedString(@"Verbatim Translate", nil);	// TODO - do in IB
	
	// TODO - do in IB
	UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:infoController];
    navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	navController.navigationBar.barStyle = UIBarStyleBlackOpaque;
	[self presentModalViewController:navController animated:YES];
	
	[navController release];
	[infoController release];
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
