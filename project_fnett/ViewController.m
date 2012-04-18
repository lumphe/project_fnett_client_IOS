//
//  ViewController.m
//  project_fnett
//
//  Created by Alexander Lumphé on 2012-04-14.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation ViewController

@synthesize send, iStream, oStream, stream, textFromServer, message, progress, openclose;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    state = 0;
    commandsArray = [[NSMutableArray alloc] init];
    [commandsArray addObject:@"SET_USERNAME"];
    [commandsArray addObject:@"GET_STATE"];
    [commandsArray addObject:@"DISABLE_CONNECTION"];
    [commandsArray addObject:@"DISCONNECT_CONFIRMED"];
    [commandsArray addObject:@""];
    textFromServer.editable = NO;
    textFromServer.layer.borderWidth = 1.0f;
    textFromServer.layer.borderColor = [[UIColor blackColor] CGColor];
    [message setDelegate:self];
    [self.view bringSubviewToFront:message];
    [self.view bringSubviewToFront:send];
    commands = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 416, 320, 200)];
    commands.showsSelectionIndicator = YES;
    [commands setDelegate:self];
    [self.view addSubview:commands];
    [progress setCenter:textFromServer.center];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)sendMsg:(id)sender{
    if([oStream hasSpaceAvailable] && state == 2){
        [self sendMsgWithString:message.text];
        NSUserDefaults *currentDefault = [NSUserDefaults standardUserDefaults];
        [self appendTextView:[NSString stringWithFormat:@"%@: %@\n",[currentDefault stringForKey:@"nickname"], message.text]];
        [message setText:@""];
    }else if(state == 0){
        [progress startAnimating];
        NSUserDefaults *currentDefault = [NSUserDefaults standardUserDefaults];
        CFReadStreamRef readStream;
        CFWriteStreamRef writeStream;
        CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)[currentDefault stringForKey:@"ipadress"], 30001, &readStream, &writeStream);
        iStream = (__bridge NSInputStream *)readStream;
        oStream = (__bridge NSOutputStream *)writeStream;
        [iStream setProperty:NSStreamNetworkServiceTypeVoIP forKey:NSStreamNetworkServiceType];
        [oStream setProperty:NSStreamNetworkServiceTypeVoIP forKey:NSStreamNetworkServiceType];
        [iStream setDelegate:self];
        [oStream setDelegate:self];
        [iStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [oStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [iStream open];
        [oStream open];
    }
}

