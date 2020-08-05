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

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIButton *signOutButton;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLeftMenuButton];
    
    [self setUpProfileData];
}


- (void) setUpProfileData {
    User *currUser = [User currentUser];
    NSString *profileImageURLString = currUser.profileImageView.url;
    NSURL *profileImageURL = [NSURL URLWithString:profileImageURLString];
    [self.profileImageView setImageWithURL:profileImageURL];
    NSLog(@"THE AUTHENTICATION OF THIS USER IS: %d",currUser.fb_authenticated);
    if (currUser.fb_authenticated == YES) {
        self.emailLabel.text = @"none";
        self.usernameLabel.text = @"none";
    } else {
        self.emailLabel.text = currUser.email;
        self.usernameLabel.text = currUser.username;
    }
    self.nameLabel.text = currUser.name;
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
