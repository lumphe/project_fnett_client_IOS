//
//  SettingsView.h
//  project_fnett
//
//  Created by Alexander Lumphé on 2012-04-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsView : UITableViewController <UITextFieldDelegate>{
    IBOutlet UITextField *ipadress;
    IBOutlet UITextField *nickname;
    
}

@property (nonatomic, retain) IBOutlet UITextField *ipadress;
@property (nonatomic, retain) IBOutlet UITextField *nickname;

@end
