//
//  ThemeController.m
//  VerbatimTranslate
//
//  Created by Matt Weight on 10/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ThemeController.h"
#import "VerbatimConstants.h"

#define LOOKUP_BG_IMAGE_FILENAME            @"background-image"
#define LOOKUP_INPUT_LANGUAGE_DICTIONARY    @"input-language"
#define LOOKUP_OUTPUT_LANGUAGE_DICTIONARY   @"output-language"
#define LOOKUP_INPUT_CONTROLLER_DICTIONARY  @"input-controller"
#define LOOKUP_OUTPUT_CONTROLLER_DICTIONARY @"output-controller"

static ThemeController* singletonController = nil;

@implementation ThemeController

@synthesize backgroundImageFile;
@synthesize inputBubbleController;
@synthesize outputBubbleController;
@synthesize inputLanguage;
@synthesize outputLanguage;
@synthesize themeID;

+ (ThemeController*)sharedController {
	// My cheater singleton
	if ([singletonController retainCount] > 1) {
		while ([singletonController retainCount] > 1) {
			[singletonController release];
		}
	}
	
	if (singletonController == nil || (singletonController != nil && [singletonController retainCount] == 0)) {
		if (singletonController != nil) {
			[singletonController release];
			singletonController = nil;
		}
		singletonController = [[ThemeController alloc] init];
	}
	return singletonController;
}

- (void)genSampleDict {
	NSMutableDictionary* langDict = [[NSMutableDictionary alloc] init];
	[langDict setObject:@"en" forKey:@"google-translate"];
	[langDict setObject:@"en" forKey:@"yahoo-translate"];
	[langDict setObject:@"en" forKey:@"babelfish"];
	
	NSMutableDictionary* mainDictionary = [[NSMutableDictionary alloc] init];
	[mainDictionary setObject:@"mariachi.png" forKey:LOOKUP_BG_IMAGE_FILENAME];
	
	NSMutableDictionary* inputLangDict = [[NSMutableDictionary alloc] init];
	[inputLangDict setObject:@"English (US)" forKey:@"human-readable"];
	[inputLangDict setObject:langDict forKey:@"services"];
	
	[mainDictionary setObject:inputLangDict forKey:LOOKUP_INPUT_LANGUAGE_DICTIONARY];
	[mainDictionary setObject:inputLangDict forKey:LOOKUP_OUTPUT_LANGUAGE_DICTIONARY];
	
	NSMutableDictionary* bvDict = [[NSMutableDictionary alloc] init];
	[bvDict setObject:@"200.0" forKey:@"center-x"];
	[bvDict setObject:@"300.0" forKey:@"center-y"];
	[bvDict setObject:@"50.0" forKey:@"arrow-center-x"];
	[bvDict setObject:@"0.0" forKey:@"arrow-center-y"];
	
	[mainDictionary setObject:bvDict forKey:LOOKUP_INPUT_CONTROLLER_DICTIONARY];
	[mainDictionary setObject:bvDict forKey:LOOKUP_OUTPUT_CONTROLLER_DICTIONARY];
	
	[mainDictionary writeToFile:[[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"../Documents"] stringByAppendingPathComponent:@"sample-theme.plist"]
					 atomically:YES];
	
	NSLog(@"Write sample to: %@", [[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"../Documents"] stringByAppendingPathComponent:@"sample-theme.plist"]);
}

- (id)init {
	if (self = [super init]) {
		[self updateUsing:nil];
	}
	return self;
}

