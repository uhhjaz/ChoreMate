//
//  WeeklyCalendarViewController.m
//  ChoreMate
//
//  Created by Jasdeep Gill on 8/6/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import "WeeklyCalendarViewController.h"
#import "CLWeeklyCalendarView.h"
#import "TaskCell.h"
#import "DayLabelCell.h"
#import "NSDate+CMDate.h"


@interface WeeklyCalendarViewController ()<CLWeeklyCalendarViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) CLWeeklyCalendarView* calendarView;
@property (nonatomic, strong) NSMutableArray* tasksForTheDay;
@property (weak, nonatomic) IBOutlet UIView *noChoresView;
@property (weak, nonatomic) IBOutlet UILabel *noChoresLabel;

@end

static CGFloat CALENDER_VIEW_HEIGHT = 150.f;
@implementation WeeklyCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.calendarView];
    
}

-(CLWeeklyCalendarView *)calendarView
{
    if(!_calendarView){
        _calendarView = [[CLWeeklyCalendarView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, CALENDER_VIEW_HEIGHT)];
        _calendarView.delegate = self;
    }
    return _calendarView;
}




#pragma mark - CLWeeklyCalendarViewDelegate
-(NSDictionary *)CLCalendarBehaviorAttributes
{
    return @{
             CLCalendarWeekStartDay : @7,                 //Start Day of the week, from 1-7 Mon-Sun -- default 1
//             CLCalendarDayTitleTextColor : [UIColor yellowColor],
//             CLCalendarSelectedDatePrintColor : [UIColor greenColor],
             };
}


-(void)dailyCalendarViewDidSelect:(NSDate *)date
{
    //You can do any logic after the view select the date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSString *dateAsString = [dateFormatter stringFromDate:date];
    NSLog(@"THE DATE AS STRING IS: %@", dateAsString);
    
    NSMutableArray *tasksDue = [self.myTasksByDueDate objectForKey:dateAsString];
    self.tasksForTheDay = [[NSMutableArray alloc] init];
    if( tasksDue == nil){
        NSLog(@"NO CHORES DUE ON THIS DATE");
        self.tasksForTheDay = (NSMutableArray *)@[];
        self.noChoresView.alpha = 1;
        
        NSDate *date1 = [date dateWithHour:00 minute:00 second:00];
        NSDate *date2 = [[NSDate date] dateWithHour:00 minute:00 second:00];
        if([date1 isEqual:date2]){
            self.noChoresLabel.text = @"You have no chores due today!";
        } else {
            self.noChoresLabel.text = @"You have no chores due on this day!";
        }
        self.tableView.hidden = YES;
        
    } else {
        NSLog(@"CHORES FOUND");
        self.noChoresView.alpha = 0;
        NSLog(@"%@",tasksDue);
        [self.tasksForTheDay addObjectsFromArray:tasksDue];
        self.tableView.hidden = NO;
    }
    [self.tableView reloadData];
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tasksForTheDay.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskCell"];
    cell.task = self.tasksForTheDay[indexPath.row];
    [cell setTaskValues];
    [cell getTasksAssignees];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.tasksForTheDay[indexPath.row] deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded){
                NSLog(@"Task was successfully removed from the database");
            }
            if(error){
                NSLog(@"There was an error deleting the task %@", error.localizedDescription);
            }
        }];
        
        [self.tasksForTheDay removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
    }

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if(![self.tasksForTheDay[indexPath.row] isKindOfClass:[NSString class]]){
        NSMutableArray *allCells = (NSMutableArray *)[self.tableView visibleCells];
        NSPredicate *testForCompletion = [NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            NSLog(@"here");
            TaskCell * cell = (TaskCell *)evaluatedObject;
            Task * task = cell.task;
            NSLog(@"the completed is %d:",task.completedObject.isCompleted);
            return task.completedObject.isCompleted;
        }];

        NSArray *filteredArray = [allCells filteredArrayUsingPredicate:testForCompletion];

        if (filteredArray != nil) {

            [filteredArray enumerateObjectsUsingBlock:^(UITableViewCell *cell, NSUInteger idx, BOOL *stop) {
                [cell setFrame:CGRectMake(0, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height)];
                [UIView animateWithDuration:1.5 animations:^{
                    [cell setFrame:CGRectMake(self.view.bounds.size.width, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height)];
                }];

                [UIView animateWithDuration:1 animations:^{
                    [self.tasksForTheDay removeObjectAtIndex:indexPath.row];
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
