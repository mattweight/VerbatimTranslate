//
//  InfoProtoViewController.h
//  InfoProto
//
//  Created by Brandon George on 10/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoProtoViewController : UIViewController {
	
@private
	UIButton * _infoButton;
}

@property (nonatomic, retain) IBOutlet UIButton * infoButton;

- (IBAction)showInfoView:(id)sender;

@end

