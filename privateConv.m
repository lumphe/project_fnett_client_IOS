//
//  private.m
//  project_fnett
//
//  Created by Alexander Lumphé on 2012-04-27.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "privateConv.h"
#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface privateConv ()

@end

@implementation privateConv

@synthesize textFromServer, message, client;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    labelY = 20;
    messageView.layer.borderWidth = 1.0f;
    messageView.layer.borderColor = [[UIColor blackColor] CGColor];
    [textFromServer setDelegate:self];
    [textFromServer setContentSize:CGSizeMake(320, 40)];
    [message setDelegate:self];
    [self.view bringSubviewToFront:message];
    [self.view bringSubviewToFront:send];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [[self client] sendMsgWithString:@"LEAVE_PC"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)appendTextView:(NSString *)text{
    //Set message
    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon3.png"]];
    [imageview setFrame:CGRectMake(3, 5, 15, 15)];
    
    UILabel *temp = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 160, 40)];
    [temp setFont:[UIFont fontWithName:@"Arial" size:12]];
    [temp setText:text];
    temp.numberOfLines = 0;
    [temp sizeToFit];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(3, labelY, 185, temp.frame.size.height+10)];
    [view.layer setCornerRadius:5.0f];
    [view.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [view.layer setBorderWidth:1.5f];
    
    labelY += view.frame.size.height+20;
    [view addSubview:temp];
    [view addSubview:imageview];
    
    [textFromServer setContentSize:CGSizeMake(320, labelY)];
    [textFromServer addSubview:view]; 
}

- (void)userAppendTextView:(NSString *)text{
    //Set message
    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon3.png"]];
    [imageview setFrame:CGRectMake(167, 5, 15, 15)];
    //[textFromServer addSubview:imageview];
    
    UILabel *temp = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 160, 40)];
    [temp setFont:[UIFont fontWithName:@"Arial" size:12]];
    [temp setText:text];
    temp.numberOfLines = 0;
    [temp sizeToFit];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(132, labelY, 185, temp.frame.size.height+10)];
    [view.layer setCornerRadius:5.0f];
    [view.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [view.layer setBorderWidth:1.5f];
    
    labelY += view.frame.size.height+20;
    
    [view addSubview:temp];
    [view addSubview:imageview];
    
    [textFromServer setContentSize:CGSizeMake(320, labelY)];
    [textFromServer addSubview:view];
    
    //textFromServer.text = [NSString stringWithFormat:@"%@ %@", textFromServer.text, text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if([textField isEqual:message]){
        [textField resignFirstResponder];
    }
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.2 
                     animations:^{
                         messageView.frame = CGRectOffset(messageView.frame, 0, -215);
                         [textFromServer setFrame:CGRectMake(0, 0, 320, 161)];
                         CGPoint bottomOffset = CGPointMake(0, textFromServer.contentSize.height - self.textFromServer.bounds.size.height);
                         [textFromServer setContentOffset:bottomOffset animated:YES];
                     }
                     completion:^(BOOL finished){
                         [progress setCenter:textFromServer.center];
                     }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.2
                     animations:^{
                         messageView.frame = CGRectOffset(messageView.frame, 0, 215);
                         [textFromServer setFrame:CGRectMake(0, 0, 320, 376)];
                     }
                     completion:^(BOOL finished){
                         [progress setCenter:textFromServer.center];
                     }];
}

-(IBAction)sendMsg:(id)sender{
    [client sendMsgWithString:message.text];
    NSUserDefaults *currentDefault = [NSUserDefaults standardUserDefaults];
    [self userAppendTextView:[NSString stringWithFormat:@"%@: %@\n",[currentDefault stringForKey:@"nickname"], message.text]];
    [message setText:@""];
}

@end
