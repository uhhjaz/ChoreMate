/**
 * SignUpViewController.m
 * ChoreMate
 *
 * Description: Implementation of the signup view screen.
 * Allows user to sign up to Choremate with parse credentials, navigate to login view.
 * Contains checks for user error in username+password.
 *
 * Created by Jasdeep Gill on 7/13/20.
 * Copyright © 2020 jazgill. All rights reserved.
 */

#import "SceneDelegate.h"
#import <Parse/Parse.h>

// MARK: Models
#import "User.h"

// MARK: Controllers
#import "SignUpViewController.h"


@interface SignUpViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet PFImageView *imageView;

@end

@implementation SignUpViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)registerUser {
    
    // initialize a user object
    User *newUser = [User user];
    
    // set user fields
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    newUser.name = self.nameField.text;
    newUser.email = self.emailField.text;
    
    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
            UIAlertController *alert;
            NSLog(@"Error: %@", error.localizedDescription);
            
            if([self.usernameField.text isEqual:@""]){
                alert = [UIAlertController alertControllerWithTitle:@"Username Required"
                                                            message:@"Please enter a valid username"
                                                     preferredStyle:(UIAlertControllerStyleAlert)];
            
            }
            else if([self.passwordField.text isEqual:@""]){
                alert = [UIAlertController alertControllerWithTitle:@"Password Required"
                                                            message:@"Please enter a password"
                                                     preferredStyle:(UIAlertControllerStyleAlert)];
                
            }
            else{
                alert = [UIAlertController alertControllerWithTitle:error.localizedDescription
                                                            message:error.localizedFailureReason
                                                     preferredStyle:(UIAlertControllerStyleAlert)];
            }
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                                   style:UIAlertActionStyleCancel
                                                                 handler:^(UIAlertAction * _Nonnull action) {}];
            
            // add the cancel action to the alertController
            [alert addAction:cancelAction];

            // create an OK action
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {}];
            
            // add the OK action to the alert controller
            [alert addAction:okAction];
            
            [self presentViewController:alert animated:YES completion:^{}];
            
        } else {
            NSLog(@"User registered successfully");
            
            if (self.imageView.image == nil){
                self.imageView.image = [UIImage imageNamed: @"profile_image_default.png"];
            }
            
            [User updateUserProfileImage:self.imageView.image withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            }];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UINavigationController *taskScreenViewController = [storyboard instantiateViewControllerWithIdentifier:@"THE_ROOT_VIEW_NAVIGATOR"];
            SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
            
            [sceneDelegate changeRootViewController:taskScreenViewController :YES];

        }
    }];
}


- (IBAction)didTapProfilePicture:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }

    [self presentViewController:imagePickerVC animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    self.imageView.image = [self resizeImage:originalImage withSize:CGSizeMake(300, 300)];
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


#pragma mark - Navigation

- (IBAction)didTapSignUp:(id)sender {
    [self registerUser];
}


- (IBAction)didTapGoToLogin:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    
    [sceneDelegate changeRootViewController:loginViewController :YES];
}


/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
