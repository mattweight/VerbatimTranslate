//
//  InfoViewController.m
//  InfoProto
//
//  Created by Brandon George on 10/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "InfoViewController.h"
#import "QuoteViewController.h"
#import "AutoSuggestManager.h"

#define kSettingsRequestQuote			0
#define kSettingsClearHistory			1
#define kAlertViewTagClearHistory		1
#define kAlertViewButtonClearHistoryOK	1

@implementation InfoViewController

@synthesize tableView = _tableView;
@synthesize aboutLabel = _aboutLabel;
@synthesize aboutText = _aboutText;

- (IBAction)showMainView:(id)sender {
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [_settings count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString * kCellID = @"cellID";
	
	UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID] autorelease];
	}
	
	cell.selectionStyle = UITableViewCellSelectionStyleGray;
	if (indexPath.row == kSettingsRequestQuote) {
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}	
	cell.textLabel.text = [_settings objectAtIndex:indexPath.row];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.row) {
		case kSettingsRequestQuote:
			[self showQuoteView];
			break;
			
		case kSettingsClearHistory:
			[self showHistoryWarning];
			break;
			
		default:
			break;
	}
}

- (void)showQuoteView {
	// setup view controller
	QuoteViewController * quoteViewController = [[QuoteViewController alloc] initWithNibName:@"QuoteViewController" bundle:[NSBundle mainBundle]];
	quoteViewController.title = NSLocalizedString(@"Professional Quote", nil);
	UIBarButtonItem * backButton = [[UIBarButtonItem alloc]
									 initWithTitle:NSLocalizedString(@"Back", nil)
									 style:UIBarButtonItemStyleBordered
									 target:nil
									 action:nil];
	self.navigationItem.backBarButtonItem = backButton;
	[backButton release];
	
	// push view controller
	[self.navigationController pushViewController:quoteViewController animated:YES];
	[quoteViewController release];
}

- (void)showHistoryWarning {
	// show warning
	NSString * message = NSLocalizedString(@"Are you sure you want to clear all translation history?  Your previous translations will not show up as suggestions anymore.", nil);
	UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Verbatim Translate", nil) message:message delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
	alert.tag = kAlertViewTagClearHistory;
	[alert show];
	[alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (alertView.tag == kAlertViewTagClearHistory && buttonIndex == kAlertViewButtonClearHistoryOK) {
		// clear history
		AutoSuggestManager * autoSuggest = [AutoSuggestManager sharedInstance];
		[autoSuggest clearHistory];
		
		// show confirmation message
		NSString * message = NSLocalizedString(@"All translation history has been cleared.", nil);
		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Verbatim Translate", nil) message:message delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
	// deselect selection
	NSIndexPath * tableSelection = [self.tableView indexPathForSelectedRow];
	[self.tableView deselectRowAtIndexPath:tableSelection animated:NO];
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		_settings = [[NSArray arrayWithObjects:NSLocalizedString(@"Request Professional Quote", nil), NSLocalizedString(@"Clear Translation History", nil), nil] retain];
	}
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	_aboutLabel.text = NSLocalizedString(@"About Verbatim Digital™", nil);
	_aboutText.text = NSLocalizedString(@"This is where you put all your info about the company and whatever else you want to put here in the about section.  Go ahead and give us the text and we'll put it in there.  I need something else to say so that it can fill up the space.  This app is going to be great.  This text will all be localized to the language of choice when selected above.", nil);
    
	// TODO - do in IB
	UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]
									initWithTitle:NSLocalizedString(@"Done", nil)
									style:UIBarButtonItemStyleBordered
									target:self
									action:@selector(showMainView:)];
	self.navigationItem.leftBarButtonItem = doneButton;
	[doneButton release];
	
	[super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
	// deselect previous selection
	NSIndexPath * table_selection = [self.tableView indexPathForSelectedRow];
	[self.tableView deselectRowAtIndexPath:table_selection animated:NO];

	[super viewWillAppear:animated];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[_tableView release];
	[_aboutLabel release];
	[_aboutText release];
	[_settings release];
	[super dealloc];
}


@end
