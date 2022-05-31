//
//  KBAppDelegate.m
//  kbeaconlib
//
//  Created by hogen on 11/01/2020.
//  Copyright (c) 2020 hogen. All rights reserved.
//

#import "KBAppDelegate.h"
@import GoogleMaps;
@import Firebase;

#define App_Bar_Color [UIColor colorWithRed:42/255.0 green:42/255.0 blue:42/255.0 alpha:1.0]
#define App_Text_Color [UIColor whiteColor]

@implementation KBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[NSUserDefaults standardUserDefaults] setObject:@"FOREGROUND" forKey:@"APP_STATE"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [GMSServices provideAPIKey:@"AIzaSyANMiDUXZwmkrit4L4loU1U2ruBLsLCubo"];
    // AIzaSyDyZsahU0speDtF_cwBjUIH2ew6DMwg_oc
    [self registerForRemoteNotifications];
    
    [FIRApp configure];
    
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert
    | UIUserNotificationTypeBadge | UIUserNotificationTypeSound
                                     categories:nil];
    
    [application registerUserNotificationSettings:settings];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    printf("applicationWillResignActive ......");
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    printf("Application enetr in background ....");
    [[NSUserDefaults standardUserDefaults] setObject:@"BACKGROUND" forKey:@"APP_STATE"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    printf("Application enetr in Foreground ....");
    [[NSUserDefaults standardUserDefaults] setObject:@"FOREGROUND" forKey:@"APP_STATE"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    printf("applicationDidBecomeActive ...... ");
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    printf("applicationWillTerminate");
}

- (void)registerForRemoteNotifications {
    if([[UIDevice currentDevice] systemVersion] > 10){
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
             if(!error){
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [[UIApplication sharedApplication] registerForRemoteNotifications];
                 });
             }
         }];
    }
    else {
        // Code for old versions
    }
}

@end
