//
//  KBAppDelegate.h
//  kbeaconlib
//
//  Created by hogen on 11/01/2020.
//  Copyright (c) 2020 hogen. All rights reserved.
//

@import UIKit;
#import <UserNotifications/UserNotifications.h>

@interface KBAppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
