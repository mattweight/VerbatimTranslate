//
//  QuoteViewController.h
//  InfoProto
//
//  Created by Brandon George on 11/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpinnerView.h"

@interface QuoteViewController : UIViewController<UIWebViewDelegate> {

@private
	UIWebView * _webView;
	SpinnerView * _spinnerView;
	NSTimer * _timeoutTimer;
}

@property (nonatomic, retain) IBOutlet UIWebView * webView;

- (void)_displayErrorMessage:(NSString *)message;
- (void)_displayDefaultErrorMessage;
- (void)_showSpinner;
- (void)_clearSpinner;
- (void)_submissionTimeout:(NSTimer *)timer;
- (void)_clearTimer;

@end
