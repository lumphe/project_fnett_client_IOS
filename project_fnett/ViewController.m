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
#import "mainViewcontroller.h"

@implementation ViewController

@synthesize send, iStream, oStream, stream, textFromServer, message, progress;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIBarButtonItem *private = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(showPickerView)];
    UIBarButtonItem *PM = [[UIBarButtonItem alloc] initWithTitle:@"PM" style:UIBarButtonItemStyleBordered target:self action:@selector(PM)];
    NSArray *buttonArray = [NSArray arrayWithObjects:private, PM, nil];
    self.navigationItem.rightBarButtonItems = buttonArray;
    state = 0;
    /*commandsArray = [[NSMutableArray alloc] init];
    [commandsArray addObject:@"SET_USERNAME"];
    [commandsArray addObject:@"GET_STATE"];
    [commandsArray addObject:@"DISABLE_CONNECTION"];
    [commandsArray addObject:@"DISCONNECT_CONFIRMED"];
    [commandsArray addObject:@""];*/
    messageView.layer.borderWidth = 1.0f;
    messageView.layer.borderColor = [[UIColor blackColor] CGColor];
    [textFromServer setDelegate:self];
    [textFromServer setContentSize:CGSizeMake(320, 40)];
    [message setDelegate:self];
    [self.view bringSubviewToFront:message];
    [self.view bringSubviewToFront:send];
    /*commands = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 416, 320, 200)];
    commands.showsSelectionIndicator = YES;
    [commands setDelegate:self];
    [self.view addSubview:commands];*/
    [progress setCenter:textFromServer.center];
    labelY = 20;
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
    //[self disconnenct];
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
    if([oStream hasSpaceAvailable]){
        [self sendMsgWithString:message.text];
        NSUserDefaults *currentDefault = [NSUserDefaults standardUserDefaults];
        [self userAppendTextView:[NSString stringWithFormat:@"%@: %@\n",[currentDefault stringForKey:@"nickname"], message.text]];
        [message setText:@""];
    }
}

-(void)connect:(mainViewcontroller *)viewcontroller{
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
    main = viewcontroller;
}

-(void)disconnenct{
    [iStream close];
    [oStream close];
    [iStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [oStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    iStream = nil;
    oStream = nil;
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
        [self showPickerView];
    }
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
                            //[self appendTextView:input];
                            NSString *comper = [input stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                            if([comper isEqualToString:@"CONNECTION_ESTABLISHED"]){
                                state = 2;
                                if([oStream hasSpaceAvailable]){
                                    [self sendMsgWithString:@"SET_USERNAME"];
                                    state = 1337;
                                }
                            }else if([comper isEqualToString:@"SEND_USERNAME"]){
                                NSUserDefaults *currentDefault = [NSUserDefaults standardUserDefaults];
                                if(![[currentDefault stringForKey:@"nickname"] isEqualToString:@""]){
                                    [self sendMsgWithString:[currentDefault stringForKey:@"nickname"]];
                                }else{
                                    [self sendMsgWithString:[currentDefault stringForKey:@"anonymous"]];
                                }
                            }else if([comper isEqualToString:@"SENDING_CONNECTED_CLIENTS"]){
                                Connected = YES;
                            }else if(Connected){
                                connections = [input componentsSeparatedByString:@"\n"];
                                for(int i = 0;i<connections.count-1;i++){
                                    [self appendTextView:[connections objectAtIndex:i]];
                                }
                                [connectionsList reloadData];
                                Connected = NO;
                            }else if(!PC){
                                [self appendTextView:input];
                            }else{
                                [conv appendTextView:input];
                            }
						}
					}
				}
			}
			break;
            
			
		case NSStreamEventErrorOccurred:
			[progress stopAnimating];
            state = 0;
			NSLog(@"Can not connect to the host!");
			break;
            
        case NSStreamEventHasSpaceAvailable:
            NSLog(@"Has Space");
            if(state == 0){
                [self sendMsgWithString:@"ESTABLISH_CONNECTION"];
                state = 1337;
            }else if(state == 2){
                [self sendMsgWithString:@"SET_USERNAME"];
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

- (void)showPickerView{
    /*if([message isFirstResponder] && !show){
        [message resignFirstResponder];
    }
    if(!show){
        [UIView animateWithDuration:0.2
                         animations:^{
                             commands.frame = CGRectOffset(commands.frame, 0, -180); 
                             messageView.frame = CGRectOffset(messageView.frame, 0, -180);
                             [textFromServer setFrame:CGRectMake(0, 0, 320, 196)];
                             CGPoint bottomOffset = CGPointMake(0, textFromServer.contentSize.height - self.textFromServer.bounds.size.height);
                             [textFromServer setContentOffset:bottomOffset animated:YES];
                         }
                         completion:^(BOOL finished){
                             show = YES;
                             [progress setCenter:textFromServer.center];
                         }];
    }else if(show){
        [UIView animateWithDuration:0.2
                         animations:^{
                             commands.frame = CGRectOffset(commands.frame, 0, 180); 
                             messageView.frame = CGRectOffset(messageView.frame, 0, 180);
                             [textFromServer setFrame:CGRectMake(0, 0, 320, 376)];
                         }
                         completion:^(BOOL finished){
                             show = NO;
                             [progress setCenter:textFromServer.center];
                         }];
    }*/
    [self performSegueWithIdentifier:@"private" sender:nil];
}

-(void)PM{
    if(PMView != nil){
        [PMView removeFromSuperview];
        PMView = nil;
    }else{
        [self sendMsgWithString:@"GET_CONNECTED_CLIENTS"];
        [self PMView];
    }
}

-(void)PMView{
    PMView = [[UIView alloc] initWithFrame:CGRectMake(20, 5, 260, 300)];
    [PMView setBackgroundColor:[UIColor whiteColor]];
    PMView.layer.borderWidth = 3.0f;
    PMView.layer.borderColor = [[UIColor blackColor] CGColor];
    PMView.layer.cornerRadius = 15.0f;
    
    connectionsList = [[UITableView alloc] initWithFrame:CGRectMake(0, 5, 260, 290)];
    [connectionsList setDelegate:self];
    [connectionsList setDataSource:self];
    
    [self.view addSubview:PMView];
    [PMView addSubview:connectionsList];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return connections.count-1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *MyIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.clipsToBounds = true;
    [cell.textLabel setText:[connections objectAtIndex:indexPath.row]];
    [cell.textLabel setTextColor:[UIColor blackColor]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@", [connections objectAtIndex:indexPath.row]);
    [self performSelector:@selector(PM) withObject:nil afterDelay:0.5f];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"private"]){
        conv = [segue destinationViewController];
        conv.client = self;
        [self sendMsgWithString:@"PRIVATE_CONVERSATION"];
        PC = YES;
    }
}

@end
