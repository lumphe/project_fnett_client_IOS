//
//  ViewController.h
//  project_fnett
//
//  Created by Alexander Lumphé on 2012-04-14.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <NSStreamDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>{

    IBOutlet UIButton *send;
    IBOutlet UITextField *message;
    IBOutlet UITextView *textFromServer;
    IBOutlet UIActivityIndicatorView *progress;
    UIPickerView *commands;
    NSOutputStream *oStream;
    NSInputStream *iStream;
    NSStream *stream;
    NSMutableArray *commandsArray;
    NSInteger state;
    IBOutlet UIBarButtonItem *openclose;
    BOOL show;
}

@property (nonatomic, retain) IBOutlet UIBarButtonItem *openclose;
@property (nonatomic, retain) IBOutlet UIButton *send;
@property (nonatomic, retain) IBOutlet UITextField *message;
@property (nonatomic, retain) IBOutlet UITextView *textFromServer;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *progress;
@property (nonatomic, retain) NSOutputStream *oStream;
@property (nonatomic, retain) NSInputStream *iStream;
@property (nonatomic, retain) NSStream *stream;

-(void)sendMsgWithString:(NSString *)msg;
-(void)appendTextView:(NSString *)text;
-(IBAction)showPickerView:(id)sender;

@end
