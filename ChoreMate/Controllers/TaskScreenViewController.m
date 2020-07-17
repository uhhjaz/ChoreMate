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
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"


// MARK: Models
#import "Task.h"
#import "User.h"

// MARK: Views

// MARK: Controllers
#import "TaskScreenViewController.h"
#import "LoginViewController.h"
#import "TaskChoicePopUpViewController.h"
#import "OnceTimeTaskViewController.h"
#import "RecurringTaskViewController.h"
#import "RotationalTaskViewController.h"



@interface TaskScreenViewController () <TaskChoiceControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *addTaskButton;

@end

@implementation TaskScreenViewController

int const TASK_TYPE_ONETIME = 0;
int const TASK_TYPE_RECURRING = 1;
int const TASK_TYPE_ROTATIONAL = 2;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLeftMenuButton];
}


- (void)setupLeftMenuButton {
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton];
}


- (void)leftDrawerButtonPress:(id)leftDrawerButtonPress {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}



- (IBAction)didTapAddTask:(id)sender {
    NSLog(@"Trying to click popup");
    TaskChoicePopUpViewController *popViewController = [TaskChoicePopUpViewController new];
    
    popViewController.delegate = self;
    HWPopController *popController = [[HWPopController alloc] initWithViewController:popViewController];
    // popView position
    popController.popPosition = HWPopPositionBottom;
    popController.popType = HWPopTypeBounceInFromBottom;
    popController.dismissType = HWDismissTypeSlideOutToBottom;
    popController.shouldDismissOnBackgroundTouch = YES;
    [popController presentInViewController:self];
    
}

- (void)didChoose:(int)type{
    
    NSLog(@"inside did choose, the type is: %d", type);
//    if ([type isEqual: @"one time"]) {
//
//        OnceTimeTaskViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ONE_TIME_TASK"];
//        [self.navigationController pushViewController:controller animated:YES];
//    }
//
//    else if ([type isEqual: @"recurring"]) {
//        RecurringTaskViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"RECURRING_TASK"];
//        [self.navigationController pushViewController:controller animated:YES];
//    }
//
//    else if ([type isEqual: @"rotational"]) {
//        RotationalTaskViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ROTATIONAL_TASK"];
//        [self.navigationController pushViewController:controller animated:YES];
//    }
    OnceTimeTaskViewController* controller;
    switch (type) {
        case TASK_TYPE_ONETIME:
            controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ONE_TIME_TASK"];
            break;
            
        case TASK_TYPE_RECURRING:
            controller = [self.storyboard instantiateViewControllerWithIdentifier:@"RECURRING_TASK"];
            break;
            
        case TASK_TYPE_ROTATIONAL:
            controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ROTATIONAL_TASK"];
            break;
            
        default:
            break;
    }
    [self.navigationController pushViewController:controller animated:YES];
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
