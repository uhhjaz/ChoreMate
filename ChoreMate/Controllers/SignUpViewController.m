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


@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

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
                           message:@"Please enter a valid password"
                    preferredStyle:(UIAlertControllerStyleAlert)];
                
            }
            else{
                alert = [UIAlertController alertControllerWithTitle:error.localizedDescription
                                                            message:error.localizedFailureReason
                preferredStyle:(UIAlertControllerStyleAlert)];
            }
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                                style:UIAlertActionStyleCancel
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                     // handle cancel response here. Doing nothing will dismiss the view.
                                                              }];
            // add the cancel action to the alertController
            [alert addAction:cancelAction];

            // create an OK action
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                     // handle response here.
                                                             }];
            // add the OK action to the alert controller
            [alert addAction:okAction];
            
            [self presentViewController:alert animated:YES completion:^{
                // optional code for what happens after the alert controller has finished presenting
            }];
            
        } else {
            NSLog(@"User registered successfully");
            
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UINavigationController *taskScreenViewController = [storyboard instantiateViewControllerWithIdentifier:@"THE_ROOT_VIEW_NAVIGATOR"];
            SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
            
            [sceneDelegate changeRootViewController:taskScreenViewController :YES];

        }
    }];
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
