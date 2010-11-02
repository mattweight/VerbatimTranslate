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
	NSString * message = [NSString stringWithFormat:@"\"%@\" will now be placed in the translation bubble, and then translated.", text];
	UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:@"Verbatim" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil] autorelease];
	[alert show];
	
	// add text to history
	AutoSuggestManager * autoSuggest = [AutoSuggestManager sharedInstanceWithLanguage:@"en_US"];
	[autoSuggest addToHistory:text to:nil toLanguage:nil];	
}

- (void)alertView:(UIAlertView *)alert_view clickedButtonAtIndex:(NSInteger)button_index {
	// clear currently selected row
	[_suggestionsTable deselectRowAtIndexPath:[_suggestionsTable indexPathForSelectedRow] animated:YES];
		
	_textInput.text = @"";
}

- (void)_filterSuggestionsWithString:(NSString *)filterString {
	AutoSuggestManager * autoSuggest = [AutoSuggestManager sharedInstanceWithLanguage:@"en_US"];
	self.suggestions = [autoSuggest getAllPhrases:filterString];
	[_suggestionsTable reloadData];
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
	[_textInput becomeFirstResponder];
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
