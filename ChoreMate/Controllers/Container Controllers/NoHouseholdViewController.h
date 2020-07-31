//
//  NoHouseholdViewController.h
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/27/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol NoHouseholdControllerDelegate

- (void)didFinishGettingAHousehold;

@end

@interface NoHouseholdViewController : UIViewController

@property (nonatomic, weak) id<NoHouseholdControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
