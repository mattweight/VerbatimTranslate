//
//  VerbatimConstants.h
//  BubblePOC
//
//  Created by Matt Weight on 10/5/10.
//  Copyright 2010 Digitaria. All rights reserved.
//

#ifndef __VERBATIM_CONSTANTS_H__
#define __VERBATIM_CONSTANTS_H__

// Animation stage is the state of animation we are in
// where 0 indicates the shrunken step.
typedef unsigned short ANIMATION_STEP;

// This changes the number of times we "bounce" the
// word bubble. It needs to be an even number.
#define MAX_ANIMATION_STEP 6

// This is the maximum number of bounces allowed
#define MAX_BUBBLE_BOUNCE 1.4

// Key NAMES
#define DEFAULT_KEY_PREFIX @"VERBATIM_TRANSLATE"
#define KEY_NAME(x) [NSString stringWithFormat:@"%@_%@", DEFAULT_KEY_PREFIX, x]

#define THEME_BACKGROUND_FILENAME_KEY  KEY_NAME(@"__THEME_BACKGROUND_FILENAME_KEY__")
#define THEME_INPUT_BUBBLE_KEY         KEY_NAME(@"__THEME_INPUT_BUBBLE_KEY__")
#define THEME_OUTPUT_BUBBLE_KEY        KEY_NAME(@"__THEME_OUTPUT_BUBBLE_KEY__")
#define THEME_INPUT_LANGUAGE_KEY       KEY_NAME(@"__THEME_INPUT_LANGUAGE_KEY__")
#define THEME_OUTPUT_LANGUAGE_KEY      KEY_NAME(@"__THEME_OUTPUT_LANGUAGE_KEY__")
#define THEME_PLIST_FILENAME_KEY       KEY_NAME(@"__THEME_PLIST_FILENAME_KEY__")

#define DEFAULT_THEME_PLIST_FILENAME   @"default-theme.plist"

#endif // __VERBATIM_CONSTANTS_H__
