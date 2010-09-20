//
//  ProtoMainViewController.m
//  ProtoMain
//
//  Created by Matt Weight on 9/15/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "ProtoMainViewController.h"
#import "JSON.h"

@implementation ProtoMainViewController



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


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

- (IBAction) translate:(id)sender {
	NSLog(@"the text to translate is: %@", translateTextField.text);
}

#
#pragma mark UITextFieldDelegate
#

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	NSLog(@"The text to translate: %@", textField.text);
	
	NSMutableString* translateURLString = [NSMutableString stringWithFormat:@"http://ajax.googleapis.com/ajax/services/language/translate?v=1.0&langpair="];
	[translateURLString appendString:@"en"];
	[translateURLString appendString:@"%7C"];
	[translateURLString appendString:@"ja"];
	[translateURLString appendString:@"&q="];
	[translateURLString appendString:[textField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSLog(@"The request url is %@", translateURLString);
	
	NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:translateURLString]];
	NSURLResponse* resp = [[NSURLResponse alloc] init];
	NSData* dataResp = [NSURLConnection sendSynchronousRequest:req returningResponse:&resp error:nil];
	NSString* respString = [[NSString alloc] initWithData:dataResp encoding:NSUTF8StringEncoding];
	
	NSLog(@"the data is %@", respString);
	NSLog(@"The response is %@", resp);
	
	NSString* translatedText = [[[respString JSONValue] objectForKey:@"responseData"] objectForKey:@"translatedText"];
	[translateDestTextField setText:translatedText];
//	NSURLConnection* connect = [NSURLConnection connectionWithRequest:req delegate:self];
//	[connect start];
//	[translateDestTextField setText:translateURLString];
	return YES;
}

#
#pragma mark NSURLConnection Delegate
#
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	NSLog(@"The data looks like %@", data);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSLog(@"We finished connecting..");
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
    [super dealloc];
}

@end
