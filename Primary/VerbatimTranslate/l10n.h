//
//  l10n.h
//  VerbatimTranslate
//
//  Created by Brandon George on 1/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

// convenience macro for localizing strings - wrap all static strings in this macro
#define _(x) [l10n getString:x]

@interface l10n : NSObject {}

+ (void)initLanguage;
+ (void)setLanguage:(NSString *)language;
+ (NSString *)getLanguage;
+ (NSString *)getString:(NSString *)key;

@end
