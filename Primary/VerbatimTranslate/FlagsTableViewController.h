//
//  FlagsTableViewController.h
//  VerbatimTranslate
//
//  Created by Matt Weight on 11/4/10.
//  Copyright 2010 Digitaria. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FlagsTableViewController : UITableViewController {
	CGPoint origPoint;
	NSArray* languageNames;
	UITableView* flagTableView;
}

@property (readonly, retain) NSArray* languageNames;
@property (nonatomic, retain) UITableView* flagTableView;

@end
