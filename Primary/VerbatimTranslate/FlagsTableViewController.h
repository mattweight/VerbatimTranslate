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
	NSNumber* selectedRowNumber;
	BOOL isDestination;
}

@property (readonly, retain) NSArray* languageNames;
@property (nonatomic, retain) UITableView* flagTableView;
@property (nonatomic, retain) NSNumber* selectedRowNumber;

- (void)setIsDestination:(BOOL)_isDestination;
- (id)initWithStyle:(UITableViewStyle)style isDestController:(BOOL)isDest;
- (void)updateTablePosition;

@end
