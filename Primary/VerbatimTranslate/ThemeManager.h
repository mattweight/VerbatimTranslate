//
//  ThemeManager.h
//  VerbatimTranslate
//
//  Created by Matt Weight on 12/20/10.
//  Copyright 2010 Digitaria. All rights reserved.
//

// Loads and maintains a full list of available themes

#import <Foundation/Foundation.h>

@interface Theme : NSObject
{
	NSString* imageFilename;
	NSDictionary* bubble1Coordinates;
	NSDictionary* bubble2Coordinates;
	NSDictionary* services;
}

@property (nonatomic, retain) NSString* imageFilename;
@property (nonatomic, retain) NSDictionary* bubble1Coordinates;
@property (nonatomic, retain) NSDictionary* bubble2Coordinates;
@property (nonatomic, retain) NSDictionary* services;

@end


@interface ThemeManager : NSObject {
	NSString* basePath;
	NSArray* languages;
	NSMutableDictionary* languageInfo;
	Theme* currentTheme;
}

@property (readonly, retain) NSString* basePath;
@property (readonly, retain) Theme* currentTheme;
@property (readonly, retain) NSArray* languages;
@property (readonly, retain) NSMutableDictionary* languageInfo;

+ (ThemeManager*)sharedThemeManager;

- (void)nextThemeUsingName:(NSString*)languageName error:(NSError**)theError;

@end
