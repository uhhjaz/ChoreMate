//
//  AllTasksViewController.m
//  ChoreMate
//
//  Created by Jasdeep Gill on 8/9/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import "AllTasksViewController.h"

// MARK: Models
#import "Task.h"
#import "User.h"

// MARK: Views
#import "TaskCell.h"
#import "DayLabelCell.h"

// MARK: Controllers
#import "TaskScreenViewController.h"
#import "LoginViewController.h"
#import "TaskChoicePopUpViewController.h"
#import "OneTimeTaskViewController.h"
#import "RecurringTaskViewController.h"
#import "RotationalTaskViewController.h"
#import "HouseMateTaskCell.h"
#import "WeeklyCalendarViewController.h"

@interface AllTasksViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) User *currUser;
@property (weak, nonatomic) IBOutlet UILabel *welcomeMessageLabel;
@property (weak, nonatomic) IBOutlet UIView *welcomeMessageBgView;

@end

@implementation AllTasksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.currUser = [User currentUser];
    NSArray* firstLastStrings = [self.currUser.name componentsSeparatedByString:@" "];
    self.welcomeMessageLabel.text = [NSString stringWithFormat:@"Hey %@!",[firstLastStrings objectAtIndex:0]];

    self.tableView.separatorColor = [UIColor clearColor];
    
    // Do any additional setup after loading the view.
}

-(void)refreshTable {
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.myTasksWithDates.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     if([self.myTasksWithDates[indexPath.row] isKindOfClass:[NSString class]]){
         DayLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DayLabelCell"];
         cell.dateString = self.myTasksWithDates[indexPath.row];
         [cell setDate];
         return cell;
     } else {
         TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskCell"];
         cell.task = self.myTasksWithDates[indexPath.row];
         [cell setTaskValues];
         [cell getTasksAssignees];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         return cell;
     }
     return nil;

}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(![self.myTasksWithDates[indexPath.row] isKindOfClass:[NSString class]]){
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            [self.myTasksWithDates[indexPath.row] deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if(succeeded){
                    NSLog(@"Task was successfully removed from the database");
                }
                if(error){
                    NSLog(@"There was an error deleting the task %@", error.localizedDescription);
                }
            }];

            if([self.myTasksWithDates[indexPath.row-1] isKindOfClass:[NSString class]] && [self.myTasksWithDates[indexPath.row+1] isKindOfClass:[NSString class]]){
                [self.myTasksWithDates removeObjectAtIndex:indexPath.row];
                [self.myTasksWithDates removeObjectAtIndex:indexPath.row-1];
            } else{
                [self.myTasksWithDates removeObjectAtIndex:indexPath.row];
            }
            [tableView reloadData];
        }
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if(![self.myTasksWithDates[indexPath.row] isKindOfClass:[NSString class]]){
        NSMutableArray *allCells = (NSMutableArray *)[self.tableView visibleCells];
        NSPredicate *testForCompletion = [NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            __block BOOL isCompleted = NO;
            if([evaluatedObject isKindOfClass:[TaskCell class]]){
                NSLog(@"here");
                TaskCell * cell = (TaskCell *)evaluatedObject;
                Task * task = cell.task;
                NSLog(@"the completed is %d:",task.completedObject.isCompleted);
                isCompleted = task.completedObject.isCompleted;
                NSLog(@"isCompleted is %d",isCompleted);
                return isCompleted;
            }
            NSLog(@"isCompleted is %d",isCompleted);
            return isCompleted;
        }];

        NSArray *filteredArray = [allCells filteredArrayUsingPredicate:testForCompletion];
        NSLog(@"###################filteredArray is: %@", filteredArray);

        if (filteredArray != nil) {

            [filteredArray enumerateObjectsUsingBlock:^(UITableViewCell *cell, NSUInteger idx, BOOL *stop) {
                [cell setFrame:CGRectMake(0, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height)];
                [UIView animateWithDuration:1.5 animations:^{
                    [cell setFrame:CGRectMake(self.view.bounds.size.width, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height)];
                }];

                [UIView animateWithDuration:1 animations:^{
                    
                    //[self.myTasksWithDates removeObjectAtIndex:indexPath.row];
                    if([self.myTasksWithDates[indexPath.row-1] isKindOfClass:[NSString class]] && (indexPath.row+1 >= self.myTasksWithDates.count || [self.myTasksWithDates[indexPath.row+1] isKindOfClass:[NSString class]])){
                        [self.myTasksWithDates removeObjectAtIndex:indexPath.row];
                        [self.myTasksWithDates removeObjectAtIndex:indexPath.row-1];
                    } else{
                        [self.myTasksWithDates removeObjectAtIndex:indexPath.row];
                    }
                }];
            }];

            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
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
