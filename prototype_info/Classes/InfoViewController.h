//
//  InfoViewController.h
//  InfoProto
//
//  Created by Brandon George on 10/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface InfoViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource> {
	UITableView * _tableView;
	UIBarButtonItem * _doneButton;
	UIPickerView * _languagePicker;
	UIToolbar * _languageToolbar;
	UIBarButtonItem * _setLanguageButton;
	NSArray * _settings;
	NSArray * _languages;
	NSString * _appLanguage;
}

@property (nonatomic, retain) IBOutlet UITableView * tableView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem * doneButton;
@property (nonatomic, retain) IBOutlet UIPickerView * languagePicker;
@property (nonatomic, retain) IBOutlet UIToolbar * languageToolbar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem * setLanguageButton;
@property (nonatomic, retain) NSString * appLanguage;

- (IBAction)showMainView:(id)sender;
- (IBAction)setNewAppLanguage:(id)sender;
- (void)showQuoteView;
- (void)showLanguagePicker;
- (void)dismissLanguagePicker;
- (void)showHistoryWarning;
@end
