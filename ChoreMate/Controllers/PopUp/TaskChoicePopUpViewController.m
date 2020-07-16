//
//  TaskChoicePopUpViewController.m
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/16/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import "TaskChoicePopUpViewController.h"
#import "OnceTimeTaskViewController.h"
#import <HWPopController/HWPop.h>
#import <Masonry/View+MASAdditions.h>



@interface TaskChoicePopUpViewController ()

@end

@implementation TaskChoicePopUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    self.navigationItem.title = @"Task Choice";
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(didDismissPopUp)];
    self.navigationItem.rightBarButtonItem = doneItem;

    self.contentSizeInPop = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) - 30, 250);
    self.contentSizeInPopWhenLandscape = CGSizeMake(315, 300);

    //UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_cat"]];

    UIButton *oneTimeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [oneTimeButton setTitle:@"One Time Task" forState:UIControlStateNormal];
    oneTimeButton.titleLabel.font = [UIFont boldSystemFontOfSize:25];
    [oneTimeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [oneTimeButton addTarget:self action:@selector(didTapOneTimeTask) forControlEvents:UIControlEventTouchUpInside];
    oneTimeButton.backgroundColor = [UIColor systemGray2Color];
    oneTimeButton.layer.masksToBounds = YES;

    [self.view addSubview:oneTimeButton];
    
    [oneTimeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@-10);
        make.left.equalTo(@15);
        make.right.equalTo(@-15);
        make.height.mas_equalTo(40);
    }];
    
    UIButton *recurringButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [recurringButton setTitle:@"Recurring Task" forState:UIControlStateNormal];
    recurringButton.titleLabel.font = [UIFont boldSystemFontOfSize:25];
    [recurringButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [recurringButton addTarget:self action:@selector(didTapRecurringTask) forControlEvents:UIControlEventTouchUpInside];
    recurringButton.backgroundColor = [UIColor systemGray2Color];
    recurringButton.layer.masksToBounds = YES;

    [self.view addSubview:recurringButton];
    
    [recurringButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@-60);
        make.left.equalTo(@15);
        make.right.equalTo(@-15);
        make.height.mas_equalTo(40);
    }];
    
    UIButton *rotationalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rotationalButton setTitle:@"Rotational Task" forState:UIControlStateNormal];
    rotationalButton.titleLabel.font = [UIFont boldSystemFontOfSize:25];
    [rotationalButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rotationalButton addTarget:self action:@selector(didTapRotationalTask) forControlEvents:UIControlEventTouchUpInside];
    rotationalButton.backgroundColor = [UIColor systemGray2Color];
    rotationalButton.layer.masksToBounds = YES;

    [self.view addSubview:rotationalButton];
    
    [rotationalButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@-110);
        make.left.equalTo(@15);
        make.right.equalTo(@-15);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *title = [[UILabel alloc] init];
    title.textColor = [UIColor blackColor];
    title.backgroundColor = [UIColor clearColor];
    title.font = [UIFont boldSystemFontOfSize:30];
    title.text= @"Choose a task type";
    [self.view addSubview:title];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@-180);
        make.left.equalTo(@60);
        make.right.equalTo(@-60);
        make.height.mas_equalTo(40);
    }];
    
}

- (void)didDismissPopUp {
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)didTapRotationalTask {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate didChoose:@2];
    }];
}


- (void)didTapRecurringTask {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate didChoose:@1];
    }];
}


- (void)didTapOneTimeTask {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate didChoose:@0];
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
