//
//  ViewController.h
//  project_fnett
//
//  Created by Alexander Lumphé on 2012-04-14.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsView.h"
#import "mainViewcontroller.h"
#import "privateConv.h"
@class mainViewcontroller;
@class privateConv;
@interface ViewController : UIViewController <NSStreamDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>{

    IBOutlet UIButton *send;
    IBOutlet UITextField *message;
    IBOutlet UIScrollView *textFromServer;
    IBOutlet UIActivityIndicatorView *progress;
    IBOutlet UIView *messageView;
    UIPickerView *commands;
    NSOutputStream *oStream;
    NSInputStream *iStream;
    NSStream *stream;
    NSMutableArray *commandsArray;
    NSInteger state;
    BOOL show;
    int labelY;
    SettingsView *settings;
    mainViewcontroller *main;
    privateConv *conv;
    BOOL Connected;
    NSArray *connections;
    UIView *PMView;
    UITableView *connectionsList;
    BOOL PC;
}

@property (nonatomic, retain) IBOutlet UIButton *send;
@property (nonatomic, retain) IBOutlet UITextField *message;
@property (nonatomic, retain) IBOutlet UIScrollView *textFromServer;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *progress;
@property (nonatomic, retain) NSOutputStream *oStream;
@property (nonatomic, retain) NSInputStream *iStream;
@property (nonatomic, retain) NSStream *stream;

-(void)sendMsgWithString:(NSString *)msg;
-(void)appendTextView:(NSString *)text;
-(void)userAppendTextView:(NSString *)text;
-(void)showPickerView;
-(void)connect:(mainViewcontroller *)viewcontroller;
-(void)disconnenct;
-(void)PM;
-(void)PMView;

@end
