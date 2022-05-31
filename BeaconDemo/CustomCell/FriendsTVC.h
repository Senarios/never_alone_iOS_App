//
//  FriendsTVC.h
//  KBeaconDemo_Ios
//
//  Created by Azhar on 3/7/22.
//  Copyright © 2022 hogen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FriendsTVC : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgFriend;
@property (weak, nonatomic) IBOutlet UILabel *lblFriendName;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UILabel *vSeperator;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UIImageView *imgMenu;
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;

@property (nonatomic, copy) void(^optionTapHandler)(void);
@end

NS_ASSUME_NONNULL_END
