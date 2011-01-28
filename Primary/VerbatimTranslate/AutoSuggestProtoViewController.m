//
//  AutoSuggestProtoViewController.m
//  AutoSuggestProto
//
//  Created by Brandon George on 10/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AutoSuggestProtoViewController.h"
#import "AutoSuggestManager.h"
#import "JSON.h"

#import "ThemeManager.h"
#import "VerbatimConstants.h"
#import "VerbatimTranslateAppDelegate.h"
#import "l10n.h"

@interface AutoSuggestProtoViewController (private)

- (void)_translateAndCommitText:(NSString *)text;
- (void)_getTranslation:(NSString *)text;
- (void)_commitText:(NSString *)originalText translatedText:(NSString *)translatedText;
- (void)_filterSuggestionsWithString:(NSString *)filterString;
- (void)_onCancelButton:(id)sender;
- (void)_onClearButton:(id)sender;

@end

@implementation AutoSuggestProtoViewController

@synthesize textInput = _textInput;
@synthesize suggestionsTable = _suggestionsTable;
@synthesize suggestions = _suggestions;
@synthesize	historyPhraseIds = _historyPhraseIds;

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
	// dismiss keyboard
	[self.textInput resignFirstResponder];

	// determine whether the phrase is in history cache or not
	long long historyPhraseId = [[_historyPhraseIds objectAtIndex:indexPath.row] longLongValue];
	if (historyPhraseId != 0) {
		// now determine whether the history phrase has already been translated in the current destination language
		NSString * originalText = [_suggestions objectAtIndex:indexPath.row];
		@try {
			AutoSuggestManager* autoSuggest = [AutoSuggestManager sharedInstance];
			NSString * translatedText = [autoSuggest getTranslatedPhrase:historyPhraseId];
			if (translatedText != nil) {
				// phrase has been translated in current destination language - commit immediately
				[self _commitText:originalText translatedText:translatedText];
			} else {
				// phrase has not yet been translated in current destination language - translate then commit
				[self _translateAndCommitText:originalText];
			}
		} @catch (NSException* e) {
			VerbatimTranslateAppDelegate* appDelegate = (VerbatimTranslateAppDelegate*)([UIApplication sharedApplication].delegate);
			[appDelegate displayGenericError];
		}
	} else {
		[self _translateAndCommitText:[_suggestions objectAtIndex:indexPath.row]];
	}	
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
		// dismiss keyboard
		[textView resignFirstResponder];
	
		[self _translateAndCommitText:textView.text];
		return NO;
    }
	
    return YES;
}

// private methods

- (void)_translateAndCommitText:(NSString *)text {
	NSNotification* notify = [NSNotification notificationWithName:DISPLAY_ACTIVITY_VIEW
														   object:nil
														 userInfo:[NSDictionary dictionaryWithObject:_(@"Translating..") forKey:@"load-text"]];
	[[NSNotificationCenter defaultCenter] postNotification:notify];
	[self _getTranslation:text];
	//[self performSelectorInBackground:@selector(_getTranslation:) withObject:text];
}

- (void)_getTranslation:(NSString *)text {
	// Get the web service language keyword..
	ThemeManager* manager = [ThemeManager sharedThemeManager];
	NSString * outputKeyword = [manager.currentTheme.services objectForKey:@"google-translate"];
	NSLog(@"Output keyword is: %@", outputKeyword);
	NSMutableString* translateURLString = [NSMutableString stringWithFormat:@"http://ajax.googleapis.com/ajax/services/language/translate?v=1.0&langpair="];
	[translateURLString appendString:[l10n getLanguage]];
	[translateURLString appendString:@"%7C"];
	[translateURLString appendString:outputKeyword];
	[translateURLString appendString:@"&q="];
	[translateURLString appendString:[text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSLog(@"The request url is %@", translateURLString);
	
	if (_translateData != nil && [_translateData retainCount] > 0) {
		[_translateData release];
	}
	_translateData = [[NSMutableData alloc] init];
	
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:text forKey:VERBATIM_ORIGINAL_TEXT];
	[defaults synchronize];
	
	NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:translateURLString]];
	NSURLConnection* connect = [NSURLConnection connectionWithRequest:req delegate:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[connection cancel];
	UIAlertView* failedAlert = [[[UIAlertView alloc] initWithTitle:_(@"Translation Failure")
														   message:[NSString stringWithFormat:_(@"Error: %@"), [error description]]
														  delegate:self
												 cancelButtonTitle:_(@"OK")
												 otherButtonTitles:nil] autorelease];
	[failedAlert show];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[_translateData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	// get translated text
	NSString* respString = [[NSString alloc] initWithData:_translateData encoding:NSUTF8StringEncoding];
	[_translateData release];
	_translateData = nil;
	NSString* translatedText = [[[respString JSONValue] objectForKey:@"responseData"] objectForKey:@"translatedText"];
	
	// get original text
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	NSString* originalText = [defaults objectForKey:VERBATIM_ORIGINAL_TEXT];
	
	// commit original & translated
	[self _commitText:originalText translatedText:translatedText];
}

- (void)_commitText:(NSString *)originalText translatedText:(NSString *)translatedText {
	// FIXME - Time to cheat. Too late tonight to do it right..
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:originalText forKey:VERBATIM_ORIGINAL_TEXT];
	[defaults setObject:translatedText forKey:VERBATIM_TRANSLATED_TEXT];
	[defaults synchronize];
	
	// add text to history
	@try {
		AutoSuggestManager* autoSuggest = [AutoSuggestManager sharedInstance];
		[autoSuggest addToHistory:originalText translatedText:translatedText];
	} @catch (NSException* e) {}

	[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:TRANSLATION_DID_COMPLETE_NOTIFICATION
																						 object:nil]];
}

- (void)_filterSuggestionsWithString:(NSString *)filterString {
	@try {
		AutoSuggestManager * autoSuggest = [AutoSuggestManager sharedInstance];
		NSDictionary * phraseInfo = [autoSuggest getAllPhrases:filterString];
		self.suggestions = [phraseInfo objectForKey:@"phrases"];
		self.historyPhraseIds = [phraseInfo objectForKey:@"historyPhraseIds"];
	
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
	} @catch (NSException* e) {
		VerbatimTranslateAppDelegate* appDelegate = (VerbatimTranslateAppDelegate*)([UIApplication sharedApplication].delegate);
		[appDelegate displayGenericError];
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
	UIBarButtonItem * cancelButton = [[UIBarButtonItem alloc] initWithTitle:_(@"Cancel") style:UIBarButtonItemStyleBordered target:self action:@selector(_onCancelButton:)];
	UIBarButtonItem * clearButton = [[UIBarButtonItem alloc] initWithTitle:_(@"Clear") style:UIBarButtonItemStyleBordered target:self action:@selector(_onClearButton:)];
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
    [_historyPhraseIds release];
	[super dealloc];
}

@end
