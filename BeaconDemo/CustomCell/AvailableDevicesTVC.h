//
//  AvailableDevicesTVC.h
//  KBeaconDemo_Ios
//
//  Created by Azhar on 3/4/22.
//  Copyright © 2022 hogen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AvailableDevicesTVC : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbDeviceName;
@property (weak, nonatomic) IBOutlet UIView *vBackground;
@property (nonatomic, copy) void(^pairButtonTapHandler)(void);
@end

NS_ASSUME_NONNULL_END
