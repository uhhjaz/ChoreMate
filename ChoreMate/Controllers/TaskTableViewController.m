//
//  TaskTableViewController.m
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/17/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import "TaskTableViewController.h"
#import "User.h"
#import "Task.h"
#import <Parse/Parse.h>
#import "TaskCell.h"


@interface TaskTableViewController ()


@property (strong, nonatomic) NSArray *household;
@property (strong, nonatomic) NSArray *myTasks;
@end

@implementation TaskTableViewController

- (void)viewWillAppear:(BOOL)animated{
    //[self.tableView reloadData];
    if (self.currUser.household_id != nil) {
        [self getMyTasks];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorColor = [UIColor clearColor];
    
    self.currUser = [User currentUser];
    NSLog(@"the current user is: %@", self.currUser);
    
    if (self.currUser.household_id != nil) {
        [self getHousehold];
        [self getMyTasks];
    }
    else{
        // do something incase user doesnt have household and tasks
    }
}


-(void)getMyTasks{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Task"];
    [query whereKey:@"assignedTo" equalTo:self.currUser];
    
    [query orderByAscending:@"dueDate"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *userTasks, NSError *error) {
        if (userTasks != nil) {
            NSLog(@"Successfully got household members");
            
            self.myTasks = userTasks;
            NSLog(@" my tasks are %@",self.myTasks);
            [self.tableView reloadData];
            
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}


- (void) getHousehold{

    User *curr = [User currentUser];

    PFQuery *query = [PFUser query];
    
    NSLog(@"the USERS HOUSEHOLD ID IS : %@", curr.household_id);
    
    if(curr.household_id != nil){
        // query for household members of the user
        [query whereKey:@"household_id" equalTo:curr.household_id];
        [query findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
            if (users != nil) {
                NSLog(@"Successfully got household members");
            
                self.household = users;
                [self.tableView reloadData];
            
            } else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
    }
    
}



#pragma mark - Table view data source

// shows how many rows we have
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.myTasks.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskCell" forIndexPath:indexPath];
    
    // creates cell from photo
    TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskCell"];
    cell.task = self.myTasks[indexPath.row];
    [cell setTaskValues];
    return cell;
}




/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
