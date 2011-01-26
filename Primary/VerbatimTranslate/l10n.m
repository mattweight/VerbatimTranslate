//
//  l10n.m
//  VerbatimTranslate
//
//  Created by Brandon George on 1/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "l10n.h"

@interface l10n (private)

+ (void)_setBundle:(NSString *)language;

@end

@implementation l10n

static NSBundle* _bundle = nil;

+ (void)initialize {
	NSLog(@"Language on startup: %@", [self getLanguage]);
	[self _setBundle:[self getLanguage]];
}

+ (void)setLanguage:(NSString *)language {
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];	
	[defaults setObject:[NSArray arrayWithObjects:language, @"en", nil] forKey:@"AppleLanguages"];	// English is a backup
	[defaults synchronize];
	[self _setBundle:language];
}

+ (NSString *)getLanguage {
	// defaults to system language setting; when user selects a different language in-app, this is
	// used as a persistent storage mechanism for that language, which overrides the system setting
	// for this app only
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];	
	NSArray* languages = [defaults objectForKey:@"AppleLanguages"];
	return [languages objectAtIndex:0];
}

+ (NSString *)getString:(NSString *)key {
	// 'key' is just the English text
	return [_bundle localizedStringForKey:key value:key table:nil];
}

// private methods

+ (void)_setBundle:(NSString *)language {
	// load the apporpriate string table for the specified language
	NSString* path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj"];
	_bundle = [[NSBundle bundleWithPath:path] retain];
}

@end
