/**
 * SideDrawerViewController.m
 * ChoreMate
 *
 * Description:
 *
 * Created by Jasdeep Gill on 7/13/20.
 * Copyright © 2020 jazgill. All rights reserved.
 */

#import "SideDrawerViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "NotificationsViewController.h"
#import "User.h"
#import "Household.h"
#import "UIImageView+AFNetworking.h"

@interface SideDrawerViewController ()
@property (weak, nonatomic) IBOutlet UIView *notificationView;
@property (weak, nonatomic) IBOutlet UILabel *notificationNumberLabel;
@property (strong, nonatomic) NotificationsViewController *notificationController;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *facebookLogoView;

@property(nonatomic) long currentIndex;

@end

@implementation SideDrawerViewController

int const MENU_FIRST_TASK_HOME = 1;
int const MENU_SECOND_HOUSEHOLD = 2;
int const MENU_THIRD_PROFILE = 3;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    User *currUser = [User currentUser];
    NSString *profileImageURLString = currUser.profileImageView.url;
    NSURL *profileImageURL = [NSURL URLWithString:profileImageURLString];
    [self.profileImageView setImageWithURL:profileImageURL];
    self.nameLabel.text = currUser.name;
    self.usernameLabel.text = currUser.email;
    if(currUser.email != nil) {
        self.usernameLabel.text = currUser.email;
        self.facebookLogoView.alpha = 0;
    }
    else{
        self.usernameLabel.text = @"facebook login";
        self.facebookLogoView.alpha = 1;
    }

    
    self.navigationController.navigationBarHidden = YES;
    self.notificationController = [self.storyboard instantiateViewControllerWithIdentifier:@"NOTIF_VIEW_CONTROLLER"];
    [self.notificationController getNewNotifCountWithCompletionHandler:^(int count) {
        NSLog(@"the notif count is :%d", count);
        if(count > 0) {
            self.notificationView.alpha = 1;
            self.notificationNumberLabel.text = [@(count) stringValue];
        }
        else{
            self.notificationView.alpha = 0;
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.currentIndex = 0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.currentIndex == indexPath.row) {
        [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
        return;
    }

    if(indexPath.row == 4) {
        [self performSegueWithIdentifier:@"toNotifications" sender:self];
    }
    else {
        UIViewController *centerViewController;
        switch (indexPath.row) {
            case MENU_FIRST_TASK_HOME:
                centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FIRST_TASK_HOME_VIEW_CONTROLLER"];
                break;
            
            case MENU_SECOND_HOUSEHOLD:
                centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SECOND_HOUSEHOLD_VIEW_CONTROLLER"];
                break;
            
            case MENU_THIRD_PROFILE:
                centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"THIRD_PROFILE_VIEW_CONTROLLER"];
                break;
            
            default:
                break;
        }

    
        if (centerViewController) {
            self.currentIndex = indexPath.row;
            [self.mm_drawerController setCenterViewController:centerViewController withCloseAnimation:YES completion:nil];
        } else {
            [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
        }
    }
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
