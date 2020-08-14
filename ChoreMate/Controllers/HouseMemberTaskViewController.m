//
//  HouseMemberTaskViewController.m
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/31/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import "HouseMemberTaskViewController.h"
#import "HouseMateTaskCell.h"
#import <Parse/Parse.h>
#import "NSDate+CMDate.h"
#import "Task.h"
#import "Completed.h"
#import "popUpNudgeHouseMateViewController.h"
#import <HWPopController/HWPop.h>
#import <MBProgressHUD.h>
#import "Notification.h"

@interface HouseMemberTaskViewController () <UITableViewDelegate, UITableViewDataSource, HouseMateTaskCellDelegate, popUpNudgeControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *headerBackground;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) NSArray *allTasks;
@property (strong, nonatomic) NSMutableArray *housematesTasks;

@end

@implementation HouseMemberTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor clearColor];
    [self setHeader];
    
    [self getAllTasks];

}


- (void) setHeader {
    NSArray* firstLastStrings = [self.houseMate.name componentsSeparatedByString:@" "];
    NSString *firstName = [NSString stringWithFormat:@"%@",[firstLastStrings objectAtIndex:0]];
    
    self.headerLabel.text = [firstName stringByAppendingString:@"'s Uncompleted Chores"];
}


- (void) getAllTasks{
    PFQuery *query = [PFQuery queryWithClassName:@"Task"];
    [query whereKey:@"assignedTo" containsString:self.houseMate.objectId];
    PFQuery *query2 = [PFQuery queryWithClassName:@"Completed"];
    [query2 whereKey:@"isCompleted" equalTo:@NO];
    [query whereKey:@"completed" matchesQuery:query2];
    
    [query orderByAscending:@"dueDate"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *userTasks, NSError *error) {
        if (userTasks != nil) {
            NSLog(@"Successfully got household members");
            
            self.allTasks = userTasks;
            [self beginCreatingTasks];
            
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}


- (void) beginCreatingTasks{
    
    self.housematesTasks = [[NSMutableArray alloc] init];
    for(Task *taskFromDB in self.allTasks){
        
        if([taskFromDB.type isEqual:@"one_time"]){
            [Completed createCompletedFromTask:taskFromDB AndDate:taskFromDB.endDate completionHandler:^(Completed * _Nonnull completedObject) {
                taskFromDB.completedObject = completedObject;
                taskFromDB.taskDatabaseId = taskFromDB.objectId;
                if(taskFromDB.completedObject.isCompleted != YES){
                    if(![taskFromDB.completedObject.currentCompletionStatus containsObject:self.houseMate.objectId]){
                        [self.housematesTasks addObject:taskFromDB];
                        NSLog(@"self.housematesTasks are %@:",self.housematesTasks);
                        [self sortBasedOnCompletionDate];
                        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
                    }
                }
            }];
        
        } else if([taskFromDB.type isEqual:@"recurring"]){
            [self makeRecurringRotationalTasks:taskFromDB completionHandler:^(NSArray *createdRecurringRotationalTasks) {
                [self.housematesTasks addObjectsFromArray:createdRecurringRotationalTasks];
                NSLog(@"self.housematesTasks are %@:",self.housematesTasks);
                [self sortBasedOnCompletionDate];
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            }];
        
        } else if([taskFromDB.type isEqual:@"rotational"]){
            [self makeRecurringRotationalTasks:taskFromDB completionHandler:^(NSArray *createdRecurringRotationalTasks) {
                [self.housematesTasks addObjectsFromArray:createdRecurringRotationalTasks];
                NSLog(@"self.housematesTasks are %@:",self.housematesTasks);
                [self sortBasedOnCompletionDate];
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            }];
        
        } else {
            NSLog(@"task is configured incorrectly-- it needs a valid type!");
        }
    }
}

- (void) sortBasedOnCompletionDate {
    NSLog(@"sorting tasks");
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"completedObject.endDate" ascending:YES];
    [self.housematesTasks sortUsingDescriptors:[NSArray arrayWithObject:sorter]];
}

- (void) addCompletedToOneTimeTask:(Task *)taskFromDB WithCompletionHandler:(void (^)(BOOL success))completionHandler{
    dispatch_group_t group2 = dispatch_group_create();
    dispatch_group_enter(group2);
    [Completed createCompletedFromTask:taskFromDB AndDate:taskFromDB.endDate completionHandler:^(Completed * _Nonnull completedObject) {
        taskFromDB.completedObject = completedObject;
        dispatch_group_leave(group2);
        completionHandler(YES);
    }];
}



- (void) makeRecurringRotationalTasks: (Task *)taskFromDB completionHandler:(void (^)(NSArray *createdRecurringRotationalTasks))completionHandler{
    __block NSArray *allNewTasksForThisTask = [[NSArray alloc] init];
    
    NSArray *userIds = [taskFromDB objectForKey:@"assignedTo"];
    
    __block NSArray *assignees;
    [self getArrayOfTaskAssignees:userIds completionHandler:^(NSArray * _Nonnull allAssignees) {
        assignees = allAssignees;
        [self createTasksForEachDate:taskFromDB :assignees WithCompletionHandler:^(NSArray *createdTasks) {
            if(createdTasks != nil) {
                NSLog(@"createdTasks in makeRecurringTasks contains: %@", createdTasks);
                allNewTasksForThisTask = createdTasks;
                completionHandler(allNewTasksForThisTask);
            }
        }];
    }];
    
}


- (void) getArrayOfTaskAssignees:(NSArray *)usersIds completionHandler:(void (^)(NSArray *allAssignees))completionHandler {
    NSMutableArray *gettingAssignees = [[NSMutableArray alloc] init];
    
    dispatch_group_t group = dispatch_group_create();
    for(NSString *userId in usersIds){
        
        dispatch_group_enter(group);
        
        [User getUserFromObjectId:userId completionHandler:^(User * _Nonnull user) {
            [gettingAssignees addObject:user];
            dispatch_group_leave(group);
        }];
    }
    dispatch_group_notify(group,dispatch_get_main_queue(), ^ {
        NSLog(@"this task belongs to: %@", (NSArray*)gettingAssignees);
        completionHandler((NSArray*)gettingAssignees);
    });
}


- (void) createTasksForEachDate:(Task *)taskFromDB :(NSArray *)assignees WithCompletionHandler:(void (^)(NSArray *createdTasks))completionHandler{
    
    NSMutableArray *rawTasksFromDB = [[NSMutableArray alloc] init];
    NSArray *taskDueDates = [self getArrayOfDueDates:taskFromDB];
    dispatch_group_t group = dispatch_group_create();
    for (NSDate *date in taskDueDates) {

        NSArray * assignedUsers;
        NSDate *newDate = [date dateWithHour:00 minute:00 second:00];
        
        __block User * recievedRotatingUser;
        if([taskFromDB .type isEqual:@"rotational"]){
            NSLog(@"in the rotational equal");
            assignedUsers = [self getRotationalAssigneeForTheDate:taskFromDB :newDate];
            recievedRotatingUser = [assignedUsers objectAtIndex:0];
        }
        else{
            assignedUsers = assignees;
        }
        
        User *currentHousemate = self.houseMate;
        
        if((![taskFromDB.type isEqual:@"rotational"]) || ([recievedRotatingUser.objectId isEqual:currentHousemate.objectId])) {
            dispatch_group_enter(group);
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [Task createTaskCopy:taskFromDB.objectId
                            From:taskFromDB
                             For:taskFromDB.taskDescription
                          OfType:taskFromDB.type
                  WithRepeatType:taskFromDB.repeats
                           Point:taskFromDB.repetitionPoint
                      NumOfTimes:taskFromDB.occurrences
                          Ending:newDate
                       Assignees:assignedUsers
               completionHandler:^(Task * _Nonnull newTask) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];

                if(newTask.completedObject.isCompleted != YES){
                    if(![newTask.completedObject.currentCompletionStatus containsObject:currentHousemate.objectId]){
                        [rawTasksFromDB addObject:newTask];
                        NSLog(@"NEWTASK IS: %@", newTask);
                    }
                }
                dispatch_group_leave(group);
            }];
        }
    }
    dispatch_group_notify(group,dispatch_get_main_queue(), ^ {
        NSLog(@"The rawTasksFromDB array in createTasksForDate is: %@", rawTasksFromDB);
        completionHandler((NSArray *)rawTasksFromDB);
    });
}


