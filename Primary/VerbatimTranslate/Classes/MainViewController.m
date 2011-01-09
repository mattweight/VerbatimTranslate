//
//  MainViewController.m
//  VerbatimTranslate
//
//  Created by Matt Weight on 10/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "InfoViewController.h"	
#import "FlagTableViewCell.h"
#import "ThemeManager.h"
#import "VerbatimConstants.h"

@implementation MainViewController

@synthesize bgImageView;
@synthesize themeController;
@synthesize flagController;
@synthesize inController;
@synthesize outController;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(updateTheme:)
												 name:THEME_UPDATE_NOTIFICATION
											   object:nil];

	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(displayTranslation:)
												 name:TRANSLATION_DID_COMPLETE_NOTIFICATION
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(cancelTranslation:)
												 name:TRANSLATION_DID_CANCEL_NOTIFICATION
											   object:nil];	
}

- (void)updateTheme:(NSNotification*)notif {
	NSDictionary* uInfo = (NSDictionary*)[notif userInfo];
	NSString* languageName = nil;
	
	if (uInfo == nil) {
		languageName = [[NSUserDefaults standardUserDefaults] stringForKey:CURRENT_LANGUAGE_STORE_KEY];
		if (languageName == nil) {
			languageName = DEFAULT_LANGUAGE_NAME;
		}
	}
	else {
		languageName = (NSString*)[uInfo objectForKey:@"language"];
		if (languageName == nil) {
			languageName = [[NSUserDefaults standardUserDefaults] stringForKey:CURRENT_LANGUAGE_STORE_KEY];
			if (languageName == nil) {
				languageName = DEFAULT_LANGUAGE_NAME;
			}
		}
	}
	
	if (languageName == nil) {
		NSLog(@"No stored language name, no default language - nothing passed in? buh?");
		return;
	}
	
	ThemeManager* manager = [ThemeManager sharedThemeManager];
	Theme* newTheme = [manager nextThemeUsingName:languageName error:nil];
	if (newTheme == nil) {
		NSLog(@"Failed to get any theme information for language: %@", languageName);
	}
	
	NSString* fullBGImagePath = [manager.basePath stringByAppendingFormat:@"/%@/%@", languageName, newTheme.imageFilename];
	BOOL isDir;
	if (![[NSFileManager defaultManager] fileExistsAtPath:fullBGImagePath isDirectory:&isDir]) {
		UIAlertView* noBGAlert = [[[UIAlertView alloc] initWithTitle:@"No Background?"
															 message:@"We're missing a background for the selected language. Please restart the application. If the problem persists, please uninstall and re-install."
															delegate:self
												   cancelButtonTitle:@"OK"
												   otherButtonTitles:nil] autorelease];
		[noBGAlert show];
		return;
	}
	
	UIImage* bgImage = [UIImage imageWithContentsOfFile:fullBGImagePath];
	[bgImageView setImage:bgImage];
	
	if (flagController == nil) {
		FlagsTableViewController* fController = [[FlagsTableViewController alloc] initWithStyle:UITableViewStylePlain];
		[fController.view setCenter:CGPointMake(-116.0, 400.0)];
		[self.view addSubview:fController.view];
		flagController = [fController retain];
		[fController release];
		fController = nil;
	}	
	
	if (themeController != nil && [themeController.inputBubbleController isViewLoaded]) {
		[themeController.inputBubbleController.view removeFromSuperview];
	}
	if (themeController != nil && [themeController.outputBubbleController isViewLoaded]) {
		[themeController.outputBubbleController.view removeFromSuperview];
	}
		
	ThemeController* theme = [[ThemeController alloc] init];
	[bgImageView addSubview:theme.inputBubbleController.view];
	themeController = [theme retain];
	[theme release];
	theme = nil;
	
	BOOL isTopArrow = [[newTheme.bubble1Coordinates objectForKey:@"top-arrow"] boolValue];
	WordBubbleController* inBub = inController;
	WordBubbleController* outBub = outController;
	
	CGPoint bubbleCenter = CGPointMake([[newTheme.bubble1Coordinates objectForKey:@"center-x"] floatValue],
									   [[newTheme.bubble1Coordinates objectForKey:@"center-y"] floatValue]);
	[inBub.view setCenter:bubbleCenter];
										
	if (isTopArrow) {
		NSLog(@"isTopArrow...");
		CGPoint arrowCenter = CGPointMake([[newTheme.bubble1Coordinates objectForKey:@"arrow-center-x"] floatValue],
										  inBub.topArrowImageView.center.y);
		[inBub.bottomArrowImageView setHidden:YES];
		[inBub.topArrowImageView setCenter:arrowCenter];
		[inBub.topArrowImageView setHidden:NO];
	}
	else {
		CGPoint arrowCenter = CGPointMake([[newTheme.bubble1Coordinates objectForKey:@"arrow-center-x"] floatValue],
										  inBub.bottomArrowImageView.center.y);
		[inBub.topArrowImageView setHidden:YES];
		[inBub.bottomArrowImageView setCenter:arrowCenter];
		[inBub.bottomArrowImageView setHidden:NO];
	}

	isTopArrow = [[newTheme.bubble2Coordinates objectForKey:@"top-arrow"] boolValue];
	bubbleCenter = CGPointMake([[newTheme.bubble2Coordinates objectForKey:@"center-x"] floatValue],
							   [[newTheme.bubble2Coordinates objectForKey:@"center-y"] floatValue]);
	[outBub.view setCenter:bubbleCenter];
	if (isTopArrow) {
		CGPoint arrowCenter = CGPointMake([[newTheme.bubble2Coordinates objectForKey:@"arrow-center-x"] floatValue],
										  outBub.topArrowImageView.center.y);
		[outBub.bottomArrowImageView setHidden:YES];
		[outBub.topArrowImageView setCenter:arrowCenter];
		[outBub.topArrowImageView setHidden:NO];
	}
	else {
		CGPoint arrowCenter = CGPointMake([[newTheme.bubble2Coordinates objectForKey:@"arrow-center-x"] floatValue],
										  outBub.bottomArrowImageView.center.y);
		[outBub.topArrowImageView setHidden:YES];
		[outBub.bottomArrowImageView setCenter:arrowCenter];
		[outBub.bottomArrowImageView setHidden:NO];
	}
	
	[themeController.inputBubbleController.bubbleTextView setText:NSLocalizedString(@"Tap here to begin typing..", nil)];
	[themeController.inputBubbleController animate];
	
	// Update the flag controller position
	int index; // magic magic numbers
	NSIndexPath* iPath = nil;
	for (index = (9998 / 2); index < 6000; index++) {
		int langIndex = (index % [flagController.languageNames count]);
		NSString* currLang = [flagController.languageNames objectAtIndex:langIndex];
		if ([currLang isEqualToString:languageName]) {
			iPath = [NSIndexPath indexPathForRow:index inSection:0];
			break;
		}
	}
	if (iPath != nil) {
		NSLog(@"Should be using real row: %02d", index);
		[flagController.flagTableView scrollToRowAtIndexPath:iPath
											atScrollPosition:UITableViewScrollPositionTop
													animated:NO];
	}
	
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	if ([defaults stringForKey:CURRENT_LANGUAGE_STORE_KEY] && 
		[[defaults stringForKey:CURRENT_LANGUAGE_STORE_KEY] isEqualToString:languageName]) {
		NSLog(@"Same language is stored.. Skipping.");
	}
	else {
		NSLog(@"Storing language: %@ for default", languageName);
		[defaults setObject:languageName forKey:CURRENT_LANGUAGE_STORE_KEY];
		[defaults synchronize];
	}
	NSLog(@"Done");

}

- (void)viewWillAppear:(BOOL)animated {
	NSLog(@"MainViewController view will appear!");
	[self updateTheme:[NSNotification notificationWithName:THEME_UPDATE_NOTIFICATION object:nil]];
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
	[[NSNotificationCenter defaultCenter] postNotificationName:THEME_UPDATE_NOTIFICATION
														object:nil];
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
