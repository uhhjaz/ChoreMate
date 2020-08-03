//
//  popUpNudgeHouseMateViewController.m
//  ChoreMate
//
//  Created by Jasdeep Gill on 8/3/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import "popUpNudgeHouseMateViewController.h"
#import <HWPopController/HWPop.h>
#import <Masonry/View+MASAdditions.h>
#import "MBProgressHUD.h"
#import "User.h"
#import "CMColor.h"

@interface popUpNudgeHouseMateViewController ()

@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) UIButton *yesButton;
@property (nonatomic, strong) UIButton *noButton; // maybe add

@end

@implementation popUpNudgeHouseMateViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.contentSizeInPop = CGSizeMake(330, 220);
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupView];
}

- (void)setupView {
    [self.view addSubview:self.promptLabel];
    [self.view addSubview:self.noButton];
    [self.view addSubview:self.yesButton];
    [self setupViewConstraints];
}

- (void)setupViewConstraints {
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(@10);
        make.left.equalTo(@8);
        make.right.equalTo(@-8);
    }];

    [self.noButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.yesButton);
        make.bottom.equalTo(@-10);
        make.left.equalTo(@8);
    }];
    
    [self.yesButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.noButton.mas_right).offset(20);
        make.bottom.equalTo(self.noButton);
        make.right.equalTo(@-8);
    }];

}



- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = [UILabel new];
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.font = [UIFont systemFontOfSize:33 weight:UIFontWeightLight];
        _promptLabel.text = [NSString stringWithFormat:@"Would you like to nudge %@ to complete this task?", self.houseMate.name];
        _promptLabel.numberOfLines = 0;
    }
    return _promptLabel;
}


- (UIButton *)yesButton {
    if (!_yesButton) {
        _yesButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_yesButton setTitle:@"YES" forState:UIControlStateNormal];
        [_yesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_yesButton setBackgroundColor:[CMColor completedTaskColor]];
        _yesButton.layer.cornerRadius = 4;
        _yesButton.layer.masksToBounds = YES;
        [_yesButton addTarget:self action:@selector(didTapToNudge) forControlEvents:UIControlEventTouchUpInside];
    }
    return _yesButton;
}


- (UIButton *)noButton {
    if (!_noButton) {
        _noButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_noButton setTitle:@"NO" forState:UIControlStateNormal];
        [_noButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_noButton setBackgroundColor:[CMColor completedTaskColor]];
        _noButton.layer.cornerRadius = 4;
        _noButton.layer.masksToBounds = YES;
        [_noButton addTarget:self action:@selector(didTapToDismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _noButton;
}


- (void)didTapToDismiss {
    [self.popController dismiss];
}


- (void)didTapToNudge {
    [self.popController dismissWithCompletion:^{
        [self.delegate didNudge:self.task];
    }];
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
