//
//  private.h
//  project_fnett
//
//  Created by Alexander Lumphé on 2012-04-27.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@class ViewController;
@interface privateConv : UIViewController <UITextFieldDelegate, UITextViewDelegate>{
    IBOutlet UIButton *send;
    IBOutlet UITextField *message;
    IBOutlet UIScrollView *textFromServer;
    IBOutlet UIActivityIndicatorView *progress;
    IBOutlet UIView *messageView;
    int labelY;
    ViewController *client;
}

@property (nonatomic, retain) IBOutlet UIScrollView *textFromServer;
@property (nonatomic, retain) IBOutlet UITextField *message;
@property (nonatomic, retain) ViewController *client;

- (void)appendTextView:(NSString *)text;
- (void)userAppendTextView:(NSString *)text;
-(IBAction)sendMsg:(id)sender;

@end
