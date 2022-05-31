//
//  beaconDeviceCell.h
//  KBeaconDemo_Ios
//
//  Created by Azhar on 2/15/22.
//  Copyright © 2022 hogen. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "KBeaconLib/KBeacon.h"

NS_ASSUME_NONNULL_BEGIN

@interface beaconDeviceCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblDeviceName;
@property (weak, nonatomic) KBeacon *beacon;

@end

NS_ASSUME_NONNULL_END
