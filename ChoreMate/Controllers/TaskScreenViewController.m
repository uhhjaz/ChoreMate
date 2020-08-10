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
#import "NSDate+CMDate.h"
#import "AllTasksViewController.h"

// MARK: Models
#import "Task.h"
#import "User.h"

// MARK: Views
#import "TaskCell.h"

// MARK: Controllers
#import "TaskScreenViewController.h"
#import "LoginViewController.h"
#import "TaskChoicePopUpViewController.h"
#import "OneTimeTaskViewController.h"
#import "RecurringTaskViewController.h"
#import "RotationalTaskViewController.h"
#import "HouseMateTaskCell.h"
#import "WeeklyCalendarViewController.h"



@interface TaskScreenViewController () <TaskChoiceControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *addTaskButton;
@property (weak, nonatomic) User *currUser;
@property (strong, nonatomic) NSArray *household;

@property (weak, nonatomic) NSArray *allTasks;
@property (strong, nonatomic) NSMutableArray *myTasks;
@property (weak, nonatomic) NSArray *myTasksWithDates;
@property (strong, nonatomic) NSMutableArray *myDates;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIView *allTasksContainer;
@property (weak, nonatomic) IBOutlet UIView *weeklyTasksContainer;
@property (strong, nonatomic) AllTasksViewController * allTasksViewController;
@property (strong, nonatomic) WeeklyCalendarViewController * weeklyTasksViewController;


@end

@implementation TaskScreenViewController

int const TASK_TYPE_ONETIME = 0;
int const TASK_TYPE_RECURRING = 1;
int const TASK_TYPE_ROTATIONAL = 2;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupLeftMenuButton];
    
    self.currUser = [User currentUser];
    
    if (self.currUser.household_id != nil) {
       [self getAllTasks];
    }
    else{
        // do something incase user doesnt have household and tasks
    }
    
    [self setChildViewControllers];
}

- (void) setChildViewControllers{
    self.allTasksViewController = [self.childViewControllers objectAtIndex:0];
    self.weeklyTasksViewController = [self.childViewControllers objectAtIndex:1];
}



- (void) getAllTasks{
    PFQuery *query = [PFQuery queryWithClassName:@"Task"];
    [query whereKey:@"assignedTo" containsString:self.currUser.objectId];
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
    
    self.myTasks = [[NSMutableArray alloc] init];
    for(Task *taskFromDB in self.allTasks){
        
        if([taskFromDB.type isEqual:@"one_time"]){
            [Completed createCompletedFromTask:taskFromDB AndDate:taskFromDB.endDate completionHandler:^(Completed * _Nonnull completedObject) {
                taskFromDB.completedObject = completedObject;
                taskFromDB.taskDatabaseId = taskFromDB.objectId;
                if(taskFromDB.completedObject.isCompleted != YES){
                    NSString *endDateString = taskFromDB.completedObject.endDate;
                    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
                    NSDate *endDate = [dateFormatter dateFromString:endDateString];
                    NSDate *todaysDate = [[NSDate date] dateWithHour:23 minute:59 second:59];
                    if(endDate.timeIntervalSince1970 > todaysDate.timeIntervalSince1970){
                        [self.myTasks addObject:taskFromDB];
                        [self sortBasedOnCompletionDate];
                        [self updateTables];
                    }
                }
            }];
        
        } else if([taskFromDB.type isEqual:@"recurring"]){
            [self makeRecurringRotationalTasks:taskFromDB completionHandler:^(NSArray *createdRecurringRotationalTasks) {
                [self.myTasks addObjectsFromArray:createdRecurringRotationalTasks];
                [self sortBasedOnCompletionDate];
                [self updateTables];

            }];
        
        } else if([taskFromDB.type isEqual:@"rotational"]){
            [self makeRecurringRotationalTasks:taskFromDB completionHandler:^(NSArray *createdRecurringRotationalTasks) {
                [self.myTasks addObjectsFromArray:createdRecurringRotationalTasks];
                [self sortBasedOnCompletionDate];
                [self updateTables];

            }];
        
        } else {
            NSLog(@"task is configured incorrectly-- it needs a valid type!");
        }
    }
}

- (void) updateTables {
    
    NSDictionary *dateContainers = [self createDateContainers];
    NSLog(@"the dictionary is %@", dateContainers);

    NSMutableArray *tasksWithDates = [[NSMutableArray alloc] init];
    for (NSString* key in self.myDates){
        [tasksWithDates addObject:key];
        [tasksWithDates addObjectsFromArray: [dateContainers objectForKey:key]];
    }
    
    NSLog(@"the tasksWithDates is: %@", tasksWithDates);
    self.myTasksWithDates = (NSArray*)tasksWithDates;
    
    self.weeklyTasksViewController.myTasks = self.myTasks;
    self.allTasksViewController.myTasksWithDates = self.myTasksWithDates;
    [self.allTasksViewController.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    self.weeklyTasksViewController.myTasksByDueDate = dateContainers;
}

- (void) sortBasedOnCompletionDate {
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"completedObject.endDate" ascending:YES];
    [self.myTasks sortUsingDescriptors:[NSArray arrayWithObject:sorter]];
}


