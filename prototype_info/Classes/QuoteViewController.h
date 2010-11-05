//
//  QuoteViewController.h
//  InfoProto
//
//  Created by Brandon George on 11/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface QuoteViewController : UIViewController {

@private
	UIWebView * _webView;
}

@property (nonatomic, retain) IBOutlet UIWebView * webView;

@end
