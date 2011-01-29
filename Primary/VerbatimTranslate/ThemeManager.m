//
//  ThemeManager.m
//  VerbatimTranslate
//
//  Created by Matt Weight on 12/20/10.
//  Copyright 2010 Digitaria. All rights reserved.
//

#import "ThemeManager.h"
#import "VerbatimConstants.h"
#import "SynthesizeSingleton.h"
#import "l10n.h"

#include <stdlib.h>

@implementation Theme

@synthesize imageFilename;
@synthesize bubble1Coordinates;
@synthesize bubble2Coordinates;
@synthesize services;

@end

@implementation ThemeManager

SYNTHESIZE_SINGLETON_FOR_CLASS(ThemeManager);

@synthesize currentTheme;
@synthesize basePath;
@synthesize languages;
@synthesize languageInfo;

- (id)init {
	if (self = [super init]) {
		NSLog(@"Seeding the randomizer");
		srandomdev();
		
		NSFileManager* fMan = [NSFileManager defaultManager];
		basePath = [[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Backgrounds"] retain];
		BOOL isDir;

		if (![fMan fileExistsAtPath:basePath isDirectory:&isDir] && isDir) {
			NSLog(@"Big problem - missing base path: %@", basePath);
			return self;
		}
		else {
			NSMutableArray* allLanguages = [NSMutableArray arrayWithArray:[fMan contentsOfDirectoryAtPath:self.basePath error:nil]];
			if (allLanguages == nil) {
				NSLog(@"No file contents @ %@", self.basePath);
				return self;
			}

			languageInfo = [[[NSMutableDictionary alloc] init] retain];
			NSString* currItem = nil;
			for (currItem in allLanguages) {
				NSString* langDir = [self.basePath stringByAppendingFormat:@"/%@", currItem];
				[fMan fileExistsAtPath:langDir isDirectory:&isDir];
				if (![currItem hasPrefix:@"."] && isDir) {
					// Validate the config.plist and flag
					NSString* configPath = [langDir stringByAppendingPathComponent:@"config.plist"];
					if ([fMan fileExistsAtPath:configPath isDirectory:&isDir] && !isDir) {
						NSDictionary* configInfo = [NSDictionary dictionaryWithContentsOfFile:configPath];
						NSDictionary* serviceInfo = [configInfo objectForKey:@"services"];
						if (serviceInfo == nil && [[serviceInfo allKeys] count] == 0) {
							NSLog(@"WARNING: (%@) Missing service info. Skipping..", currItem);
							break;
						}
						NSDictionary* backgroundInfo = [configInfo objectForKey:@"backgrounds"];
						if (backgroundInfo == nil && [[backgroundInfo allKeys] count] == 0) {
							NSLog(@"WARNING: (%@) Missing background info. Skipping..", currItem);
							break;
						}
						
						NSMutableArray* container = [NSMutableArray array];
						NSString* bgFilename = nil;
						for (bgFilename in [backgroundInfo allKeys]) {
							NSArray* bubbleInfo = [backgroundInfo objectForKey:bgFilename];
							NSArray* bits1 = [[bubbleInfo objectAtIndex:0] componentsSeparatedByString:@","];
							NSArray* bits2 = [[bubbleInfo objectAtIndex:1] componentsSeparatedByString:@","];

							Theme* newTheme = [[Theme alloc] init];
							NSMutableDictionary* coordinates1 = [NSMutableDictionary dictionary];
							NSMutableDictionary* coordinates2 = [NSMutableDictionary dictionary];
							NSInteger iter = 0;
							NSString* pointName = nil;
							for (pointName in COORDINATE_MAP_ARRAY) {
								[coordinates1 setObject:[bits1 objectAtIndex:iter] forKey:pointName];
								[coordinates2 setObject:[bits2 objectAtIndex:iter] forKey:pointName];
								iter++;
							}
							[newTheme setBubble1Coordinates:(NSDictionary*)coordinates1];
							[newTheme setBubble2Coordinates:(NSDictionary*)coordinates2];
							[newTheme setImageFilename:bgFilename];
							[newTheme setServices:serviceInfo];
							[container addObject:newTheme];
						}
//						NSString* storedKey = [currItem stringByReplacingOccurrencesOfString:@"""" withString:@""];
//						[languageInfo setValue:container forKey:[storedKey stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
						[languageInfo setValue:container forKey:[currItem stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
					}
				}
			}
		}
	}
	return self;
}

- (NSString*)flagImagePathUsingName:(NSString*)languageName {
	NSString* selectLanguage = [languageName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSArray* themes = (NSArray*)[languageInfo objectForKey:selectLanguage];
	if (themes == nil) {
		NSLog(@"Missing flag information on: %@", selectLanguage);
		return nil;
	}

	NSString* flagPath = [self.basePath stringByAppendingFormat:@"/%@/flag.jpg", languageName];
	BOOL isDir;
	if (![[NSFileManager defaultManager] fileExistsAtPath:flagPath isDirectory:&isDir]) {
		NSLog(@"Missing flag image at path: %@", flagPath);
	}
	
	return flagPath;
}

- (Theme*)nextThemeUsingName:(NSString*)languageName error:(NSError**)theError {
	NSString* selectLanguage = [languageName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSArray* themes = (NSArray*)[languageInfo objectForKey:selectLanguage];
	if (themes == nil) {
		UIAlertView* missingAlert = [[[UIAlertView alloc] initWithTitle:ALERT_TITLE
																message:[NSString stringWithFormat:_(@"Missing theme information for '%@'. Please close and restart. If this problem continues, please uninstall and re-install."), languageName]
															   delegate:self
													  cancelButtonTitle:_(@"OK")
													  otherButtonTitles:nil] autorelease];
		[missingAlert show];
	}
	else {
		int newRand = (int)(random() % (long)[themes count]);
		Theme* selectedTheme = [themes objectAtIndex:newRand];
		currentTheme = selectedTheme;
		return selectedTheme;
	}
	return nil;
}
					
- (void)dealloc {
	[languages release];
	languages = nil;
	[languageInfo release];
	languageInfo = nil;
	[currentTheme release];
	currentTheme = nil;
	[basePath release];
	basePath = nil;
	[super dealloc];
}

@end
