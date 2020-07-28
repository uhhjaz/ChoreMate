//
//  JoinHouseholdViewController.h
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/28/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JoinHouseholdControllerDelegate

- (void)didJoinHousehold;

@end

@interface JoinHouseholdViewController : UIViewController

@property (nonatomic, weak) id<JoinHouseholdControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
