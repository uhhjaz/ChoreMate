/**
 * TaskScreenViewController.h
 * ChoreMate
 *
 * Description: Implementation of the task screen view
 * Allows user to see user tasks, mark tasks as complete, see household tasks, nudge housemates.
 * Allows user to navigate to view to create new tasks.
 *
 * Created by Jasdeep Gill on 7/13/20.
 * Copyright © 2020 jazgill. All rights reserved.
 */

#import "SceneDelegate.h"
#import <Parse/Parse.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <HWPopController/HWPop.h>

// MARK: Models
#import "Task.h"
#import "User.h"

// MARK: Views


// MARK: Controllers
#import "TaskScreenViewController.h"
#import "LoginViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "TaskPopUpViewController.h"


@interface TaskScreenViewController ()
@property (weak, nonatomic) IBOutlet UIButton *addTaskButton;

@end

@implementation TaskScreenViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLeftMenuButton];
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 56)];
    self.addTaskButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addTaskButton.frame = CGRectMake(30, 0, CGRectGetWidth(footer.bounds) - 60, 56);
    [self.addTaskButton setTitle:@"Pop up" forState:UIControlStateNormal];
    self.addTaskButton.titleLabel.font = [UIFont boldSystemFontOfSize:30];
    [self.addTaskButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.addTaskButton.backgroundColor = [UIColor colorWithRed:0.000 green:0.590 blue:1.000 alpha:1.00];
    self.addTaskButton.layer.masksToBounds = YES;
    self.addTaskButton.layer.cornerRadius = 6.f;
}

- (IBAction)didTapAddTask:(id)sender {
    NSLog(@"Trying to click popup");
    TaskPopUpViewController *popViewController = [TaskPopUpViewController new];
    HWPopController *popController = [[HWPopController alloc] initWithViewController:popViewController];
    // popView position
    popController.popPosition = HWPopPositionBottom;
    popController.popType = HWPopTypeBounceInFromBottom;
    popController.dismissType = HWDismissTypeSlideOutToBottom;
    popController.shouldDismissOnBackgroundTouch = YES;
    [popController presentInViewController:self];
}



- (void)setupLeftMenuButton {
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton];
}


- (void)leftDrawerButtonPress:(id)leftDrawerButtonPress {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}


#pragma mark - Navigation

- (IBAction)didTapLogout:(id)sender {
    
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
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
