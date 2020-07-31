//
//  popUpJoinHouseholdViewController.m
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/28/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import "popUpJoinHouseholdViewController.h"
#import <HWPopController/HWPop.h>
#import <Masonry/View+MASAdditions.h>
#import "MBProgressHUD.h"
#import "User.h"
#import "CMColor.h"

@interface popUpJoinHouseholdViewController ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *houseMembersLabel;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) UIButton *joinButton;
@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation popUpJoinHouseholdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.contentSizeInPop = CGSizeMake(330, 400);
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupView];
}

- (void)setupView {
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.houseMembersLabel];
    [self.view addSubview:self.promptLabel];
    [self.view addSubview:self.cancelButton];
    [self.view addSubview:self.joinButton];
    [self setupViewConstraints];
}

- (void)setupViewConstraints {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(@10);
        make.left.equalTo(@8);
        make.right.equalTo(@-8);
    }];

    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.joinButton);
        make.bottom.equalTo(@-10);
        make.left.equalTo(@8);
    }];
    
    [self.joinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cancelButton.mas_right).offset(20);
        make.bottom.equalTo(self.cancelButton);
        make.right.equalTo(@-8);
    }];
    
    [self.houseMembersLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(20);
        //make.top.equalTo(@120);
        make.left.equalTo(@8);
        make.right.equalTo(@-8);
    }];
    
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_houseMembersLabel.mas_bottom).offset(20);
        //make.bottom.equalTo(@-50);
        make.left.equalTo(@8);
        make.right.equalTo(@-8);
    }];
    
}

- (void)didTapToDismiss {
    [self.popController dismiss];
}

- (void)didTapToJoin {
    User *user = [User currentUser];
    user.household_id = self.household.objectId;
    [user saveInBackground];
    [self.popController dismissWithCompletion:^{
        [self.delegate didJoinHousehold];
    }];
}

- (UILabel *)houseMembersLabel {
    if (!_houseMembersLabel) {
        _houseMembersLabel = [UILabel new];
        _houseMembersLabel.textAlignment = NSTextAlignmentCenter;
        _houseMembersLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightThin];
        NSString *householdList = @"";
        for(User * houseMember in self.householdMembers){
            householdList = [householdList stringByAppendingFormat:@"%@\n",houseMember.name];
        }
        _houseMembersLabel.text = householdList;
        _houseMembersLabel.numberOfLines = 0;
    }
    return _houseMembersLabel;
}

- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = [UILabel new];
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.font = [UIFont systemFontOfSize:33 weight:UIFontWeightLight];
        _promptLabel.text = [NSString stringWithFormat:@"Would you like to join this house?"];
        _promptLabel.numberOfLines = 0;
    }
    return _promptLabel;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:28 weight:UIFontWeightThin];
        _titleLabel.text = [NSString stringWithFormat:@"The members of \n%@ are: ",self.household.name];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UIButton *)joinButton {
    if (!_joinButton) {
        _joinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_joinButton setTitle:@"Join" forState:UIControlStateNormal];
        [_joinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_joinButton setBackgroundColor:[CMColor completedTaskColor]];
        _joinButton.layer.cornerRadius = 4;
        _joinButton.layer.masksToBounds = YES;
        [_joinButton addTarget:self action:@selector(didTapToJoin) forControlEvents:UIControlEventTouchUpInside];
    }
    return _joinButton;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelButton setBackgroundColor:[CMColor completedTaskColor]];
        _cancelButton.layer.cornerRadius = 4;
        _cancelButton.layer.masksToBounds = YES;
        [_cancelButton addTarget:self action:@selector(didTapToDismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

@end
