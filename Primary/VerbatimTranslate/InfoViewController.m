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
#define kSettingsSetLanguage			1
#define kSettingsClearHistory			2
#define kAlertViewTagClearHistory		1
#define kAlertViewButtonClearHistoryOK	1

@implementation InfoViewController

@synthesize tableView = _tableView;
@synthesize languageToolbar = _languageToolbar;
@synthesize setLanguageButton = _setLanguageButton;
@synthesize languagePicker = _languagePicker;
@synthesize appLanguage = _appLanguage;

- (IBAction)showMainView:(id)sender {
	if (self.languagePicker.center.y < 460) {	// TODO - fix
		[self dismissLanguagePicker];
	}
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
}

- (IBAction)setNewAppLanguage:(id)sender {
	self.appLanguage = [_languages objectAtIndex:[self.languagePicker selectedRowInComponent:0]];
	[[NSUserDefaults standardUserDefaults] setValue:self.appLanguage forKey:@"appLanguage"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	[self dismissLanguagePicker];
	[self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [_settings count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString * kCellID = @"cellID";
	
	UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
	if (cell == nil) {
		UITableViewCellStyle cellStyle = (indexPath.row == kSettingsSetLanguage) ? UITableViewCellStyleValue1 : UITableViewCellStyleDefault;
		cell = [[[UITableViewCell alloc] initWithStyle:cellStyle reuseIdentifier:kCellID] autorelease];
	}
	
	cell.selectionStyle = UITableViewCellSelectionStyleGray;
	if (indexPath.row == kSettingsRequestQuote) {
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	} else if (indexPath.row == kSettingsSetLanguage) {
		cell.detailTextLabel.text = self.appLanguage;
	}
	
	cell.textLabel.text = [_settings objectAtIndex:indexPath.row];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.row) {
		case kSettingsRequestQuote:
			[self showQuoteView];
			break;
			
		case kSettingsSetLanguage:
			[self showLanguagePicker];
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
	quoteViewController.title = @"Professional Quote";
	UIBarButtonItem * backButton = [[UIBarButtonItem alloc]
									 initWithTitle:@"Back"
									 style:UIBarButtonItemStyleBordered
									 target:nil
									 action:nil];
	self.navigationItem.backBarButtonItem = backButton;
	[backButton release];
	
	// push view controller
	[self.navigationController pushViewController:quoteViewController animated:YES];
	[quoteViewController release];
}

- (void)showLanguagePicker {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];

	// TODO - should be in it's own view/vc
	
	float moveValue = self.languagePicker.bounds.size.height + self.languageToolbar.bounds.size.height;
	
	// move toolbar
	CGPoint toolbarCenter = self.languageToolbar.center;
	toolbarCenter.y -= moveValue;
	self.languageToolbar.center = toolbarCenter;

	// move picker
	CGPoint pickerCenter = self.languagePicker.center;
	pickerCenter.y -= moveValue;
	self.languagePicker.center = pickerCenter;
		
	[UIView commitAnimations];
}

- (void)dismissLanguagePicker {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	
	// TODO - should be in it's own view/vc
	// TODO - should be merged with above method (very similar)
	// TODO - in .xib, button is currently centered by fixed left spacer (will not work when words are localized)
	
	float moveValue = self.languagePicker.bounds.size.height + self.languageToolbar.bounds.size.height;
	
	// move toolbar
	CGPoint toolbarCenter = self.languageToolbar.center;
	toolbarCenter.y += moveValue;
	self.languageToolbar.center = toolbarCenter;
	
	// move picker
	CGPoint pickerCenter = self.languagePicker.center;
	pickerCenter.y += moveValue;
	self.languagePicker.center = pickerCenter;
	
	[UIView commitAnimations];	
}

- (void)showHistoryWarning {
	// show warning
	NSString * message = @"Are you sure you want to clear all translation history?  Your previous translations will not show up as suggestions anymore.";
	UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Verbatim Translate" message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
	alert.tag = kAlertViewTagClearHistory;
	[alert show];
	[alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (alertView.tag == kAlertViewTagClearHistory && buttonIndex == kAlertViewButtonClearHistoryOK) {
		// clear history
		AutoSuggestManager * autoSuggest = [AutoSuggestManager sharedInstanceWithLanguage:@"en_US"];
		[autoSuggest clearHistory];
		
		// show confirmation message
		NSString * message = @"All translation history has been cleared.";
		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Verbatim Translate" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
	// deselect selection
	NSIndexPath * tableSelection = [self.tableView indexPathForSelectedRow];
	[self.tableView deselectRowAtIndexPath:tableSelection animated:NO];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return [_languages count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    return [_languages objectAtIndex:row];
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		_settings = [[NSArray arrayWithObjects:@"Request Professional Quote", @"Set Interface Language", @"Clear Translation History", nil] retain];
		_languages = [[NSArray arrayWithObjects:@"English", @"Spanish", @"Korean", @"Japanese", @"Chinese", nil] retain];
		_appLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"];
		if (!_appLanguage) {
			_appLanguage = @"English";
		}
	}
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	// find key
	int index = 0;
	for (int i = 0; i < [_languages count]; i++) {
		if ([[_languages objectAtIndex:i] isEqualToString:_appLanguage]) {
			index = i;
			break;
		}
	}
    [self.languagePicker selectRow:index inComponent:0 animated:NO];
    
	// TODO - do in IB
	UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]
									initWithTitle:@"Done"
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
	[_languagePicker release];
	[_settings release];
    [_languages release];
	[_appLanguage release];
	[super dealloc];
}


@end
