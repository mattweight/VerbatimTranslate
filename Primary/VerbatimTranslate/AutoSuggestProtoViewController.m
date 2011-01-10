//
//  AutoSuggestProtoViewController.m
//  AutoSuggestProto
//
//  Created by Brandon George on 10/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

// TODO - scrolling on the textview
// TODO - cancel button of some sort (to go back to the bubble)
// TODO - what happens if there are zero suggestions? (darken it out, etc?)
// TODO - need to scroll to top (of table view) after each letter is pressed?

#import "AutoSuggestProtoViewController.h"
#import "AutoSuggestManager.h"
#import "JSON.h"

#import "ThemeManager.h"
#import "VerbatimConstants.h"

@interface AutoSuggestProtoViewController()

- (void)getTranslation:(NSString*)origText;

@end

@implementation AutoSuggestProtoViewController

@synthesize textInput = _textInput;
@synthesize suggestionsTable = _suggestionsTable;
@synthesize suggestions = _suggestions;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [_suggestions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString * kCellID = @"cellID";
	
	UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID] autorelease];
	}
	
	// set selected color to custom gray
	UIView * cellSelectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
	cellSelectedBackgroundView.backgroundColor = [UIColor darkGrayColor];
	cell.selectedBackgroundView = cellSelectedBackgroundView;
	[cellSelectedBackgroundView release];
	
	cell.textLabel.font = [UIFont boldSystemFontOfSize:12];
	cell.textLabel.text = [_suggestions objectAtIndex:indexPath.row];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self submitText:[_suggestions objectAtIndex:indexPath.row]];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
	[self _filterSuggestionsWithString:nil];
}

- (void)textViewDidChange:(UITextView *)textView {
	[self _filterSuggestionsWithString:textView.text];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	// check for return key press
    if ([text isEqualToString:@"\n"]) {
		[self submitText:textView.text];
        return NO;
    }
	
    return YES;
}

- (void)submitText:(NSString *)text {
	[[NSNotificationCenter defaultCenter] postNotificationName:TRANSLATION_DID_BEGIN_NOTIFICATION object:nil];
	[self getTranslation:text];
	//[self performSelectorInBackground:@selector(getTranslation:) withObject:text];
}

- (void)getTranslation:(NSString *)text {
	NSAutoreleasePool* arPool = [[NSAutoreleasePool alloc] init];
	
	// Get the web service language keyword..
	ThemeManager* manager = [ThemeManager sharedThemeManager];
	NSString* outputKeyword = [manager.currentTheme.services objectForKey:@"google-translate"];
	NSLog(@"Output keyword is: %@", outputKeyword);
	NSMutableString* translateURLString = [NSMutableString stringWithFormat:@"http://ajax.googleapis.com/ajax/services/language/translate?v=1.0&langpair="];
	[translateURLString appendString:@"en"];
	[translateURLString appendString:@"%7C"];
	[translateURLString appendString:outputKeyword];
	[translateURLString appendString:@"&q="];
	[translateURLString appendString:[text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSLog(@"The request url is %@", translateURLString);
	
	NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:translateURLString]];
	NSURLResponse* resp = [[NSURLResponse alloc] init];
	NSData* dataResp = [NSURLConnection sendSynchronousRequest:req returningResponse:&resp error:nil];
	NSString* respString = [[NSString alloc] initWithData:dataResp encoding:NSUTF8StringEncoding];
	NSString* message = [[[respString JSONValue] objectForKey:@"responseData"] objectForKey:@"translatedText"];
	
	// FIXME - Time to cheat. Too late tonight to do it right..
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:message forKey:VERBATIM_TRANSLATED_TEXT];
	[defaults setObject:text forKey:VERBATIM_ORIGINAL_TEXT];
	[defaults synchronize];

	// add text to history
	AutoSuggestManager* autoSuggest = [AutoSuggestManager sharedInstanceWithLanguage:@"en_US"];
	[autoSuggest addToHistory:text to:nil toLanguage:nil];
	
	[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:TRANSLATION_DID_COMPLETE_NOTIFICATION
																						 object:nil]];
	[arPool release];
}

- (void)_filterSuggestionsWithString:(NSString *)filterString {
	AutoSuggestManager * autoSuggest = [AutoSuggestManager sharedInstanceWithLanguage:@"en_US"];
	self.suggestions = [autoSuggest getAllPhrases:filterString];

	[_suggestionsTable reloadData];
	
	if ([self.suggestions count] > 0) {
		// make sure table is visible
		_suggestionsTable.hidden = NO;
		
		// scroll to top after each key press (user may have scrolled down and then pressed key)
		[_suggestionsTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
	} else {
		// do not show table at all if there are no suggestions
		_suggestionsTable.hidden = YES;
	}
}

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	// add accessory toolbar to keyboard (cancel/clear)
	UIToolbar * toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	toolbar.barStyle = UIBarStyleBlackOpaque;
	UIBarButtonItem * cancelButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(_onCancelButton:)];
	UIBarButtonItem * clearButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Clear", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(_onClearButton:)];
	NSArray * items = [NSArray arrayWithObjects:cancelButton, clearButton, nil];
	[cancelButton release];
	[clearButton release];
	[toolbar setItems:items animated:NO];
	_textInput.inputAccessoryView = toolbar;
	[toolbar release];
	
	[_textInput becomeFirstResponder];
}

- (void)_onCancelButton:(id)sender {
	[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:TRANSLATION_DID_CANCEL_NOTIFICATION
																						 object:nil]];
}

- (void)_onClearButton:(id)sender {
	_textInput.text = @"";
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
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[_textInput release];
	[_suggestionsTable release];
	[_suggestions release];
    [super dealloc];
}

@end
