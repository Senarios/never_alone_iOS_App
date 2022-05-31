//
//  PairedDevicesTVC.m
//  KBeaconDemo_Ios
//
//  Created by Azhar on 3/4/22.
//  Copyright © 2022 hogen. All rights reserved.
//

#import "PairedDevicesTVC.h"

@implementation PairedDevicesTVC

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)UnPair_Clicked:(id)sender {
    self.unPairButtonTapHandler();
}
- (IBAction)ringDot_Clicked:(id)sender {
    self.ringDotButtonTapHandler();
}

@end
