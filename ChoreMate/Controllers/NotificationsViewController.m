//
//  NotificationsViewController.m
//  ChoreMate
//
//  Created by Jasdeep Gill on 8/3/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import "NotificationsViewController.h"
#import "NotificationCell.h"
#import <MBProgressHUD.h>

@interface NotificationsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *myNotifs;

@end

@implementation NotificationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self getMyNotifications];
}

- (void) getMyNotifications {
    PFQuery *query = [PFQuery queryWithClassName:@"Notification"];
    [query whereKey:@"toHousemate" equalTo:[User currentUser]];
    query.limit = 20;
    [query orderByDescending:@"createdAt"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [query findObjectsInBackgroundWithBlock:^(NSArray *usersNotifs, NSError *error) {
        if (usersNotifs != nil) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"Successfully got household members");
            
            self.myNotifs = usersNotifs;
            self.unseenNotifs = @(self.myNotifs.count);
            NSLog(@"my notifications are: %@", self.myNotifs);
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void) getNewNotifCountWithCompletionHandler:(void (^)(int count))completionHandler{
    PFQuery *query = [PFQuery queryWithClassName:@"Notification"];
    [query whereKey:@"toHousemate" equalTo:[User currentUser]];
    [query whereKey:@"seen" equalTo:@NO];
    
    [query orderByAscending:@"createdDate"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *usersNotifs, NSError *error) {
        if (usersNotifs != nil) {
            NSLog(@"Successfully got household members");

            NSLog(@"my notification count is: %d", (int)usersNotifs.count);
            completionHandler((int)usersNotifs.count);
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.myNotifs.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationCell"];
    cell.notification = self.myNotifs[indexPath.row];
    NSLog(@"cell.notification is: %@", cell.notification);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [cell setNotificationData];
    cell.notification.seen = @YES;
    [cell.notification saveInBackground];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    return cell;
}

- (IBAction)didTapBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
