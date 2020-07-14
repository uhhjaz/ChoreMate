/**
 * LoginViewController.m
 * ChoreMate
 *
 * Description: Implementation of the login view screen.
 * Allows user to login to Choremate with parse credentials, navigate to sign up view.
 * Contains checks for user error in username+password.
 *
 * Created by Jasdeep Gill on 7/13/20.
 * Copyright © 2020 jazgill. All rights reserved.
 */

#import "SceneDelegate.h"
#import <Parse/Parse.h>

// MARK: Models
#import "User.h"

// MARK: Controller
#import "LoginViewController.h"


@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)loginUser {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    [User logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            
            NSLog(@"User log in failed: %@", error.localizedDescription);
            UIAlertController *alert;
            
            // username field is empty
            if([self.usernameField.text isEqual:@""]){
                alert = [UIAlertController alertControllerWithTitle:@"Username Required"
                       message:@"Please enter a valid username"
                preferredStyle:(UIAlertControllerStyleAlert)];
            
            }
            
            // password field is empty
            else if([self.passwordField.text isEqual:@""]){
                    alert = [UIAlertController alertControllerWithTitle:@"Password Required"
                           message:@"Please enter a valid password"
                    preferredStyle:(UIAlertControllerStyleAlert)];
                
            }
            
            // other errors: incorrect username/password
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
            }];
        }
        
        else {
            NSLog(@"User logged in successfully");
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UINavigationController *taskScreenViewController = [storyboard instantiateViewControllerWithIdentifier:@"THE_ROOT_VIEW_NAVIGATOR"];
            SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
            
            [sceneDelegate changeRootViewController:taskScreenViewController :YES];
            
        }
    }];
}



#pragma mark - Navigation

- (IBAction)didTapLogin:(id)sender {
    [self loginUser];
}


- (IBAction)didTapGoToSignUp:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *signupViewController = [storyboard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    
    [sceneDelegate changeRootViewController:signupViewController :YES];
    
}


/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
