//
//  TaskChoicePopUpViewController.m
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/16/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import "TaskChoicePopUpViewController.h"
#import "OneTimeTaskViewController.h"
#import <HWPopController/HWPop.h>
#import <Masonry/View+MASAdditions.h>
#import "CMColor.h"



@interface TaskChoicePopUpViewController ()

@end

@implementation TaskChoicePopUpViewController

int const TASK_CHOSEN_ONETIME = 0;
int const TASK_CHOSEN_RECURRING = 1;
int const TASK_CHOSEN_ROTATIONAL = 2;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"Task Choice";
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(didDismissPopUp)];
    self.navigationItem.rightBarButtonItem = doneItem;

    self.contentSizeInPop = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) - 30, 250);
    self.contentSizeInPopWhenLandscape = CGSizeMake(315, 300);

    UIButton *oneTimeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [oneTimeButton setTitle:@"One Time Chore" forState:UIControlStateNormal];
    oneTimeButton.layer.cornerRadius = 10;
    oneTimeButton.titleLabel.font = [UIFont systemFontOfSize:25 weight:UIFontWeightLight];
    [oneTimeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [oneTimeButton addTarget:self action:@selector(didTapOneTimeTask) forControlEvents:UIControlEventTouchUpInside];
    oneTimeButton.backgroundColor = [CMColor oneTimeTaskColor];
    oneTimeButton.layer.masksToBounds = YES;

    [self.view addSubview:oneTimeButton];
    
    [oneTimeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@-110);
        make.left.equalTo(@15);
        make.right.equalTo(@-15);
        make.height.mas_equalTo(40);
    }];
    
    UIButton *recurringButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [recurringButton setTitle:@"Recurring Chore" forState:UIControlStateNormal];
    recurringButton.layer.cornerRadius = 10;
    recurringButton.titleLabel.font = [UIFont systemFontOfSize:25 weight:UIFontWeightLight];
    [recurringButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [recurringButton addTarget:self action:@selector(didTapRecurringTask) forControlEvents:UIControlEventTouchUpInside];
    recurringButton.backgroundColor = [CMColor recurringTaskColor];
    recurringButton.layer.masksToBounds = YES;

    [self.view addSubview:recurringButton];
    
    [recurringButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@-60);
        make.left.equalTo(@15);
        make.right.equalTo(@-15);
        make.height.mas_equalTo(40);
    }];
    
    UIButton *rotationalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rotationalButton setTitle:@"Rotational Chore" forState:UIControlStateNormal];
    rotationalButton.layer.cornerRadius = 10;
    rotationalButton.titleLabel.font = [UIFont systemFontOfSize:25 weight:UIFontWeightLight];
    [rotationalButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rotationalButton addTarget:self action:@selector(didTapRotationalTask) forControlEvents:UIControlEventTouchUpInside];
    rotationalButton.backgroundColor = [CMColor rotationalTaskColor];
    rotationalButton.layer.masksToBounds = YES;

    [self.view addSubview:rotationalButton];
    
    [rotationalButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(@-10);
        make.left.equalTo(@15);
        make.right.equalTo(@-15);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *title = [[UILabel alloc] init];
    title.textColor = [UIColor blackColor];
    title.backgroundColor = [UIColor clearColor];
    title.font = [UIFont systemFontOfSize:33 weight:UIFontWeightRegular];
    title.text= @"Select a chore type";
    [self.view addSubview:title];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@-180);
        make.left.equalTo(@50);
        make.right.equalTo(@-50);
        make.height.mas_equalTo(40);
    }];
    
}

- (void)didDismissPopUp {
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)didTapRotationalTask {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate didChoose:TASK_CHOSEN_ROTATIONAL];
    }];
}


- (void)didTapRecurringTask {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate didChoose:TASK_CHOSEN_RECURRING];
    }];
}


- (void)didTapOneTimeTask {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate didChoose:TASK_CHOSEN_ONETIME];
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
