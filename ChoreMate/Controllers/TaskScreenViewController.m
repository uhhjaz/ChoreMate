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
#import "TaskCell.h"

// MARK: Controllers
#import "TaskScreenViewController.h"
#import "LoginViewController.h"
#import "TaskChoicePopUpViewController.h"
#import "OnceTimeTaskViewController.h"
#import "RecurringTaskViewController.h"
#import "RotationalTaskViewController.h"




@interface TaskScreenViewController () <TaskChoiceControllerDelegate, UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *addTaskButton;
@property (weak, nonatomic) IBOutlet UIView *theContainer;
@property (weak, nonatomic) IBOutlet UILabel *userWelcome;
@property (weak, nonatomic) User *currUser;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *household;
@property (strong, nonatomic) NSMutableArray *myTasks;
@property (strong, nonatomic) NSMutableArray *myRecurringTasks;
@property (strong, nonatomic) NSArray *assignees;

@end

@implementation TaskScreenViewController

int const TASK_TYPE_ONETIME = 0;
int const TASK_TYPE_RECURRING = 1;
int const TASK_TYPE_ROTATIONAL = 2;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self setupLeftMenuButton];
    
    
    self.currUser = [User currentUser];
    NSArray* firstLastStrings = [self.currUser.name componentsSeparatedByString:@" "];
    self.userWelcome.text = [NSString stringWithFormat:@"Hey %@!",[firstLastStrings objectAtIndex:0]];

    
    self.tableView.separatorColor = [UIColor clearColor];
    
    NSLog(@"the current user is: %@", self.currUser);
    
    if (self.currUser.household_id != nil) {
        [self getHousehold];
        [self getMyTasks];
    }
    else{
        // do something incase user doesnt have household and tasks
    }
    
    
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
                [self.tableView reloadData];
            
            } else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
    }
    
}