- (NSArray *) getRotationalAssigneeForTheDate: (Task*)taskFromDB :(NSDate *)date {
    NSMutableArray *assignedTo = [[NSMutableArray alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSDate *startDate = [dateFormatter dateFromString:taskFromDB.createdDate];
    NSDate *dueDate = date;
    NSDictionary *rotationalOrder = taskFromDB.rotationalOrder;

    NSString * repeatType = taskFromDB.repeats;
    
    int taskNumber = 0;
    
    if ([repeatType isEqual:@"daily"]){
        taskNumber = [NSDate whichNumberDayOccurrence:taskFromDB.repetitionPoint.intValue From:startDate Til:dueDate];
    }
    else if ([repeatType isEqual:@"weekly"]){
        taskNumber = [NSDate whichNumberWeekOccurrence:taskFromDB.repetitionPoint.intValue From:startDate Til:dueDate];
    }
    else if ([repeatType isEqual:@"monthly"]){
        taskNumber = [NSDate whichNumberMonthOccurrence:taskFromDB.repetitionPoint.intValue From:startDate Til:dueDate];
    }
    
    NSLog(@"the task number is %d", taskNumber);
    
    NSString *taskNumToString = [@((((taskNumber)%rotationalOrder.count)+1)) stringValue];
    User *houseMember = rotationalOrder[taskNumToString];
    PFQuery *query = [PFUser query];
    houseMember = (User *)[query getObjectWithId:houseMember.objectId];
    
    [assignedTo addObject:houseMember];
    return (NSArray *)assignedTo;
}


- (NSArray *) getArrayOfDueDates: (Task*)taskFromDB{
     
     NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
     [dateFormatter setDateFormat:@"yyyy/MM/dd"];
     NSDate *endingDate = [dateFormatter dateFromString:taskFromDB.endDate];
     [dateFormatter setDateFormat:@"yyyy-MM-dd"];
     NSString * endingDateStr = [dateFormatter stringFromDate:endingDate];
     endingDate = [dateFormatter dateFromString:endingDateStr];
     
     NSArray *dates = [[NSMutableArray alloc] init];
     if ([taskFromDB.repeats isEqual:@"daily"]){
         dates = [NSDate datesDaysAppearInStringFormat:taskFromDB.repetitionPoint.intValue Til:endingDate];
     }
     else if ([taskFromDB.repeats isEqual:@"weekly"]){
         dates = [NSDate datesWeeksAppearInStringFormat:taskFromDB.repetitionPoint.intValue Til:endingDate];
     }
     else if ([taskFromDB.repeats isEqual:@"monthly"]){
         dates = [NSDate datesMonthsAppearInStringFormat:taskFromDB.repetitionPoint.intValue Til:endingDate];
     }

     return dates;
 }


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.housematesTasks.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     
    HouseMateTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HouseMateTaskCell"];
    cell.task = self.housematesTasks[indexPath.row];
    [cell setTaskValues];
    [cell getTasksAssignees];
    cell.delegate = self;
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)taskCell:(nonnull HouseMateTaskCell *)taskCell didTap:(nonnull Task *)task {
    popUpNudgeHouseMateViewController *centerViewController = [popUpNudgeHouseMateViewController new];
    centerViewController.houseMate = self.houseMate;
    centerViewController.task = task;
    centerViewController.delegate = self;
    HWPopController *popController = [[HWPopController alloc] initWithViewController:centerViewController];
    popController.popPosition = HWPopPositionCenter;
    popController.popType = HWPopTypeGrowIn;
    popController.dismissType = HWDismissTypeShrinkOut;
    popController.shouldDismissOnBackgroundTouch = YES;
    [popController presentInViewController:self];
}


- (void)didNudge:(Task *)forChore{
    NSLog(@"DID NUDGE");
    [Notification postNotification:@"reminder" From:[User currentUser] To:self.houseMate ForChore:forChore withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
            NSLog(@"successfully notified housemate");
        }
        if(error){
            NSLog(@"there was an error %@:",error.localizedDescription);
        }
    }];
}


@end
