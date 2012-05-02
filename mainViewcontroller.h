//
//  mainViewcontroller.h
//  project_fnett
//
//  Created by Alexander Lumphé on 2012-04-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
@class ViewController;
@interface mainViewcontroller : UIViewController <UITextFieldDelegate>{
    ViewController *chatt;
    UIView *overlayer;
    UIView *background;
    UITextField *username;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;
-(void)statusMsg;
-(void)removeStatusMsg;
-(void)setUserName;

@end
