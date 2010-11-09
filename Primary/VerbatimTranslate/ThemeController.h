//
//  ThemeController.h
//  VerbatimTranslate
//
//  Created by Matt Weight on 10/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WordBubbleController.h"

@interface ThemeController : NSObject {
	NSString* backgroundImageFile;
	WordBubbleController* inputBubbleController;
	WordBubbleController* outputBubbleController;
	NSDictionary* inputLanguage;
	NSDictionary* outputLanguage;
	BOOL needsThemeUpdate;

	// For the moment, I am just setting everything using this abstraction, 
	// but in the future we could use themeID as an index lookup and push
	// all of this to the db?
	NSInteger themeID;
}

@property (nonatomic, retain) NSString* backgroundImageFile;
@property (nonatomic, retain) WordBubbleController* inputBubbleController;
@property (nonatomic, retain) WordBubbleController* outputBubbleController;
@property (nonatomic, retain) NSDictionary* inputLanguage;
@property (nonatomic, retain) NSDictionary* outputLanguage;
@property (readonly) NSInteger themeID;

+ (ThemeController*)sharedController;

- (void)updateUsing:(NSDictionary*)updateDictionary;
- (void)genSampleDict;

- (BOOL)getNeedsThemeUpdate;
- (void)setNeedsThemeUpdate:(BOOL)updateStatus;

@end