- (void) makeRecurringRotationalTasks: (Task *)taskFromDB completionHandler:(void (^)(NSArray *createdRecurringRotationalTasks))completionHandler{
    __block NSArray *allNewTasksForThisTask = [[NSArray alloc] init];
    
    NSArray *userIds = [taskFromDB objectForKey:@"assignedTo"];
    
    __block NSArray *assignees;
    [self getArrayOfTaskAssignees:userIds completionHandler:^(NSArray * _Nonnull allAssignees) {
        assignees = allAssignees;
        [self createTasksForEachDate:taskFromDB :assignees WithCompletionHandler:^(NSArray *createdTasks) {
            if(createdTasks != nil) {
                allNewTasksForThisTask = createdTasks;
                completionHandler(allNewTasksForThisTask);
            }
        }];
    }];
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
            assignedUsers = [self getRotationalAssigneeForTheDate:taskFromDB :newDate];
            recievedRotatingUser = [assignedUsers objectAtIndex:0];
        }
        else{
            assignedUsers = assignees;
        }
        
        User *currentHousemate = self.currUser;
        
        if((![taskFromDB.type isEqual:@"rotational"]) || ([recievedRotatingUser.objectId isEqual:currentHousemate.objectId])) {
            dispatch_group_enter(group);
            
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
                
                if(newTask.completedObject.isCompleted != YES){
                    NSString *endDateString = newTask.completedObject.endDate;
                    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
                    NSDate *endDate = [dateFormatter dateFromString:endDateString];
                    NSDate *todaysDate = [[NSDate date] dateWithHour:23 minute:59 second:59];
                    if(endDate.timeIntervalSince1970 > todaysDate.timeIntervalSince1970){
                        [rawTasksFromDB addObject:newTask];
                        NSLog(@"THE NEWTASK IS: %@", newTask);
                    }
                }
                dispatch_group_leave(group);
            }];
        }
    }
    dispatch_group_notify(group,dispatch_get_main_queue(), ^ {
        completionHandler((NSArray *)rawTasksFromDB);
    });
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
        completionHandler((NSArray*)gettingAssignees);
    });
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
    
    NSString *taskNumToString = [@((((taskNumber)%rotationalOrder.count)+1)) stringValue];
    User *houseMember = rotationalOrder[taskNumToString];
    PFQuery *query = [PFUser query];
    houseMember = (User *)[query getObjectWithId:houseMember.objectId];
    
    [assignedTo addObject:houseMember];
    return (NSArray *)assignedTo;
}


- (void) getHousehold{

    User *curr = [User currentUser];
    
    PFQuery *query = [PFUser query];
    
    if(curr.household_id != nil){
        // query for household members of the user
        [query whereKey:@"household_id" equalTo:curr.household_id];
        [query findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
            if (users != nil) {
                NSLog(@"Successfully got household members");
            
                self.household = users;
            
            } else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
    }
    
}


#pragma mark - Navigation Drawer

- (void)setupLeftMenuButton {
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton];
}


- (void)leftDrawerButtonPress:(id)leftDrawerButtonPress {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (IBAction)didChangeTaskView:(UISegmentedControl *)sender {
    //[self getAllTasks];
    switch (sender.selectedSegmentIndex) {
        case 0: {
            [UIView animateWithDuration:0.2 animations:^{
                self.allTasksContainer.alpha = 1;
                self.weeklyTasksContainer.alpha = 0;
            }];
            [self.allTasksViewController.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            
            break;
        }
        case 1: {
            [UIView animateWithDuration:0.2 animations:^{
                self.allTasksContainer.alpha = 0;
                self.weeklyTasksContainer.alpha = 1;
            }];
            [self.weeklyTasksViewController.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];

            break;
        }
        default:
            break;
    }
}

#pragma mark - Task Choice

- (IBAction)didTapAddTask:(id)sender {

    TaskChoicePopUpViewController *popViewController = [TaskChoicePopUpViewController new];
    
    popViewController.delegate = self;
    HWPopController *popController = [[HWPopController alloc] initWithViewController:popViewController];
    popController.popPosition = HWPopPositionBottom;
    popController.popType = HWPopTypeBounceInFromBottom;
    popController.dismissType = HWDismissTypeSlideOutToBottom;
    popController.shouldDismissOnBackgroundTouch = YES;
    [popController presentInViewController:self];
    
}


- (void)didChoose:(int)type{

    OneTimeTaskViewController* controller;
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


-(NSDictionary *) createDateContainers{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    self.myDates = [[NSMutableArray alloc] init];
    for(Task *task in self.myTasks){
        NSString *dueDate = task.completedObject.endDate;
        NSMutableArray *tasksDue = [dict objectForKey:dueDate];
        if( tasksDue == nil){
            [self.myDates addObject:dueDate];
            NSMutableArray *tasksDueOnThisDate = [[NSMutableArray alloc] init];
            [tasksDueOnThisDate addObject:task];
            [dict setObject:tasksDueOnThisDate forKey:dueDate];
        } else {
            [tasksDue addObject:task];
        }
    }
    return (NSDictionary*)dict;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//
//}


@end
