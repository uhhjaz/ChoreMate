//
//  TaskPopUpViewController.m
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/15/20.
//  Copyright © 2020 jazgill. All rights reserved.
//


#import "TaskPopUpViewController.h"
#import <HWPopController/HWPop.h>
#import <Masonry/View+MASAdditions.h>
#import "OneTimeTaskViewController.h"


@interface TaskPopUpViewController ()

@end

@implementation TaskPopUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    self.navigationItem.title = @"Cat";
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(didTapOneTimeTask)];
    self.navigationItem.rightBarButtonItem = doneItem;

    self.contentSizeInPop = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) - 30, 300);
    self.contentSizeInPopWhenLandscape = CGSizeMake(315, 300);

    //UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_cat"]];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"One Time Task" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:30];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(didTapOneTimeTask) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor colorWithRed:0.000 green:0.590 blue:1.000 alpha:1.00];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 6.f;

    [self.view addSubview:button];

    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@-10);
        make.left.equalTo(@15);
        make.right.equalTo(@-15);
        make.height.mas_equalTo(60);
    }];
}

- (void)didTapOneTimeTask {
    NSLog(@"One time task click registered");
//    [self.popController dismiss];
    OneTimeTaskViewController *controller = [[OneTimeTaskViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [self dismissViewControllerAnimated:YES completion:NULL];
    
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
