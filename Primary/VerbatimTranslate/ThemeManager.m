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
		NSFileManager* fMan = [NSFileManager defaultManager];
		basePath = [[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Backgrounds"] retain];
		if (![fMan fileExistsAtPath:basePath isDirectory:YES]) {
			NSLog(@"Big problem - missing base path: %@", basePath);
			return self;
		}
		else {
			NSMutableArray* allLanguages = [NSMutableArray arrayWithArray:[fMan contentsOfDirectoryAtPath:self.basePath error:nil]];
			if (allLanguages == nil) {
				NSLog(@"No file contents @ %@", self.basePath);
				return self;
			}

			NSString* currItem = nil;
			for (currItem in allLanguages) {
				if (![currItem hasPrefix:@"."] && [fMan fileExistsAtPath:currItem isDirectory:YES]) {
					// Validate the config.plist and flag
					NSString* configPath = [self.basePath stringByAppendingPathComponent:@"config.plist"];
					if ([fMan fileExistsAtPath:configPath isDirectory:NO]) {
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
						[languages setValue:container forKey:currItem];
					}
				}
			}
		}
	}
	return self;
}

- (void)nextThemeUsingName:(NSString*)languageName {
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
