//
//  DeviceViewController.h
//  KBeaconDemo
//
//  Created by kkm on 2018/12/9.
//  Copyright © 2018 kkm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KBeaconsMgr.h>
#import <KBeacon.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreMotion/CoreMotion.h>


@class UserLocation;

NS_ASSUME_NONNULL_BEGIN

@interface DeviceViewController : UIViewController<ConnStateDelegate, UITextFieldDelegate, KBNotifyDataDelegate, KBeaconMgrDelegate, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tvBLEDevices;
@property (weak, nonatomic) IBOutlet UITableView *tvAvailableDOTS;
@property (weak, nonatomic) IBOutlet UITableView *tvFriends;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *actionConnect;

@property (weak, nonatomic) IBOutlet UILabel *labelModel;

@property (weak, nonatomic) IBOutlet UILabel *labelVersion;

@property (weak, nonatomic) IBOutlet UITextField *txtName;

@property (weak, nonatomic) IBOutlet UITextField *txtTxPower;

@property (weak, nonatomic) IBOutlet UITextField *txtAdvPeriod;

@property (weak, nonatomic) IBOutlet UITextField *txtBeaconUUID;

@property (weak, nonatomic) IBOutlet UITextField *txtBeaconMajor;

@property (weak, nonatomic) IBOutlet UITextField *txtBeaconMinor;

@property (weak, nonatomic) IBOutlet UITextView *txtBeaconStatus;

@property (weak, nonatomic) IBOutlet UILabel *labelBeaconType;

@property (weak, nonatomic) IBOutlet UILabel *mLabelHardwareVersion;

@property (weak, nonatomic) KBeacon* beacon;

@property (nonatomic) BOOL isFirstTime;


@property (nonatomic,strong) CLLocationManager * locationManger;
@property (weak, nonatomic) IBOutlet UIView *gMapView;

@property (weak, nonatomic) IBOutlet UILabel *lblConnectedDeviceName;
@property (weak, nonatomic) IBOutlet UILabel *lblConnectedDeviceStatus;
@property (weak, nonatomic) IBOutlet UIView *vTopDeviceStatus;

@property (weak, nonatomic) IBOutlet UIView *vMessagePopUp;
@property (weak, nonatomic) IBOutlet UIButton *btnMessageOK;
@property (weak, nonatomic) IBOutlet UIView *vMessageInner;
@property (weak, nonatomic) IBOutlet UIStackView *vDOTSView;
@property (weak, nonatomic) IBOutlet UIView *vDevicesPanel;
@property (weak, nonatomic) IBOutlet UIButton *btnScan;
@property (weak, nonatomic) IBOutlet UIImageView *imgScan;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorScan;
@property (weak, nonatomic) IBOutlet UIView *vFriends;
@property (weak, nonatomic) IBOutlet UIStackView *vFriendsOuter;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *friendTVHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *availableDotsHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *connectedDotsHeightConstraint;

@property (nonatomic, strong) CMMotionActivityManager *motionActivitiyManager;

@property (weak, nonatomic) IBOutlet UIView *vAddNewFriend;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addNewFriendHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *imgActivity;

@end

NS_ASSUME_NONNULL_END
