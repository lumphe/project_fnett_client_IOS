//
//  SettingsView.m
//  project_fnett
//
//  Created by Alexander Lumphé on 2012-04-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsView.h"
#import <MobileCoreServices/UTCoreTypes.h>

@implementation SettingsView

@synthesize ipadress, nickname, userImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [ipadress setDelegate:self];
    [nickname setDelegate:self];
    NSUserDefaults *currentDefault = [NSUserDefaults standardUserDefaults];
    if(![[currentDefault stringForKey:@"ipadress"] isEqualToString:@""]){
        [ipadress setText:[currentDefault stringForKey:@"ipadress"]];
    }
    if(![[currentDefault stringForKey:@"nickname"] isEqualToString:@""]){
        [nickname setText:[currentDefault stringForKey:@"nickname"]];
    }
    //[self startMediaBrowserFromViewController:self usingDelegate:self];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if([textField isEqual:ipadress]){
        NSUserDefaults *currentDefault = [NSUserDefaults standardUserDefaults];
        [currentDefault setObject:ipadress.text forKey:@"ipadress"];
        [textField resignFirstResponder];
    }else if([textField isEqual:nickname]){
        NSUserDefaults *currentDefault = [NSUserDefaults standardUserDefaults];
        [currentDefault setObject:nickname.text forKey:@"nickname"];
        [textField resignFirstResponder];
    }
    return NO;
}

- (BOOL) startMediaBrowserFromViewController: (UIViewController*) controller usingDelegate: (id <UIImagePickerControllerDelegate,UINavigationControllerDelegate>) delegate {
    
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO) || (delegate == nil) || (controller == nil))
        return NO;
    
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    // Displays saved pictures and movies, if both are available, from the
    // Camera Roll album.
    mediaUI.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    mediaUI.allowsEditing = YES;
    
    mediaUI.delegate = delegate;
    
    [controller presentModalViewController: mediaUI animated: YES];
    return YES;
}

- (void) imagePickerController: (UIImagePickerController *) picker didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToUse;
    
    // Handle a still image picked from a photo album
    if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeImage, 0)
        == kCFCompareEqualTo) {
        
        editedImage = (UIImage *) [info objectForKey:
                                   UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:
                                     UIImagePickerControllerOriginalImage];
        
        if (editedImage) {
            imageToUse = editedImage;
            userImage = editedImage;
        } else {
            imageToUse = originalImage;
            userImage = originalImage;
        }
        // Do something with imageToUse
    }

    NSLog(@"Picked Image");
    [picker dismissModalViewControllerAnimated: YES];
}

@end
