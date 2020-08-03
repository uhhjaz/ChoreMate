//
//  popUpHouseholdCodeController.m
//  ChoreMate
//
//  Created by Jasdeep Gill on 8/2/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import "popUpHouseholdCodeController.h"
#import <HWPopController/HWPop.h>
#import <Masonry/View+MASAdditions.h>
#import "MBProgressHUD.h"
#import "User.h"
#import "CMColor.h"

@interface popUpHouseholdCodeController ()

@property (nonatomic, strong) UILabel *successfulLabel;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) UILabel *codeLabel;
@property (nonatomic, strong) UIButton *okayButton;
@property (nonatomic, strong) UIButton *shareButton; // maybe add

@end

@implementation popUpHouseholdCodeController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.contentSizeInPop = CGSizeMake(330, 400);
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupView];
}

- (void)setupView {
    [self.view addSubview:self.successfulLabel];
    [self.view addSubview:self.promptLabel];
    [self.view addSubview:self.codeLabel];
    [self.view addSubview:self.okayButton];
    //[self.view addSubview:self.shareButton];
    [self setupViewConstraints];
}

- (void)setupViewConstraints {
    [self.successfulLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(@10);
        make.left.equalTo(@8);
        make.right.equalTo(@-8);
    }];

    [self.okayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(@75);
        make.bottom.equalTo(@-10);
        make.left.equalTo(@8);
        make.right.equalTo(@-8);
    }];
    
//    [self.joinButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.cancelButton.mas_right).offset(20);
//        make.bottom.equalTo(self.cancelButton);
//        make.right.equalTo(@-8);
//    }];
    
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_successfulLabel.mas_bottom).offset(20);
        //make.top.equalTo(@120);
        make.left.equalTo(@8);
        make.right.equalTo(@-8);
    }];
    
    [self.codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_promptLabel.mas_bottom).offset(30);
        //make.bottom.equalTo(@-50);
        make.left.equalTo(@8);
        make.right.equalTo(@-8);
    }];
    
}

- (void)didTapToDismiss {
    [self.popController dismiss];
}

- (void)didTapOkay {
    NSLog(@"user didTap Okay in popup");
    [self.popController dismissWithCompletion:^{
        [self.delegate didCreateHousehold];
    }];
}

- (UILabel *)codeLabel {
    if (!_codeLabel) {
        _codeLabel = [UILabel new];
        _codeLabel.textAlignment = NSTextAlignmentCenter;
        _codeLabel.font = [UIFont systemFontOfSize:30 weight:UIFontWeightBold];
        _codeLabel.text = self.householdCode;
        _codeLabel.numberOfLines = 0;
    }
    return _codeLabel;
}

- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = [UILabel new];
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightLight];
        _promptLabel.text = @"Share the following code with your housemates to invite them to join:";
        _promptLabel.numberOfLines = 0;
    }
    return _promptLabel;
}

- (UILabel *)successfulLabel {
    if (!_successfulLabel) {
        _successfulLabel = [UILabel new];
        _successfulLabel.textAlignment = NSTextAlignmentCenter;
        _successfulLabel.font = [UIFont systemFontOfSize:28 weight:UIFontWeightThin];
        _successfulLabel.text = [NSString stringWithFormat:@"Congratulations!\nYou have successfuly created a new household!"];
        _successfulLabel.numberOfLines = 0;
    }
    return _successfulLabel;
}

- (UIButton *)okayButton {
    if (!_okayButton) {
        _okayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_okayButton setTitle:@"Okay" forState:UIControlStateNormal];
        [_okayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_okayButton setBackgroundColor:[CMColor completedTaskColor]];
        _okayButton.layer.cornerRadius = 4;
        _okayButton.layer.masksToBounds = YES;
        [_okayButton addTarget:self action:@selector(didTapOkay) forControlEvents:UIControlEventTouchUpInside];
    }
    return _okayButton;
}

//- (UIButton *)joinButton {
//    if (!_joinButton) {
//        _joinButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_joinButton setTitle:@"Join" forState:UIControlStateNormal];
//        [_joinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_joinButton setBackgroundColor:[CMColor completedTaskColor]];
//        _joinButton.layer.cornerRadius = 4;
//        _joinButton.layer.masksToBounds = YES;
//        [_joinButton addTarget:self action:@selector(didTapToJoin) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _joinButton;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