// FIXME Any catastrophic problems are currently calling exit vs. throwing an appropriate 
// error (running out of time tonight)
- (void)updateUsing:(NSDictionary*)updateDictionary {
	NSFileManager* fMan = [NSFileManager defaultManager];
	NSString* mainPath = [[NSBundle mainBundle] resourcePath];
	
	if (updateDictionary == nil) {
		NSString* dictFile = [[NSUserDefaults standardUserDefaults] stringForKey:THEME_PLIST_FILENAME_KEY];
		if (dictFile != nil && [fMan fileExistsAtPath:[mainPath stringByAppendingPathComponent:dictFile]]) {
			dictFile = nil;
		}
		
		if (dictFile == nil) {
			if ([fMan fileExistsAtPath:[mainPath stringByAppendingPathComponent:DEFAULT_THEME_PLIST_FILENAME]]) {
				dictFile = [NSString stringWithString:DEFAULT_THEME_PLIST_FILENAME];
			}
			else {
				NSLog(@"The default/failover theme plist '%@' is MISSING?! Not sure how to continue...", DEFAULT_THEME_PLIST_FILENAME);
				exit(1);
			}
		}
		
		// And populate with the defaults.
		updateDictionary = [NSDictionary dictionaryWithContentsOfFile:[mainPath stringByAppendingPathComponent:dictFile]];
	}
	
	NSString* bgImgFile = (NSString*)[updateDictionary objectForKey:LOOKUP_BG_IMAGE_FILENAME];
	if (bgImgFile == nil) {
		NSLog(@"Missing key '%@' from descriptor file", LOOKUP_BG_IMAGE_FILENAME);
		exit(1);
	}
	if (! [fMan fileExistsAtPath:[mainPath stringByAppendingPathComponent:bgImgFile]]) {
		NSLog(@"Background image '%@' does not exist!", bgImgFile);
		exit(1);
	}	
	[self setBackgroundImageFile:bgImgFile];
	
	NSDictionary* inputDictionary = (NSDictionary*)[updateDictionary objectForKey:LOOKUP_INPUT_LANGUAGE_DICTIONARY];
	if (inputDictionary == nil) {
		NSLog(@"Missing key '%@' from descriptor file", LOOKUP_INPUT_LANGUAGE_DICTIONARY);
		exit(1);
	}
	[self setInputLanguage:inputDictionary];
	
	NSDictionary* outputDictionary = (NSDictionary*)[updateDictionary objectForKey:LOOKUP_OUTPUT_LANGUAGE_DICTIONARY];
	if (outputDictionary == nil) {
		NSLog(@"Missing key '%@' from descriptor file", LOOKUP_OUTPUT_LANGUAGE_DICTIONARY);
		exit(1);
	}
	[self setOutputLanguage:outputDictionary];
	
	NSDictionary* inputWordDictionary = (NSDictionary*)[updateDictionary objectForKey:LOOKUP_INPUT_CONTROLLER_DICTIONARY];
	if (inputWordDictionary == nil) {
		NSLog(@"Missing key '%@' from descriptor file", LOOKUP_INPUT_CONTROLLER_DICTIONARY);
		exit(0);
	}
	
	NSDictionary* outputWordDictionary = (NSDictionary*)[updateDictionary objectForKey:LOOKUP_OUTPUT_CONTROLLER_DICTIONARY];
	if (outputWordDictionary == nil) {
		NSLog(@"Missing key '%@' from descriptor file", LOOKUP_OUTPUT_CONTROLLER_DICTIONARY);
		exit(0);
	}
	
	WordBubbleController* inputController = [[WordBubbleController alloc] initWithNibName:@"WordBubbleController" bundle:nil];
	[inputController.view setCenter:CGPointMake([[inputWordDictionary objectForKey:@"center-x"] floatValue], 
												[[inputWordDictionary objectForKey:@"center-y"] floatValue])];
	BOOL isTopArrow = [[inputWordDictionary objectForKey:@"arrow-top"] boolValue];
	if (isTopArrow) {
		[inputController.topArrowImageView setHidden:NO];
		[inputController.bottomArrowImageView setHidden:YES];
		[inputController.topArrowImageView setCenter:CGPointMake([[inputWordDictionary objectForKey:@"arrow-center-x"] floatValue], 
																 inputController.topArrowImageView.center.y)];
	}
	else {
		[inputController.topArrowImageView setHidden:YES];
		[inputController.bottomArrowImageView setHidden:NO];
		[inputController.bottomArrowImageView setCenter:CGPointMake([[inputWordDictionary objectForKey:@"arrow-center-x"] floatValue], 
																 inputController.bottomArrowImageView.center.y)];
	}
	
	[self setInputBubbleController:inputController];
	[inputController release];
	inputController = nil;

	WordBubbleController* outputController = [[WordBubbleController alloc] initWithNibName:@"WordBubbleController" bundle:nil];
	[outputController.view setCenter:CGPointMake([[outputWordDictionary objectForKey:@"center-x"] floatValue], 
												 [[outputWordDictionary objectForKey:@"center-y"] floatValue])];
	
	isTopArrow = [[outputWordDictionary objectForKey:@"arrow-top"] boolValue];
	if (isTopArrow) {
		[outputController.topArrowImageView setHidden:NO];
		[outputController.bottomArrowImageView setHidden:YES];
		[outputController.topArrowImageView setCenter:CGPointMake([[outputWordDictionary objectForKey:@"arrow-center-x"] floatValue], 
																 outputController.topArrowImageView.center.y)];
	}
	else {
		[outputController.topArrowImageView setHidden:YES];
		[outputController.bottomArrowImageView setHidden:NO];
		[outputController.bottomArrowImageView setCenter:CGPointMake([[outputWordDictionary objectForKey:@"arrow-center-x"] floatValue], 
																	outputController.bottomArrowImageView.center.y)];
	}
	
	[self setOutputBubbleController:outputController];
	[outputController release];
	outputController = nil;
}

- (void)dealloc {
    [super dealloc];
}


@end
