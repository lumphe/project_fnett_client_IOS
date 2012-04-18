//
//  SettingsView.h
//  project_fnett
//
//  Created by Alexander Lumphé on 2012-04-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsView : UITableViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    IBOutlet UITextField *ipadress;
    IBOutlet UITextField *nickname;
    UIImage *userImage;
}

@property (nonatomic, retain) IBOutlet UITextField *ipadress;
@property (nonatomic, retain) IBOutlet UITextField *nickname;
@property (nonatomic, retain) UIImage *userImage;

- (BOOL) startMediaBrowserFromViewController: (UIViewController*) controller
                               usingDelegate: (id <UIImagePickerControllerDelegate,
                                               UINavigationControllerDelegate>) delegate;

@end
