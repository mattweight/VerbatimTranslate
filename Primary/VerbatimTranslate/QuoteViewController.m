//
//  QuoteViewController.m
//  InfoProto
//
//  Created by Brandon George on 11/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "QuoteViewController.h"
#import "l10n.h"
#import "VerbatimConstants.h"

#define kSubmissionTimeoutSeconds	30
#define kSpinnerSize				100

@implementation QuoteViewController

@synthesize webView = _webView;

/*
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	_webView.delegate = self;
	[_webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"quoteView" ofType:@"html" inDirectory:nil forLocalization:[l10n getLanguage]] isDirectory:NO]]];
	[super viewDidLoad];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	NSString * pageName = request.URL.lastPathComponent;
	
	if ([pageName rangeOfString:@"native|"].location == 0) {	// check for native alert callback (protocol is "native|<message>")
		NSString * message = [pageName substringFromIndex:7];
		[self _displayErrorMessage:message];
		return NO;
	} else if ([pageName isEqualToString:@"quoteView.html"] || [pageName isEqualToString:@"thankyou.html"]) {	// local html load - allow
		return YES;
	} else if ([pageName isEqualToString:@"submit.php"]) {		// about to submit form - show spinner/setup timeout
		[self _showSpinner];
		_timeoutTimer = [[NSTimer scheduledTimerWithTimeInterval:kSubmissionTimeoutSeconds target:self selector:@selector(_submissionTimeout:) userInfo:nil repeats:NO] retain];
		return YES;
	} else if ([pageName isEqualToString:@"thankyou.php"]) {	// successful submission - show custom thank you page (not default thank you page)
		[self _clearSpinner];
		[self _clearTimer];
		[webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"thankyou" ofType:@"html" inDirectory:nil forLocalization:[l10n getLanguage]] isDirectory:NO]]];
		return NO;
	} else {	// anything else - error out
		[self _clearSpinner];
		[self _clearTimer];
		[self _displayDefaultErrorMessage];
		return NO;
	}
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	// do not do anything here because any return 'NO' above calls this method, and we want to let it go through.
}

- (void)_displayErrorMessage:(NSString *)message {
	UIAlertView * alert = [[UIAlertView alloc] initWithTitle:ALERT_TITLE message:message delegate:self cancelButtonTitle:nil otherButtonTitles:_(@"OK"), nil];
	[alert show];
	[alert release];	
}

- (void)_displayDefaultErrorMessage {
	[self _displayErrorMessage:_(@"We're sorry, an error has occurred.  Please try again.")];
}

- (void)_showSpinner {
	_spinnerView = [[SpinnerView alloc] initWithFrame:CGRectMake(self.view.center.x - (kSpinnerSize / 2), self.view.center.y - (kSpinnerSize / 2), kSpinnerSize, kSpinnerSize)];
	[self.view addSubview:_spinnerView];
	[self.navigationItem setHidesBackButton:YES animated:YES];	// do not allow user to leave the screen while submitting quote (otherwise crash happens when response returns)
}

- (void)_clearSpinner {
	if (_spinnerView) {
		[_spinnerView removeFromSuperview];
		[_spinnerView release];
		_spinnerView = nil;
	}
	[self.navigationItem setHidesBackButton:NO animated:YES];	// show back button again now that we have received a response
}

- (void)_clearTimer {
	if (_timeoutTimer) {
		[_timeoutTimer invalidate];
		[_timeoutTimer release];
		_timeoutTimer = nil;
	}
}

- (void)_submissionTimeout:(NSTimer *)timer {
	[_webView stopLoading];
	[self _clearSpinner];
	[self _displayDefaultErrorMessage];
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
	_webView.delegate = nil;	// supposed to do this before releasing the UIWebView
	[_webView release];
	[self _clearSpinner];
	[self _clearTimer];
    [super dealloc];
}


@end
