//
//  PairedDevicesTVC.h
//  KBeaconDemo_Ios
//
//  Created by Azhar on 3/4/22.
//  Copyright © 2022 hogen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PairedDevicesTVC : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblBeaconDeviceName;
@property (weak, nonatomic) IBOutlet UILabel *lblPercentage;
@property (weak, nonatomic) IBOutlet UILabel *lblDensity;
@property (weak, nonatomic) IBOutlet UIView *vBackground;

@property (nonatomic, copy) void(^unPairButtonTapHandler)(void);
@property (nonatomic, copy) void(^ringDotButtonTapHandler)(void);

@end

NS_ASSUME_NONNULL_END
