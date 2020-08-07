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


@interface WeeklyCalendarViewController ()<CLWeeklyCalendarViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) CLWeeklyCalendarView* calendarView;
@property (nonatomic, strong) NSMutableArray* tasksForTheDay;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *noChoresView;

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
        self.tableView.hidden = YES;
        
    } else {
        NSLog(@"CHORES FOUND");
        self.noChoresView.alpha = 0;
        NSLog(@"%@",tasksDue);
        [self.tasksForTheDay addObject:dateAsString];
        
        [self.tasksForTheDay addObjectsFromArray:tasksDue];
        [self.tasksForTheDay addObject:dateAsString];
        self.tableView.hidden = NO;
    }
    [self.tableView reloadData];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tasksForTheDay.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([self.tasksForTheDay[indexPath.row] isKindOfClass:[NSString class]]){
        DayLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DayLabelCell"];
        return cell;
    } else {
        TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskCell"];
        cell.task = self.tasksForTheDay[indexPath.row];
        [cell setTaskValues];
        [cell getTasksAssignees];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
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
