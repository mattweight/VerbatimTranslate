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
#define MAX_ANIMATION_STEP 4

// This is the maximum number of bounces allowed
#define MAX_BUBBLE_BOUNCE 1.4

#endif // __VERBATIM_CONSTANTS_H__
