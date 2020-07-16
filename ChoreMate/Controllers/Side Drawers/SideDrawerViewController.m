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

@interface SideDrawerViewController ()


@property(nonatomic) long currentIndex;

@end

@implementation SideDrawerViewController

int const MENU_FIRST_TASK_HOME = 1;
int const MENU_SECOND_HOUSEHOLD = 2;
int const MENU_THIRD_PROFILE = 3;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentIndex = 0;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.currentIndex == indexPath.row) {
        [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
        return;
    }

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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