-(void)getMyTasks{
    PFQuery *query = [PFQuery queryWithClassName:@"Task"];
    [query whereKey:@"assignedTo" containsString:self.currUser.objectId];
    
    [query whereKey:@"completed" equalTo:@NO];
    [query whereKey:@"type" equalTo:@"one_time"];
    
    [query orderByAscending:@"dueDate"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *userTasks, NSError *error) {
        if (userTasks != nil) {
            NSLog(@"Successfully got household members");
            
            self.myTasks = (NSMutableArray*)userTasks;
            NSLog(@"Block1 End");
            [self.tableView reloadData];
            
            [self getMyReccuringTasks];
            
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}


-(void) getMyReccuringTasks{
    PFQuery *query = [PFQuery queryWithClassName:@"Task"];
    [query whereKey:@"assignedTo" containsString:self.currUser.objectId];
    [query whereKey:@"completed" equalTo:@NO];
    [query whereKey:@"type" equalTo:@"recurring"];
    
    [query orderByAscending:@"dueDate"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *userTasks, NSError *error) {
        if (userTasks != nil) {
            NSLog(@"Successfully got my recurring tasks");
            
            self.myRecurringTasks = (NSMutableArray*)userTasks;
            NSLog(@"my recurring tasks are %@", self.myRecurringTasks);
            
            dispatch_group_t group = dispatch_group_create();
            
            dispatch_group_enter(group);
            [self setUpRepeatingTasksWithCompletionHandler:^(BOOL success) {
                dispatch_group_leave(group);
            }];
            dispatch_group_notify(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^ {
                [self performSelectorOnMainThread:@selector(refreshTable) withObject:self.tableView waitUntilDone:YES];
            });
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

-(void)refreshTable {
    [self.tableView reloadData];
}



- (void) getArrayOfTaskAssignees:(NSArray *)usersIds completionHandler:(void (^)(NSArray *allAssignees))completionHandler {

    NSMutableArray *gettingAssignees = [[NSMutableArray alloc] init];
    
    for(NSString *userId in usersIds){
        [User getUserFromObjectId:userId completionHandler:^(User * _Nonnull user) {
            [gettingAssignees addObject:user];
            completionHandler((NSArray*)gettingAssignees);
        }];
    }
}



-(void) setUpRepeatingTasksWithCompletionHandler:(void (^)(BOOL success))completionHandler {
    
    [(NSArray*)self.myRecurringTasks enumerateObjectsUsingBlock:^(Task *task, NSUInteger idx, BOOL *stop) {
            
        dispatch_group_t group = dispatch_group_create();

        dispatch_group_enter(group);
        NSArray *userIds = [task objectForKey:@"assignedTo"];

        self.assignees = [[NSMutableArray alloc] init];
        [self getArrayOfTaskAssignees:userIds completionHandler:^(NSArray * _Nonnull allAssignees) {
            self.assignees = allAssignees;

            dispatch_group_leave(group);
            NSLog(@"block A end");
        }];
            
        dispatch_group_notify(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^ {
            NSLog(@"block B begin");
            NSArray *taskDueDates = [self getArrayOfDueDates:task];

            for (NSDate *date in taskDueDates) {

                NSLog(@"in the assigned user query: thisTaskAssignees is %@", self.assignees);
                Task * newTask = [Task createTaskCopy:task.objectId For:task.taskDescription OfType:task.type WithRepeatType:task.repeats Point:task.repetitionPoint NumOfTimes:task.occurrences Ending:date Assignees:self.assignees];
                
                [self.myTasks addObject:newTask];
                NSLog(@"newTASK IS: %@", newTask);
            }
            completionHandler(YES);
        });
    }];
    [self.tableView reloadData];

}


-(NSArray *) getArrayOfDueDates: (Task*)task{
    NSLog(@"getting dates array");
    NSLog(@"getArrayOfDueDates the endDate is: %@", task.endDate);
    

    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd --- HH:mm"];
    NSDate *endingDate = [dateFormatter dateFromString:task.endDate];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString * endingDateStr = [dateFormatter stringFromDate:endingDate];
    endingDate = [dateFormatter dateFromString:endingDateStr];
    
    NSMutableArray *dates = [[NSMutableArray alloc] init];
    if ([task.repeats isEqual:@"daily"]){
        dates = [self datesDaysAppear:task.repetitionPoint.intValue Til:endingDate];
    }
    else if ([task.repeats isEqual:@"weekly"]){
        dates = [self datesWeeksAppear:task.repetitionPoint.intValue Til:endingDate];
    }
    else if ([task.repeats isEqual:@"monthly"]){
        dates = [self datesMonthsAppear:task.repetitionPoint.intValue Til:endingDate];
    }
    
    NSLog(@"getArrayOfDueDates the dates are: %@",dates);
    return (NSArray*)dates;
}


- (NSMutableArray*) datesDaysAppear: (NSInteger)chosenTime Til: (NSDate *)endDate {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *findMatchingDayComponents = [[NSDateComponents alloc] init];
    findMatchingDayComponents.hour = chosenTime;
    NSMutableArray *dailyDates = [[NSMutableArray alloc] init];
    
    __block int dateCount = 0;
    [calendar enumerateDatesStartingAfterDate:[NSDate date]
                          matchingComponents:findMatchingDayComponents
                                     options:NSCalendarMatchPreviousTimePreservingSmallerUnits
                                  usingBlock:^(NSDate *date, BOOL exactMatch, BOOL *stop) {
        if (date.timeIntervalSince1970 >= endDate.timeIntervalSince1970) {
            *stop = YES;
        }
        else {
            NSLog(@"%@", date);
            dateCount++;
            [dailyDates addObject:date];
        }
    }];
    
    return dailyDates;
}


- (NSMutableArray*) datesWeeksAppear: (NSInteger)weekDayChosen Til: (NSDate *)endDate {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *findMatchingDayComponents = [[NSDateComponents alloc] init];
    findMatchingDayComponents.weekday = weekDayChosen;
    NSMutableArray *weeklyDates = [[NSMutableArray alloc] init];
    
    __block int dateCount = 0;
    [calendar enumerateDatesStartingAfterDate:[NSDate date]
                          matchingComponents:findMatchingDayComponents
                                     options:NSCalendarMatchPreviousTimePreservingSmallerUnits
                                  usingBlock:^(NSDate *date, BOOL exactMatch, BOOL *stop) {
        if (date.timeIntervalSince1970 >= endDate.timeIntervalSince1970) {
            *stop = YES;
        }
        else {
            NSLog(@"%@", date);
            dateCount++;
            [weeklyDates addObject:date];
        }
    }];
    
    return weeklyDates;
}


- (NSMutableArray*) datesMonthsAppear:(NSInteger )dayChosen Til:(NSDate *)endDate {
    
    NSLog(@"the chosen day is: %ld", (long)dayChosen);
    NSLog(@"the chosen end date is: %@", endDate);
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *findMatchingDayComponents = [[NSDateComponents alloc] init];
    findMatchingDayComponents.day = dayChosen;
    NSMutableArray *monthlyDates = [[NSMutableArray alloc] init];
    
    __block int dateCount = 0;
    [calendar enumerateDatesStartingAfterDate:[NSDate date]
                          matchingComponents:findMatchingDayComponents
                                     options:NSCalendarMatchPreviousTimePreservingSmallerUnits
                                  usingBlock:^(NSDate *date, BOOL exactMatch, BOOL *stop) {
        if (date.timeIntervalSince1970 >= endDate.timeIntervalSince1970) {
            *stop = YES;
        }
        else {
            NSLog(@"%@", date);
            dateCount++;
            [monthlyDates addObject:date];
        }
    }];
    NSLog(@"the monthly dates : %@",monthlyDates);
    return monthlyDates;
}


#pragma mark - Task TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.myTasks.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     
    TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskCell"];
    cell.task = self.myTasks[indexPath.row];
    [cell setTaskValues];
    [cell getTasksAssignees];
    //NSLog(@"the task assignees are: %@", cell.taskAssignees);
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.myTasks[indexPath.row] deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded){
                NSLog(@"Task was successfully removed from the database");
            }
            if(error){
                NSLog(@"There was an error deleting the task %@", error.localizedDescription);
            }
        }];
        [self.myTasks removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    NSMutableArray *allCells = (NSMutableArray *)[self.tableView visibleCells];
    NSPredicate *testForTrue = [NSPredicate predicateWithFormat:@"self.task.completed == 1"];
    NSArray *filteredArray = [allCells filteredArrayUsingPredicate:testForTrue];
    
    if (filteredArray != nil) {
    
        [filteredArray enumerateObjectsUsingBlock:^(UITableViewCell *cell, NSUInteger idx, BOOL *stop) {
            [cell setFrame:CGRectMake(0, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height)];
            [UIView animateWithDuration:1.5 animations:^{
                [cell setFrame:CGRectMake(self.view.bounds.size.width, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height)];
            }];
        
            [UIView animateWithDuration:1 animations:^{
                [self.myTasks removeObjectAtIndex:indexPath.row];
            }];
        }];
    
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
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


#pragma mark - Task Choice

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
