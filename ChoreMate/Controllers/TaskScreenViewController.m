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


- (void)viewWillAppear:(BOOL)animated{
    //[self refreshTable];
    [self getMyTasks];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self setupLeftMenuButton];
    
    
    self.currUser = [User currentUser];
    NSArray* firstLastStrings = [self.currUser.name componentsSeparatedByString:@" "];
    self.userWelcome.text = [NSString stringWithFormat:@"Hey %@!",[firstLastStrings objectAtIndex:0]];

    self.tableView.separatorColor = [UIColor clearColor];
    
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
    [query whereKey:@"type" equalTo:@"one_time"];
    PFQuery *query2 = [PFQuery queryWithClassName:@"Completed"];
    [query2 whereKey:@"isCompleted" equalTo:@NO];
    [query whereKey:@"completed" matchesQuery:query2];
    [query orderByAscending:@"dueDate"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *userTasks, NSError *error) {
        if (userTasks != nil) {
            NSLog(@"Successfully got household members");
            self.myTasks = (NSMutableArray*)userTasks;
            [self getMyReccuringTasks];
            [self.tableView reloadData];
            
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}


-(void) getMyReccuringTasks{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Task"];
    [query whereKey:@"assignedTo" containsString:self.currUser.objectId];
    [query whereKey:@"type" equalTo:@"recurring"];
    PFQuery *query2 = [PFQuery queryWithClassName:@"Completed"];
    [query2 whereKey:@"isCompleted" equalTo:@NO];
    [query whereKey:@"completed" matchesQuery:query2];
    [query orderByAscending:@"dueDate"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *userTasks, NSError *error) {
        if (userTasks != nil) {
            NSLog(@"Successfully got my recurring tasks");
            
            self.myRecurringTasks = [[NSMutableArray alloc] init];
            self.myRecurringTasks = (NSMutableArray*)userTasks;
            
            dispatch_group_t group = dispatch_group_create();
            dispatch_group_enter(group);
            [self setUpRepeatingTasksWithCompletionHandler:^(BOOL success) {
                dispatch_group_leave(group);
            }];
            
            dispatch_group_notify(group,dispatch_get_main_queue(), ^ {
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
    
    dispatch_group_t group3 = dispatch_group_create();
    for(NSString *userId in usersIds){
        
        dispatch_group_enter(group3);
        
        [User getUserFromObjectId:userId completionHandler:^(User * _Nonnull user) {
            [gettingAssignees addObject:user];
            dispatch_group_leave(group3);
        }];
    }
    dispatch_group_notify(group3,dispatch_get_main_queue(), ^ {
        completionHandler((NSArray*)gettingAssignees);
    });

}


-(void) setUpRepeatingTasksWithCompletionHandler:(void (^)(BOOL success))completionHandler {
    

    [(NSArray*)self.myRecurringTasks enumerateObjectsUsingBlock:^(Task *task, NSUInteger idx, BOOL *stop) {
        dispatch_group_t group2 = dispatch_group_create();

        NSArray *userIds = [task objectForKey:@"assignedTo"];
        dispatch_group_enter(group2);
        self.assignees = [[NSMutableArray alloc] init];
        [self getArrayOfTaskAssignees:userIds completionHandler:^(NSArray * _Nonnull allAssignees) {
            self.assignees = allAssignees;
            NSLog(@"block A end");
            dispatch_group_leave(group2);
        }];
        
        dispatch_group_notify(group2,dispatch_get_main_queue(), ^ {
            NSLog(@"block B begin");
            [self createTasksForEachDate:task :self.assignees WithCompletionHandler:^(BOOL success) {
                [self performSelectorOnMainThread:@selector(refreshTable) withObject:self.tableView waitUntilDone:YES];
            }];
        });
    }];
}


-(void) createTasksForEachDate:(Task *)task :(NSArray *)assignees WithCompletionHandler:(void (^)(BOOL success))completionHandler{
    
    dispatch_group_t group2 = dispatch_group_create();
    NSArray *taskDueDates = [self getArrayOfDueDates:task];

    for (NSDate *date in taskDueDates) {
        
        dispatch_group_enter(group2);
        NSLog(@"the task is: %@",task.taskDescription);
        NSLog(@"in the assigned user query: thisTaskAssignees is %@", self.assignees);
        NSLog(@"the due date in dispatch is: %@", date);
            
        [Task createTaskCopy:task.objectId From:task For:task.taskDescription OfType:task.type WithRepeatType:task.repeats Point:task.repetitionPoint NumOfTimes:task.occurrences Ending:date Assignees:self.assignees completionHandler:^(Task * _Nonnull newTask) {
            
            [self.myTasks addObject:newTask];
            
            NSLog(@"NEWTASK IS: %@", newTask);
            dispatch_group_leave(group2);
        }];
    }
    
    dispatch_group_notify(group2,dispatch_get_main_queue(), ^ {
        completionHandler(YES);
    });
}


-(NSArray *) getArrayOfDueDates: (Task*)task{
    
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

// TODO: move these calendar methods to another file
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
            dateCount++;
            [weeklyDates addObject:date];
        }
    }];
    
    return weeklyDates;
}


- (NSMutableArray*) datesMonthsAppear:(NSInteger )dayChosen Til:(NSDate *)endDate {
    
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
            dateCount++;
            [monthlyDates addObject:date];
        }
    }];
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
