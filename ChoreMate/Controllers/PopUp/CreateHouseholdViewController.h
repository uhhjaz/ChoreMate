//
//  CreateHouseholdViewController.h
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/27/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CreateHouseholdControllerDelegate

- (void)didCreateHousehold;

@end

@interface CreateHouseholdViewController : UIViewController

@property (nonatomic, weak) id<CreateHouseholdControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
