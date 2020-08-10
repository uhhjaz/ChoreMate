/**
 * ProfileViewController.m
 * ChoreMate
 *
 * Description:
 *
 * Created by Jasdeep Gill on 7/13/20.
 * Copyright © 2020 jazgill. All rights reserved.
*/

#import "ProfileViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "SceneDelegate.h"
#import "LoginViewController.h"
#import <Parse/Parse.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface ProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIButton *signOutButton;

@property (weak, nonatomic) IBOutlet UIImageView *editProfileImageView;
@property (weak, nonatomic)  UIImage *updatedProfileImage;
@property (weak, nonatomic) IBOutlet UITextField *editNameField;
@property (weak, nonatomic) IBOutlet UITextField *editEmailField;
@property (weak, nonatomic) IBOutlet UITextField *editUsernameField;
@property (weak, nonatomic) IBOutlet UIImageView *editIcon;
@property (weak, nonatomic) IBOutlet UIImageView *editIcon1;
@property (weak, nonatomic) IBOutlet UIImageView *editIcon2;
@property (weak, nonatomic) IBOutlet UIButton *saveChangesButton;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLeftMenuButton];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self setEditing:NO];
    
    [self setUpProfileData];
}

- (void) buttonToggled{
    
}

- (void) setUpProfileData {
    User *currUser = [User currentUser];
    NSString *profileImageURLString = currUser.profileImageView.url;
    NSURL *profileImageURL = [NSURL URLWithString:profileImageURLString];
    [self.profileImageView setImageWithURL:profileImageURL];
    NSLog(@"THE AUTHENTICATION OF THIS USER IS: %d",currUser.fb_authenticated);
    if (currUser.email == nil) {
        self.emailLabel.text = @"none";
        self.editEmailField.placeholder = @"Enter an email";
    } else {
        self.emailLabel.text = currUser.email;
        self.editEmailField.placeholder = currUser.email;
    }
    
    if (currUser.username == nil) {
        self.usernameLabel.text = @"none";
        self.editUsernameField.placeholder = @"Enter a username";
    } else {
        self.usernameLabel.text = currUser.username;
        self.editUsernameField.placeholder = currUser.username;
    }
    self.nameLabel.text = currUser.name;
    self.editNameField.placeholder = currUser.name;
}


-(void)setEditing:(BOOL)editing animated:(BOOL)animated {

    [super setEditing:editing animated:animated];
    User *currUser = [User currentUser];
    if(editing) {
        self.editProfileImageView.alpha = 1;
        self.editNameField.alpha = 1;
        self.editEmailField.alpha = 1;
        self.editUsernameField.alpha = 1;
        self.editIcon.alpha = 1;
        self.editIcon1.alpha = 1;
        self.editIcon2.alpha = 1;
        self.emailLabel.alpha = 0;
        self.nameLabel.alpha = 0;
        self.usernameLabel.alpha = 0;
        self.signOutButton.alpha = 0;
    }

    else {
        if(![self.editEmailField.text isEqual: @""]){
            currUser.email = self.editEmailField.text;
            self.emailLabel.text = self.editEmailField.text;
        }
        if(![self.editNameField.text isEqual: @""]){
            currUser.name = self.editNameField.text;
            self.nameLabel.text = self.editNameField.text;
        }
        if(![self.editUsernameField.text isEqual: @""]){
            currUser.username = self.editUsernameField.text;
            self.usernameLabel.text = self.editUsernameField.text;
        }
        [currUser saveInBackground];
        self.editProfileImageView.alpha = 0;
        self.editNameField.alpha = 0;
        self.editEmailField.alpha = 0;
        self.editUsernameField.alpha = 0;
        self.editIcon.alpha = 0;
        self.editIcon1.alpha = 0;
        self.editIcon2.alpha = 0;
        self.profileImageView.alpha = 1;
        self.emailLabel.alpha = 1;
        self.nameLabel.alpha = 1;
        self.usernameLabel.alpha = 1;
        self.signOutButton.alpha = 1;
    }

}


- (IBAction)didTapChangePicture:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
        imagePickerVC.delegate = self;
        imagePickerVC.allowsEditing = YES;
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
        [self presentViewController:imagePickerVC animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {

    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *resizedImage = [self resizeImage:originalImage withSize:CGSizeMake(200, 100)];
    
    self.profileImageView.image = resizedImage;
    self.updatedProfileImage = resizedImage;
    
    // Dismiss UIImagePickerController to go back original view controller
    [self dismissViewControllerAnimated:YES completion:^{
        [User updateUserProfileImage:self.updatedProfileImage withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded){
                NSLog(@"updating profile image successful");
                
            } else{
                NSLog(@"Error posting image: %@", error.localizedDescription);
            }
        }];
    }];
     
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


- (void)setupLeftMenuButton {
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton];
}

- (void)leftDrawerButtonPress:(id)leftDrawerButtonPress {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (IBAction)didTapSignOut:(id)sender {
    if ([FBSDKAccessToken currentAccessToken]) {
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logOut];
    }

    
    NSLog(@"user clicked logout");
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    sceneDelegate.window.rootViewController = loginViewController;
    [User logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        NSLog(@"User logged out successfully");
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
