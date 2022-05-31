//
//  AvailableDevicesTVC.m
//  KBeaconDemo_Ios
//
//  Created by Azhar on 3/4/22.
//  Copyright © 2022 hogen. All rights reserved.
//

#import "AvailableDevicesTVC.h"

@implementation AvailableDevicesTVC

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)Pair_Clicked:(id)sender {
    NSLog(@"Pair_Clicked");
    self.pairButtonTapHandler();
}

@end
