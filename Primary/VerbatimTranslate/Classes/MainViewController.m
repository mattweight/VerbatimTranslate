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

@interface MainViewController()

- (void)updateSourceLanguage:(NSNotification*)notif;

@end

@implementation MainViewController

@synthesize bgImageView;
@synthesize flagController;
@synthesize currentLanguage;
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

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(updateSourceLanguage:)
												 name:VERBATIM_APP_SOURCE_LANGUAGE
											   object:nil];
	
	[self.view addSubview:inController.view];
	[outController.view setAlpha:0.0];
	[outController.view setUserInteractionEnabled:NO];
	[self.view addSubview:outController.view];
	[inController reset];
	[outController.view setAlpha:0.0];
	[outController reset];
	[self updateTheme:nil];
	
	currentLanguage = [[NSMutableString alloc] init];
	[currentLanguage setString:[[NSUserDefaults standardUserDefaults] stringForKey:CURRENT_LANGUAGE_STORE_KEY]];
}


- (void)updateSourceLanguage:(NSNotification*)notif {
	
}

- (void)updateTheme:(NSNotification*)notif {
	[outController.view setAlpha:0.0];
	NSDictionary* uInfo = (NSDictionary*)[notif userInfo];
	NSString* languageName = [NSString string];
	NSString* storedLanguage = [[NSUserDefaults standardUserDefaults] stringForKey:CURRENT_LANGUAGE_STORE_KEY];
	
	if (uInfo == nil && storedLanguage == nil) {
		languageName = DEFAULT_LANGUAGE_NAME;
	}
	else {
		languageName = (NSString*)[uInfo objectForKey:@"language"];
		if (languageName == nil && storedLanguage != nil) {
			languageName = storedLanguage;
		}
		else if (languageName == nil && storedLanguage == nil) {
			languageName = DEFAULT_LANGUAGE_NAME;
		}
	}
	NSLog(@"update theme using language: %@", languageName);
	if (languageName == nil) {
		NSLog(@"No stored language name, no default language - nothing passed in? buh?");
		return;
	}

	NSLog(@"currentLanguage: %@", currentLanguage);
	
	if ([currentLanguage isEqualToString:languageName]) {
		NSLog(@"selected language is the same as current lanugage. Skipping..");
		return;
	}
	
	[currentLanguage setString:languageName];
	
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
	
	NSLog(@"Getting the bgImage..");
	UIImage* bgImage = [UIImage imageWithContentsOfFile:fullBGImagePath];
	[bgImageView setImage:bgImage];
	NSLog(@"\t* bgImage: %@", bgImage);
	
	if (flagController == nil) {
		FlagsTableViewController* fController = [[FlagsTableViewController alloc] initWithStyle:UITableViewStylePlain];
		[fController.view setCenter:CGPointMake(-116.0, 400.0)];
		[self.view addSubview:fController.view];
		flagController = [fController retain];
		[fController release];
		fController = nil;
	}	

	[inController reset];

	
	[(WordBubbleView*)outController.view setAnimationStep:MAX_ANIMATION_STEP];
	[(WordBubbleView*)outController.view setForceStop:YES];
	[outController animate];
	
	BOOL isTopArrow = [[newTheme.bubble1Coordinates objectForKey:@"top-arrow"] boolValue];
	CGPoint bubbleCenter = CGPointMake([[newTheme.bubble1Coordinates objectForKey:@"center-x"] floatValue],
									   [[newTheme.bubble1Coordinates objectForKey:@"center-y"] floatValue]);
	[inController.view setCenter:bubbleCenter];
										
	if (isTopArrow) {
		NSLog(@"isTopArrow...");
		CGPoint arrowCenter = CGPointMake([[newTheme.bubble1Coordinates objectForKey:@"arrow-center-x"] floatValue],
										  inController.topArrowImageView.center.y);
		[inController.bottomArrowImageView setHidden:YES];
		[inController.topArrowImageView setCenter:arrowCenter];
		[inController.topArrowImageView setHidden:NO];
	}
	else {
		CGPoint arrowCenter = CGPointMake([[newTheme.bubble1Coordinates objectForKey:@"arrow-center-x"] floatValue],
										  inController.bottomArrowImageView.center.y);
		[inController.topArrowImageView setHidden:YES];
		[inController.bottomArrowImageView setCenter:arrowCenter];
		[inController.bottomArrowImageView setHidden:NO];
	}

	isTopArrow = [[newTheme.bubble2Coordinates objectForKey:@"top-arrow"] boolValue];
	bubbleCenter = CGPointMake([[newTheme.bubble2Coordinates objectForKey:@"center-x"] floatValue],
							   [[newTheme.bubble2Coordinates objectForKey:@"center-y"] floatValue]);
	[outController.view setCenter:bubbleCenter];
	if (isTopArrow) {
		CGPoint arrowCenter = CGPointMake([[newTheme.bubble2Coordinates objectForKey:@"arrow-center-x"] floatValue],
										  outController.topArrowImageView.center.y);
		[outController.bottomArrowImageView setHidden:YES];
		[outController.topArrowImageView setCenter:arrowCenter];
		[outController.topArrowImageView setHidden:NO];
	}
	else {
		CGPoint arrowCenter = CGPointMake([[newTheme.bubble2Coordinates objectForKey:@"arrow-center-x"] floatValue],
										  outController.bottomArrowImageView.center.y);
		[outController.topArrowImageView setHidden:YES];
		[outController.bottomArrowImageView setCenter:arrowCenter];
		[outController.bottomArrowImageView setHidden:NO];
	}

	[inController.bubbleTextView setText:NSLocalizedString(@"Tap here to begin typing..", nil)];
	[inController animate];
	
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
		if ([flagController.languageNames count] >= iPath.row) {
			[flagController.flagTableView scrollToRowAtIndexPath:iPath
												atScrollPosition:UITableViewScrollPositionTop
														animated:NO];
		}
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

// TODO - Move any re-loading into the load/unload methods
/*
- (void)viewWillAppear:(BOOL)animated {
	NSLog(@"MainViewController view will appear!");
	[self updateTheme:[NSNotification notificationWithName:THEME_UPDATE_NOTIFICATION object:nil]];
}
*/

- (void)displayTranslation:(id)sender {
	[[NSNotificationCenter defaultCenter] postNotificationName:REMOVE_ACTIVITY_VIEW
														object:nil];
	
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	NSString* origText = (NSString*)[defaults stringForKey:VERBATIM_ORIGINAL_TEXT];
	NSString* transText = (NSString*)[defaults stringForKey:VERBATIM_TRANSLATED_TEXT];

	[inController.autoSuggestController.view removeFromSuperview];

	[inController.bubbleTextView setText:origText];
	[outController.bubbleTextView setText:transText];
	
	[(WordBubbleView*)inController.view reverseTextViewExpansion];
	[(WordBubbleView*)inController.view setAnimationStep:0];
	[inController animate];
	
	[outController.view setAlpha:0.90];
	[(WordBubbleView*)outController.view setAnimationStep:0];
	[outController animate];
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
