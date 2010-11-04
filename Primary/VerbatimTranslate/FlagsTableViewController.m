//
//  FlagsTableViewController.m
//  VerbatimTranslate
//
//  Created by Matt Weight on 11/4/10.
//  Copyright 2010 Digitaria. All rights reserved.
//

#import "FlagsTableViewController.h"
#import "FlagTableViewCell.h"
#import "math.h"

static inline double radians (double degrees) {return degrees * M_PI/180;}

@implementation FlagsTableViewController

#pragma mark -
#pragma mark View lifecycle

- (id)initWithStyle:(UITableViewStyle)style {
	if (self = [super initWithStyle:UITableViewStylePlain]) {
		UITableView* tabView = (UITableView*)self.view;
		[tabView setFrame:CGRectMake(0.0, 0.0, 40.0, 320.0)];
		[tabView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
		[tabView setBackgroundColor:[UIColor lightGrayColor]];
		[tabView setAlpha:0.8];
		[tabView setTransform:CGAffineTransformMakeRotation(radians(90))];
	}
	return self;
}

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
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
    return 9999;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[FlagTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		/*
		[[(FlagTableViewCell*)cell flagImageView] setImage:];
		NSLog(@"content width  view: %02f", cell.contentView.frame.size.width);
		NSLog(@"content height view: %02f", cell.contentView.frame.size.height);
		[cell setFrame:CGRectMake(0.0, 0.0, 40.0, 30.0)];
		[cell setBackgroundColor:[UIColor whiteColor]];
		[cell.imageView setBackgroundColor:[UIColor whiteColor]];
		[cell.imageView setFrame:CGRectMake(0.0, 0.0, 27.0, 40.0)];
		[cell.imageView setCenter:cell.center];
		*/
		
    }
    
    // Configure the cell...
	if (!(indexPath.row % 4)) {
		[[(FlagTableViewCell*)cell flagImageView] setImage:[UIImage imageNamed:@"Norwegian40.png"]];
	}
	else if (!(indexPath.row % 3)) {
		[[(FlagTableViewCell*)cell flagImageView] setImage:[UIImage imageNamed:@"Japanese40.png"]];
	}
	else if (!(indexPath.row % 2)) {
		[[(FlagTableViewCell*)cell flagImageView] setImage:[UIImage imageNamed:@"Polish40.png"]];
	}
	else {
		[[(FlagTableViewCell*)cell flagImageView] setImage:[UIImage imageNamed:@"SpanishLatinAmerica40.png"]];
	}
	
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
	if (tableView.frame.origin.x != 0.0) {
		origPoint = CGPointMake(tableView.frame.origin.x, tableView.frame.origin.y);
		[tableView setFrame:CGRectMake(0.0, 
									   tableView.frame.origin.y, 
									   tableView.frame.size.width,
									   tableView.frame.size.height)];
	}
	else {
		[tableView setFrame:CGRectMake(origPoint.x, 
									   origPoint.y, 
									   tableView.frame.size.width,
									   tableView.frame.size.height)];
	}
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
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
    [super dealloc];
}


@end

