//
//  FriendsTVC.m
//  KBeaconDemo_Ios
//
//  Created by Azhar on 3/7/22.
//  Copyright © 2022 hogen. All rights reserved.
//

#import "FriendsTVC.h"

@implementation FriendsTVC

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)btnOptions_Clicked:(id)sender {
    self.optionTapHandler(); 
}

@end
