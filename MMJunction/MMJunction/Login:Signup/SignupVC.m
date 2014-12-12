//
//  SignupVC.m
//  MMJunction
//
//  Created by Zune Moe on 2/26/14.
//  Copyright (c) 2014 Wiz. All rights reserved.
//
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

#import "SignupVC.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "AppDelegate.h"
#import "User.h"

@interface SignupVC () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *closeImage;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIView *signupViewContainer;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIView *activityViewContainer;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;

@end

@implementation SignupVC
{
    BOOL photoTaken;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    photoTaken = NO;
    
    self.name.delegate = self;
    self.email.delegate = self;
    self.password.delegate = self;
    
    self.closeImage.layer.masksToBounds = YES;
    self.closeImage.layer.cornerRadius = 10;
    self.closeImage.layer.borderWidth = 0.5;
    self.closeImage.layer.borderColor = [UIColor blackColor].CGColor;
    [self.closeImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissVC)]];
    
    self.profileImage.layer.masksToBounds = YES;
    self.profileImage.layer.cornerRadius = 60;
    self.profileImage.layer.borderWidth = 4;
    self.profileImage.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.profileImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePickerTapped)]];
    
    self.signupViewContainer.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"noise_lines"]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Signup View Controller"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)activityViewHidden:(BOOL)hidden
{
    self.activityViewContainer.hidden = hidden;
    if (hidden) {
        [self.activityView stopAnimating];
    } else {
        [self.activityView startAnimating];
    }
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}


- (IBAction)signupTapped:(id)sender {
    [self activityViewHidden:NO];
    
    if (_name.text.length > 0 && _email.text.length > 0 && _password.text.length > 0) {
        if (![self NSStringIsValidEmail:_email.text]) {
            [self activityViewHidden:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Email seems to be invalid." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            return;
        }
    }
    else
    {
        [self activityViewHidden:YES];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"All fields are required." message:@"You need to fill all fields to sign up." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (photoTaken) {
        [User userSignupUploadPhoto:self.profileImage.image block:^(NSString *photoname, NSError *error) {
            [self signupNow:photoname];
        }];
//        [self uploadImage:^(NSString *photoname, NSError *error) {
//            [self signupNow:photoname];
//        }];
    } else {
        [self signupNow:nil];
    }
}

- (void)signupNow:(NSString *)image
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{@"Email": self.email.text,
                                                                                      @"Password": self.password.text,
                                                                                      @"Name": self.name.text,
                                                                                      @"FirstName": self.name.text,
                                                                                      @"LastName": @"."}];
    if (image) {
        parameters[@"Photo"] = image;
    }
    
    [User userSignup:parameters block:^(NSDictionary *user, NSError *error)
    {
        NSLog(@"USER DICT : %@",user);
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@", error.localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        if ([[user objectForKey:@"status"] intValue] == 1) {
            [[NSUserDefaults standardUserDefaults] setObject:user forKey:@"userInfo"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] setupTabBarController];
        }
        else if ([[user objectForKey:@"status"] intValue] == 2)
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:user[@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        [self activityViewHidden:YES];
//        [(AppDelegate *)[[UIApplication sharedApplication] delegate] setupTabBarController];
    }];
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:MMJunctionBaseURL]];
//    [client postPath:@"user" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
//        NSLog(@"dict: %@", dict);
//        if ([[dict objectForKey:@"status"] intValue] == 1) {
//            [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"userInfo"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//        }
//        [self activityViewHidden:YES];
//        [(AppDelegate *)[[UIApplication sharedApplication] delegate] setupTabBarController];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@", error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//        [self activityViewHidden:YES];
//    }];
}

- (void)dismissVC
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerTapped
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void) uploadImage:(void(^)(NSString *photoname, NSError *error))callback
{
    NSData *imageToUpload = UIImageJPEGRepresentation(self.profileImage.image, 1.0);//(uploadedImgView.image);
    if (imageToUpload)
    {
        //NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:keyParameter, @"keyName", nil];
        
        AFHTTPClient *client= [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:MMJunctionBaseURL]];
        
        NSMutableURLRequest *request = [client multipartFormRequestWithMethod:@"POST" path:@"user/upload" parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
            [formData appendPartWithFileData: imageToUpload name:@"Picture" fileName:@"iOSUpload.jpeg" mimeType:@"image/jpeg"];
        }];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
             NSArray *separatedImageURL = [json[@"photoname"] componentsSeparatedByString:@"/"];
             if (callback) {
                 callback(separatedImageURL.lastObject, nil);
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             if (callback) {
                 callback([NSString string], error);
             }
         }];
        [operation start];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    photoTaken = YES;
    self.profileImage.contentMode = UIViewContentModeScaleAspectFit;
    self.profileImage.image = image;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
