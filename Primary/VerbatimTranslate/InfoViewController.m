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
#import "VerbatimTranslateAppDelegate.h"
#import "VerbatimConstants.h"
#import "l10n.h"

#define kSettingsRequestQuote				0
#define kSettingsClearHistory				1
#define kAlertViewTagClearHistory			1
#define kAlertViewButtonClearHistoryOK		1
#define kSourceLanguageActivityViewDuration	1

@implementation InfoViewController

@synthesize tableView = _tableView;
@synthesize aboutLabel = _aboutLabel;
@synthesize aboutText = _aboutText;
@synthesize borderTableView;
@synthesize sourceFlagController;

- (IBAction)showMainView:(id)sender {
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if ([tableView isEqual:borderTableView]) {
		return 1;
	}
	return [_settings count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString * kCellID = @"cellID";
	
	UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
	if (cell == nil) {
		[tableView setBackgroundColor:[UIColor clearColor]];
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID] autorelease];
		[cell.backgroundView setBackgroundColor:[UIColor clearColor]];
		//[cell setBackgroundColor:[UIColor whiteColor]];
	}
	
	if ([tableView isEqual:borderTableView]) {
		[cell setFrame:CGRectMake(0.0, 0.0, 300, 210.0)];
		NSLog(@"content view: %02f X %02f", cell.frame.size.width, cell.frame.size.height);
		UITextView* aboutView = [[UITextView alloc] initWithFrame:CGRectMake(0.0, 0.0, (cell.frame.size.width - 20.0), (cell.frame.size.height - 10.0))];
		[aboutView setScrollEnabled:NO];
		[aboutView setTextAlignment:UITextAlignmentCenter];
		[aboutView setBackgroundColor:[UIColor clearColor]];
		[aboutView setFont:[UIFont systemFontOfSize:13.0]];
		[aboutView setEditable:NO];
		[aboutView setCenter:cell.center];
		aboutView.text = _(@"About Verbatim Digital\n\nThis is where you put all your info about the company and whatever else you want to put here in the about section.  Go ahead and give us the text and we'll put it in there.  I need something else to say so that it can fill up the space.  This app is going to be great.  This text will all be localized to the language of choice when selected above.");
		[cell addSubview:aboutView];
		[aboutView release];
		aboutView = nil;
		return cell;
	}
	
	cell.selectionStyle = UITableViewCellSelectionStyleGray;
	if (indexPath.row == kSettingsRequestQuote) {
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}	
	cell.textLabel.text = [_settings objectAtIndex:indexPath.row];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([tableView isEqual:borderTableView]) {
		return;
	}
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
	quoteViewController.title = _(@"Professional Quote");
	UIBarButtonItem * backButton = [[UIBarButtonItem alloc]
									 initWithTitle:_(@"Back")
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
	NSString * message = _(@"Are you sure you want to clear all translation history?  Your previous translations will not show up as suggestions anymore.");
	UIAlertView * alert = [[UIAlertView alloc] initWithTitle:_(@"Verbatim Translate") message:message delegate:self cancelButtonTitle:_(@"Cancel") otherButtonTitles:_(@"OK"), nil];
	alert.tag = kAlertViewTagClearHistory;
	[alert show];
	[alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (alertView.tag == kAlertViewTagClearHistory && buttonIndex == kAlertViewButtonClearHistoryOK) {
		// clear history
		@try {
			AutoSuggestManager * autoSuggest = [AutoSuggestManager sharedInstance];
			[autoSuggest clearHistory];
		} @catch (NSException * e) {
			VerbatimTranslateAppDelegate* appDelegate = (VerbatimTranslateAppDelegate*)([UIApplication sharedApplication].delegate);
			[appDelegate displayGenericError];

			// deselect selection
			NSIndexPath * tableSelection = [self.tableView indexPathForSelectedRow];
			[self.tableView deselectRowAtIndexPath:tableSelection animated:NO];			
		}
		
		// show confirmation message
		NSString * message = _(@"All translation history has been cleared.");
		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:_(@"Verbatim Translate") message:message delegate:self cancelButtonTitle:_(@"OK") otherButtonTitles:nil];
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
		_settings = [[NSArray arrayWithObjects:_(@"Request Professional Quote"), _(@"Clear Translation History"), nil] retain];
		[borderTableView setRowHeight:182.0];
		if (sourceFlagController == nil) {
			FlagsTableViewController* fController = [[FlagsTableViewController alloc] initWithStyle:UITableViewStylePlain];
			[fController.view setCenter:CGPointMake(-116.0, 142.0)];
			[self.view addSubview:fController.view];
			sourceFlagController = [fController retain];
			[fController release];
			fController = nil;
		}		
	}
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	_aboutLabel.text = _(@"About Verbatim Digital™");
	_aboutText.text = _(@"This is where you put all your info about the company and whatever else you want to put here in the about section.  Go ahead and give us the text and we'll put it in there.  I need something else to say so that it can fill up the space.  This app is going to be great.  This text will all be localized to the language of choice when selected above.");
    
	UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]
									initWithTitle:_(@"Done")
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

- (void)_changeSourceLanguage:(NSString *)language {
	// set autoSuggest source language (switch suggestion tables)
	@try {
		[AutoSuggestManager sharedInstance].sourceLanguage = language;
	} @catch (NSException* e) {}
	
	// set l10n source language (static text language)
	[l10n setLanguage:language];
	
	// reload view for static text to update to new language (activity view)
	NSNotification* notify = [NSNotification notificationWithName:DISPLAY_ACTIVITY_VIEW
														   object:nil
														 userInfo:[NSDictionary dictionaryWithObject:_(@"Changing Language..") forKey:@"load-text"]];
	[[NSNotificationCenter defaultCenter] postNotification:notify];
	[NSTimer scheduledTimerWithTimeInterval:kSourceLanguageActivityViewDuration target:self selector:@selector(_removeActivityView:) userInfo:nil repeats:NO];
}

- (void)_removeActivityView:(NSTimer *)timer {
	[[NSNotificationCenter defaultCenter] postNotificationName:REMOVE_ACTIVITY_VIEW
														object:nil];
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
