//
//  FlagsTableViewController.m
//  VerbatimTranslate
//
//  Created by Matt Weight on 11/4/10.
//  Copyright 2010 Digitaria. All rights reserved.
//

#import "FlagsTableViewController.h"
#import "FlagTableViewCell.h"
#import "ThemeManager.h"

#import "VerbatimTranslateAppDelegate.h"
#import "MainViewController.h"
#import "VerbatimConstants.h"

#import "math.h"

@implementation FlagsTableViewController

@synthesize languageNames;
@synthesize flagTableView;
@synthesize selectedRowNumber;

static int numRows = 9999;
static inline double radians (double degrees) {return degrees * M_PI/180;}

#pragma mark -
#pragma mark View lifecycle

- (id)initWithStyle:(UITableViewStyle)style {
	if (self = [super initWithStyle:UITableViewStylePlain]) {
		self.selectedRowNumber = [[NSNumber numberWithInteger:[[NSUserDefaults standardUserDefaults] integerForKey:VERBATIM_SELECTED_DEST_FLAG_ROW]] retain];
		UITableView* tabView = (UITableView*)self.view;
		[tabView setFrame:CGRectMake(0.0, 0.0, 56.0, 320.0)];
		[tabView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
		[tabView setBackgroundColor:[UIColor whiteColor]];
		[tabView setShowsVerticalScrollIndicator:NO];
		[tabView setShowsHorizontalScrollIndicator:NO];
		[tabView setAlpha:1.0];
		[tabView setTransform:CGAffineTransformMakeRotation(radians(90))];
		flagTableView = [tabView retain];
		NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(localizedCompare:)];
		NSArray* results = [[[ThemeManager sharedThemeManager].languageInfo allKeys] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
		languageNames = [[NSArray alloc] initWithArray:results];
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSIndexPath* startIndex = [NSIndexPath indexPathForRow:[self.selectedRowNumber unsignedIntegerValue] inSection:0];
	[self.view selectRowAtIndexPath:startIndex
						   animated:NO
					 scrollPosition:UITableViewScrollPositionTop];
	NSLog(@"\n\n\n\n\nflags view selected index: %d\n\n\n\n\n", [self.selectedRowNumber integerValue]);
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/

/*
- (void)viewDidAppear:(BOOL)animated {
	NSLog(@"Flag table DID appear");
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return numRows; // large number for the continuous spinner
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[FlagTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		[cell setFrame:CGRectMake(0.0, 0.0, 80.0, 60.0)];
		[cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    
    // Configure the cell...
	int index = (int)(indexPath.row % [languageNames count]);
	NSString* languageName = [[languageNames objectAtIndex:index] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString* flagPath = [[ThemeManager sharedThemeManager] flagImagePathUsingName:languageName];
	UIImage* flagImage = [UIImage imageWithContentsOfFile:flagPath];
	[[(FlagTableViewCell*)cell flagImageView] setImage:flagImage];
	[[(FlagTableViewCell*)cell flagLabel] setText:languageName];
	
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//NSLog([NSString stringWithFormat:@"table view origin: %02f X %02f", tableView.frame.origin.x, tableView.frame.origin.y]);
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	[tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];

	NSLog(@"Flag frame selection");
	if (tableView.frame.origin.x != 0.0) {
		NSLog(@"frame location != 0.0");
		origPoint = CGPointMake(tableView.frame.origin.x, tableView.frame.origin.y);
		[tableView setFrame:CGRectMake(0.0, 
									   tableView.frame.origin.y, 
									   tableView.frame.size.width,
									   tableView.frame.size.height)];
		[tableView setScrollEnabled:YES];
		// Do not do any of the reloading stuff.
		return;
	}
	else {
		[tableView setFrame:CGRectMake(origPoint.x, 
									   origPoint.y, 
									   tableView.frame.size.width,
									   tableView.frame.size.height)];
		[tableView setScrollEnabled:NO];
	}

	NSLog(@"Getting language index..");
	int index = (int)(indexPath.row % [languageNames count]);
	NSLog(@"\t Index: %d", index);
	
	NSString* languageName = [[languageNames objectAtIndex:index] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSLog(@"\t Language Name: %@", languageName);
	NSNotification* updateNotification = [NSNotification notificationWithName:THEME_UPDATE_NOTIFICATION
																	   object:nil
																	 userInfo:[NSDictionary dictionaryWithObject:languageName forKey:@"language"]];
	[[NSNotificationCenter defaultCenter] postNotification:updateNotification];

	NSLog(@"\n\n\n\n\n\n\n\tindex path row: %d\n\n\n\n\n\n\n", indexPath.row);
	[[NSUserDefaults standardUserDefaults] setInteger:indexPath.row forKey:VERBATIM_SELECTED_DEST_FLAG_ROW];
	[[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[languageNames release];
	languageNames = nil;
	[flagTableView release];
	flagTableView = nil;
    [super dealloc];
}


@end

