//
//  mainViewcontroller.m
//  project_fnett
//
//  Created by Alexander Lumphé on 2012-04-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "mainViewcontroller.h"
#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface mainViewcontroller ()

@end

@implementation mainViewcontroller

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
	// Do any additional setup after loading the view.
    NSUserDefaults *currentDefault = [NSUserDefaults standardUserDefaults];
    if([[currentDefault stringForKey:@"nickname"] isEqualToString:@""]){
        [self statusMsg];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"settings"]){
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] 
                                       initWithTitle: @"Back" 
                                       style: UIBarButtonItemStyleBordered
                                       target: nil action: nil];
        
        [self.navigationItem setBackBarButtonItem: backButton];
    }
    if([[segue identifier] isEqualToString:@"connect"]){
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] 
                                       initWithTitle: @"Disconnect" 
                                       style: UIBarButtonItemStyleBordered
                                       target:nil action:nil];
        
        [self.navigationItem setBackBarButtonItem: backButton];
        chatt = segue.destinationViewController;
        [chatt connect:self];
    }
}

-(void)statusMsg{
    overlayer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [overlayer setBackgroundColor:[UIColor grayColor]];
    overlayer.alpha = 0.8;
    
    background = [[UIView alloc] initWithFrame:CGRectMake(20, 80, 280, 200)];
    [background setBackgroundColor:[UIColor whiteColor]];
    background.layer.borderWidth = 1.0f;
    background.layer.borderColor = [[UIColor blackColor] CGColor];
    
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 240, 60)];
    [text setText:@"Du har inget användar namn, skulle du önska att sätta det?"];
    [text setNumberOfLines:0];
    [text setTextAlignment:UITextAlignmentCenter];
    [text setBackgroundColor:[UIColor clearColor]];
    
    username = [[UITextField alloc] initWithFrame:CGRectMake(20, 90, 240, 30)];
    [username setPlaceholder:@"Användarnamn"];
    [username setBorderStyle:UITextBorderStyleRoundedRect];
    [username setDelegate:self];
    
    UIButton *no = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    no.frame = CGRectMake(60, 160, 60, 30);
    [no addTarget:self action:@selector(removeStatusMsg) forControlEvents:UIControlEventTouchUpInside];
    [no setTitle:@"NO" forState:UIControlStateNormal];
    
    UIButton *yes = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    yes.frame = CGRectMake(160, 160, 60, 30);
    [yes addTarget:self action:@selector(setUserName) forControlEvents:UIControlEventTouchUpInside];
    [yes setTitle:@"YES" forState:UIControlStateNormal];
    
    [self.view addSubview:overlayer];
    [self.view addSubview:background];
    [background addSubview:yes];
    [background addSubview:no];
    [background addSubview:text];
    [background addSubview:username];
}

-(void)removeStatusMsg{
    [overlayer removeFromSuperview];
    [background removeFromSuperview];
}

-(void)setUserName{
    NSUserDefaults *currentDefault = [NSUserDefaults standardUserDefaults];
    [currentDefault setObject:username.text forKey:@"nickname"];
    [self removeStatusMsg];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [UIView animateWithDuration:0.2 
                     animations:^{
                         background.frame = CGRectOffset(background.frame, 0, 50);
                     }
                     completion:^(BOOL finished){

                     }];
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.2 
                     animations:^{
                         background.frame = CGRectOffset(background.frame, 0, -50);
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

@end