-(void)sendMsgWithString:(NSString *)msg{
    if([oStream hasSpaceAvailable]){
        NSString *response  = [NSString stringWithFormat:@"%@\n", msg];
        NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSUTF8StringEncoding]];
    
        [oStream write:[data bytes] maxLength:[data length]];
    }else{
        NSLog(@"No space is avilabel for sending data");
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if([textField isEqual:message]){
        [textField resignFirstResponder];
    }
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if(show){
        [self showPickerView:openclose];
    }
    [UIView animateWithDuration:0.2 
                     animations:^{
                         message.frame = CGRectOffset(message.frame, 0, -210);
                         send.frame = CGRectOffset(send.frame, 0, -210);
                         [textFromServer setFrame:CGRectMake(-1, -1, 322, 147)];
                     }
                     completion:^(BOOL finished){
                         [progress setCenter:textFromServer.center];
                     }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.2
                     animations:^{
                         message.frame = CGRectOffset(message.frame, 0, 210);
                         send.frame = CGRectOffset(send.frame, 0, 210);
                         [textFromServer setFrame:CGRectMake(-1, -1, 322, 357)];
                     }
                     completion:^(BOOL finished){
                         [progress setCenter:textFromServer.center];
                     }];
}

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    if(theStream == iStream){
        NSLog(@"iStream event %i", streamEvent);
        NSLog(@"iStream status %i", [theStream streamStatus]);
    }else{
        NSLog(@"oStream event %i", streamEvent);
        NSLog(@"oStream status %i", [theStream streamStatus]);
    }

	switch (streamEvent) {
			
		case NSStreamEventOpenCompleted:
			NSLog(@"Stream opened");
            [self appendTextView:@"Stream opened\n"];
            [progress stopAnimating];
			break;
		case NSStreamEventHasBytesAvailable:
            
			if (theStream == iStream) {
				
				uint8_t buffer[1024];
				int len;
				
				while ([iStream hasBytesAvailable]) {
					len = [iStream read:buffer maxLength:sizeof(buffer)];
					if (len > 0) {
						
						NSString *input = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
						
						if (nil != input) {
							NSLog(@"server said: %@", input);
                            [self appendTextView:input];
                            NSString *comper = [input stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                            if([comper isEqualToString:@"HELLO_CLIENT"]){
                                [self sendMsgWithString:@"ESTABLISH_CONNECTION"];
                                state = 1;
                            }else if([comper isEqualToString:@"CONNECTION_ESTABLISHED"]){
                                [send setTitle:@"send" forState:UIControlStateNormal];
                                state = 2;
                            }else if([comper isEqualToString:@"SEND_USERNAME"]){
                                NSUserDefaults *currentDefault = [NSUserDefaults standardUserDefaults];
                                if(![[currentDefault stringForKey:@"nickname"] isEqualToString:@""]){
                                    [self sendMsgWithString:[currentDefault stringForKey:@"nickname"]];
                                }else{
                                    [self sendMsgWithString:[currentDefault stringForKey:@"anonymous"]];
                                }
                            }
						}
					}
				}
			}
			break;
            
			
		case NSStreamEventErrorOccurred:
			[progress stopAnimating];
            [send setTitle:@"connect" forState:UIControlStateNormal];
            state = 0;
			NSLog(@"Can not connect to the host!");
			break;
            
        case NSStreamEventHasSpaceAvailable:
            NSLog(@"Has Space");
            if(state == 0){
                [self sendMsgWithString:@"HELLO_SERVER"];
                state = 1337;
            }
            break;
			
		case NSStreamEventEndEncountered:
            
            [theStream close];
            [theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            theStream = nil;
			[progress stopAnimating];
            [send setTitle:@"connect" forState:UIControlStateNormal];
            state = 0;
			break;
		default:
			NSLog(@"Unknown event");
	}
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [commandsArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [commandsArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    message.text = [commandsArray objectAtIndex:row];
}
- (void)appendTextView:(NSString *)text{
    textFromServer.text = [NSString stringWithFormat:@"%@ %@", textFromServer.text, text];
}

- (IBAction)showPickerView:(id)sender{
    if([message isFirstResponder] && !show){
        [message resignFirstResponder];
    }
    if(!show){
        [UIView animateWithDuration:0.2
                         animations:^{
                             commands.frame = CGRectOffset(commands.frame, 0, -180); 
                             message.frame = CGRectOffset(message.frame, 0, -175);
                             send.frame = CGRectOffset(send.frame, 0, -175);
                             [textFromServer setFrame:CGRectMake(-1, -1, 322, 182)];
                         }
                         completion:^(BOOL finished){
                             show = YES;
                             [openclose setTitle:@"close"];
                             [progress setCenter:textFromServer.center];
                         }];
    }else if(show){
        [UIView animateWithDuration:0.2
                         animations:^{
                             commands.frame = CGRectOffset(commands.frame, 0, 180); 
                             message.frame = CGRectOffset(message.frame, 0, 175);
                             send.frame = CGRectOffset(send.frame, 0, 175);
                             [textFromServer setFrame:CGRectMake(-1, -1, 322, 357)];
                         }
                         completion:^(BOOL finished){
                             show = NO;
                             [openclose setTitle:@"open"];
                             [progress setCenter:textFromServer.center];
                         }];
    }
}

@end
