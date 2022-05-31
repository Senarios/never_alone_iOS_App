//
//  DeviceViewController.m
//  KBeaconDemo
//
//  Created by kkm on 2018/12/9.
//  Copyright © 2018 kkm. All rights reserved.
//

#import "DeviceViewController.h"
#import "KBeacon.h"
#import "string.h"
#import "KBPreferance.h"
#import <KBCfgIBeacon.h>
#import <KBCfgTrigger.h>
#import "KBDFUViewController.h"
#import "KBHTSensorHandler.h"
#import <UTCTime.h>
#import "CfgSensorDataHistoryController.h"
#import "KBNotifyButtonEvtData.h"
#import "KBeaconViewCell.h"
#import "beaconDeviceCell.h"
//#import "KBeaconDemo_Ios-Swift.h"
#import "KBeaconDemo-Swift.h"
//#import <BeaconDemo-Swift.h>

#import "AvailableDevicesTVC.h"
#import "PairedDevicesTVC.h"
#import "FriendsTVC.h"

#import <KBeaconsMgr.h>
#import <KBAdvPacketIBeacon.h>
#import <KBAdvPacketSensor.h>





#define ACTION_CONNECT 0x0
#define ACTION_DISCONNECT 0x1
#define TXT_DATA_MODIFIED 0x1

@interface DeviceViewController ()
{
//only for beacon that has humidity sensor
    KBHTSensorHandler*  htSensorHandler;
    
    NSMutableDictionary *mBeaconsDictory;
    
    NSArray* mBeaconsArray;
    
    NSMutableArray* mBeaconsPairedDOTS;
    
    NSMutableArray* friendsDataArray;
    
    KBeaconsMgr *mBeaconsMgr;
    
    KBPreferance* mBeaconPref;
    
}
@end

@implementation DeviceViewController

    GMSMapView * _mapView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isFirstTime = YES;
    
    [self.actionConnect setTitle: BEACON_CONNECT];
    [self.actionConnect setTag:ACTION_CONNECT];
    mBeaconsPairedDOTS = [[NSMutableArray alloc] init];
    friendsDataArray = [[NSMutableArray alloc] init];
    
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
//    [self.view addGestureRecognizer:tap];
    
    self.txtName.delegate = self;
    self.txtTxPower.delegate = self;
    self.txtAdvPeriod.delegate = self;
    self.txtBeaconUUID.delegate = self;
    self.txtBeaconMajor.delegate = self;
    self.txtBeaconMinor.delegate = self;
    
    self.tvBLEDevices.delegate = self;
    self.tvBLEDevices.dataSource = self;
    
    self.tvAvailableDOTS.delegate = self;
    self.tvAvailableDOTS.dataSource = self;
    
    self.tvFriends.delegate = self;
    self.tvFriends.dataSource = self;
    
    //beacon list
    mBeaconsDictory = [[NSMutableDictionary alloc]initWithCapacity:50];
    
    //init kbeacon manager
    mBeaconsMgr = [KBeaconsMgr sharedBeaconManager];
    mBeaconsMgr.delegate = self;
    
    mBeaconPref = [KBPreferance sharedManager];
    
    mBeaconsArray = [[NSMutableArray alloc]init];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TRACKERS_DATA" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TRACKERS_DATA_Called:) name:@"TRACKERS_DATA" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TRACKERS_DELETED" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TRACKERS_DELETED:) name:@"TRACKERS_DELETED" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DISCONNECT_DOT" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DISCONNECT_DOT:) name:@"DISCONNECT_DOT" object:nil];
    
   // [self.vDOTSView setHidden:YES];
    [self.vDevicesPanel setHidden:YES];
    [self.vTopDeviceStatus setHidden:YES];
    [self.vFriends setHidden:YES];
    [self.vFriendsOuter setHidden:YES];
    
 //   [self onDeviceStartScanning];
    [self onTrackingLocation];
 //   UserLocation *objLocation = [UserLocation new];
 //    [objLocation GetTrackerData];
    
    [self.vMessagePopUp setHidden:YES];
    self.vMessageInner.layer.borderColor = [UIColor colorWithRed:19/255.0
                                                           green:237/255.0
                                                            blue:84/255.0
                                                           alpha:1].CGColor;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        NSLog(@"onDeviceStartScanning 1");
        UserLocation *objLocation = [UserLocation new];
        [objLocation GetAccountInfo];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        NSLog(@"onDeviceStartScanning 1");
        [self onDeviceStartScanning];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        NSLog(@"onDeviceStartScanning 2");
        [self onDeviceStartScanning];
    });
    
  //  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 4 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    //    NSLog(@"GetTrackerData 2");
       // [self CallTrackerAPI];
      //  UserLocation *objLocation = [UserLocation new];
       // [objLocation GetTrackerData];
//    });
    
    NSString *USER_TYPE = [[NSUserDefaults standardUserDefaults] stringForKey:@"USER_TYPE"];
    
    if([USER_TYPE isEqual:@"CHILD"]){
        [self.vAddNewFriend setHidden:YES];
        [self.addNewFriendHeightConstraint setConstant:0];
    }
    
    NSString *LOCATION_UPDATE = [[NSUserDefaults standardUserDefaults] stringForKey:@"LOCATION_UPDATE"];
    if ([LOCATION_UPDATE isEqual:@"YES"])
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 4 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            UserLocation *objLocation = [UserLocation new];
            [objLocation UpdateLocation];
        });
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 6 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self CallTrackerAPI];
    });

    
    if ([CMMotionActivityManager isActivityAvailable]) {
            self.motionActivitiyManager = [[CMMotionActivityManager alloc] init];
            [self.motionActivitiyManager startActivityUpdatesToQueue:[[NSOperationQueue alloc] init]
                                                  withHandler:
             ^(CMMotionActivity *activity) {


             dispatch_async(dispatch_get_main_queue(), ^{
                 if ([activity stationary]) {
                     NSLog(@"Stationary");
                     [self.imgActivity setImage:[UIImage imageNamed:@"still"]];
                     [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"CURRENT_Activity"];
                     [[NSUserDefaults standardUserDefaults] synchronize];
                 }
                 else if ([activity walking]) {
                     NSLog(@"Walking");
                     [self.imgActivity setImage:[UIImage imageNamed:@"walking"]];
                     [[NSUserDefaults standardUserDefaults] setObject:@"3" forKey:@"CURRENT_Activity"];
                     [[NSUserDefaults standardUserDefaults] synchronize];
                 }
                 else if ([activity running]) {
                     NSLog(@"Running");
                     [self.imgActivity setImage:[UIImage imageNamed:@"running"]];
                     [[NSUserDefaults standardUserDefaults] setObject:@"5" forKey:@"CURRENT_Activity"];
                     [[NSUserDefaults standardUserDefaults] synchronize];
                 }
                 else if ([activity automotive]) {
                     [self.imgActivity setImage:[UIImage imageNamed:@"vehicle"]];
                     [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"CURRENT_Activity"];
                     [[NSUserDefaults standardUserDefaults] synchronize];
                     NSLog(@"Vehicle");
                 }
                 else if ([activity cycling]) {
                     [self.imgActivity setImage:[UIImage imageNamed:@"cycle"]];
                     [[NSUserDefaults standardUserDefaults] setObject:@"4" forKey:@"CURRENT_Activity"];
                     [[NSUserDefaults standardUserDefaults] synchronize];
                     NSLog(@"Cycling");
                 }
                 else {
                     NSLog(@"Unknown");
                 }
             });
         }];
    }
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval: 60.0
                          target: self
                          selector:@selector(onTick:)
                          userInfo: nil repeats:YES];
//    UserLocation *objLocation = [UserLocation new];
//    [objLocation TrackerAlert];
    
 //   htSensorHandler = [[KBHTSensorHandler alloc]init];
 //   htSensorHandler.mBeacon = self.beacon;
  //  [self performSegueWithIdentifier:@"CallViewController" sender:self];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        NSLog(@"GetTrackerData viewWillAppear 2");
        [self CallTrackerAPI];
    });
}

-(void)onTick:(NSTimer*)timer
{
    NSLog(@"Tick...");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
      //  NSLog(@"Time Inter");
        [self CallTrackerAPI];
    });
    
    NSString *LOCATION_UPDATE = [[NSUserDefaults standardUserDefaults] stringForKey:@"LOCATION_UPDATE"];
    if ([LOCATION_UPDATE isEqual:@"YES"])
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 4 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            UserLocation *objLocation = [UserLocation new];
            [objLocation UpdateLocation];
        });
    }
}

- (void)TRACKERS_DATA_Called:(NSNotification *)notification {
    NSLog(@"notification");
    
    NSArray * friendsData = notification.object;
    NSLog(friendsData);
}

- (void)TRACKERS_DELETED:(NSNotification *)notification {
    NSLog(@"notification Tracker deleted");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        NSLog(@"CallTrackerAPI 2");
        [self CallTrackerAPI];
    });
}

- (void)DISCONNECT_DOT:(NSNotification *)notification {
    NSLog(@"Disconnect Dot ........");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"CONNECTED_DEVICE"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self Disconnect_Clicked];
        [mBeaconsPairedDOTS removeAllObjects];
        [self.tvBLEDevices reloadData];
    });
}

- (void)onTrackingLocation{
    NSLog(@"onTrackingLocation 1");
   // if([self.locationManger locationServicesEnabled]){
        NSLog(@"onTrackingLocation 2");
        self.locationManger = [[CLLocationManager alloc] init];
        self.locationManger.delegate = self;
        self.locationManger.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManger.allowsBackgroundLocationUpdates = YES;
        self.locationManger.pausesLocationUpdatesAutomatically = NO;
        [self.locationManger requestAlwaysAuthorization];
        [self.locationManger startUpdatingLocation];
//    }
}

-(void)UpdateMapWithFriendsPINs{
    
    NSString *CURRENT_LATITUDE = [[NSUserDefaults standardUserDefaults] stringForKey:@"CURRENT_LATITUDE"];
    NSString *CURRENT_LONGITUDE = [[NSUserDefaults standardUserDefaults] stringForKey:@"CURRENT_LONGITUDE"];
    
    
    
    if(CURRENT_LATITUDE == nil){
        return;
    }
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[CURRENT_LATITUDE doubleValue]
                                                              longitude:[CURRENT_LONGITUDE doubleValue]
                                                                   zoom:8];
    GMSMapView *mapView = [GMSMapView mapWithFrame:self.gMapView.frame camera:camera];
    mapView.myLocationEnabled = YES;
//    mapView.settings.myLocationButton = YES;
//    mapView.settings.compassButton = YES;
    
    
    
    for (id objFriend in friendsDataArray) {
        NSDictionary* friendData = (NSDictionary*)objFriend;
        NSString *name = [friendData objectForKey:@"Name"];
        NSString *dateString = [friendData objectForKey:@"LastReported"];
        NSString *Photo = [friendData objectForKey:@"Photo"];
        NSString *Latitude = [friendData objectForKey:@"Latitude"];
        NSString *Longitude = [friendData objectForKey:@"Longitude"];
        if(Longitude != nil && Longitude != [NSNull null]){
            NSLog(@"Longitude is nil");

            //    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(31.467526, 74.304373);
            //    GMSMarker *marker = [GMSMarker markerWithPosition:position];
            //    marker.title = @"Hello World";
            //    marker.map = mapView;
            //
            //    CLLocationCoordinate2D position2 = CLLocationCoordinate2DMake(31.417526, 74.404373);
            //    GMSMarker *marker2 = [GMSMarker markerWithPosition:position2];
            //    marker2.title = @"Hello World 2";
            //    marker2.map = mapView;
            double lat = [Latitude doubleValue];
            double lon = [Longitude doubleValue];
            
            if ([Latitude rangeOfString:@"S"].location != NSNotFound) {
                lat = lat * -1;
            }
            if ([Longitude rangeOfString:@"W"].location != NSNotFound) {
                lon = lon * -1;
            }
            
            CLLocationCoordinate2D position3 = CLLocationCoordinate2DMake(lat, lon);
            GMSMarker *marker3 = [GMSMarker markerWithPosition:position3];
            marker3.title = [NSString stringWithFormat:@"%@", name];
          //  marker3.map = mapView;
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0,90,60)];
           // view.backgroundColor = UIColor.redColor;
            int ImageAddHeight = 0;
            UIImageView *pinImageView =[[UIImageView alloc] initWithFrame:CGRectMake(20,( ImageAddHeight),60,60)];
            pinImageView.image=[UIImage imageNamed:@"map_pin"];
            pinImageView.contentMode = UIViewContentModeScaleAspectFit;
            
            int ImageHeight = 45;
            UIImageView *userImageView =[[UIImageView alloc] initWithFrame:CGRectMake(28,(8+ImageAddHeight),ImageHeight,ImageHeight)];
            userImageView.image=[UIImage imageNamed:@"person_avatar"];
            userImageView.layer.cornerRadius = ImageHeight/2;
            userImageView.layer.masksToBounds = YES;
            userImageView.contentMode = UIViewContentModeScaleAspectFit;
            
            dispatch_async(dispatch_get_global_queue(0,0), ^{
                NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: Photo]];
                if ( data == nil )
                    return;
                dispatch_async(dispatch_get_main_queue(), ^{
                    userImageView.image = [UIImage imageWithData: data];
                });
            });

//          UILabel *label = [UILabel new];
//          label.text = @"AS";
//          //label.font = ...;
//          [label sizeToFit];

            [view addSubview:pinImageView];
            [view addSubview:userImageView];
            
            marker3.iconView = view;
            marker3.tracksViewChanges = YES;
            marker3.map = mapView;
        }
        [self.gMapView addSubview:mapView];
       // NSLog(@"%@ -- %@ -- %@", name, dateString, Photo);
        
    }
}

-(void)CallTrackerAPI{
    NSString *APIKEY = [[NSUserDefaults standardUserDefaults] stringForKey:@"TOKEN"];
    int *TRACKER_ID = [[NSUserDefaults standardUserDefaults] integerForKey:@"TRACKER_ID"];
    if(APIKEY == nil){
        return;
    }
    NSDictionary *headers = @{ @"apiKey": APIKEY};
    
    NSString *urlData = [NSString stringWithFormat: @"https://globotrac-api-dev.azurewebsites.net/trackers?tracker_id=%i", TRACKER_ID];
    NSLog(@"URL:%@", urlData);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlData]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if(httpResponse.statusCode == 200)
        {
            NSError *parseError = nil;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            NSLog(@"The response is - %@",responseDictionary);
            
            NSArray *timestamps = [responseDictionary valueForKey:@"trackers"];
            NSLog(@"The response Array is - %@",timestamps);
            
            friendsDataArray = [NSMutableArray arrayWithArray:timestamps];
            
            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.friendTVHeightConstraint setConstant:friendsDataArray.count * 65];
                [self.tvFriends reloadData];
                [self UpdateMapWithFriendsPINs];
            });
            
            
            NSInteger success = [[responseDictionary objectForKey:@"success"] integerValue];
            if(success == 1)
            {
                NSLog(@"Login SUCCESS");
            }
            else
            {
                NSLog(@"Login FAILURE");
            }
        }
        else
        {
            NSLog(@"Error: %@", error);
        }
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        NSLog(@"%@", httpResponse);
                                                    }
                                                }];
    [dataTask resume];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations{

    CLLocation *newLocation = locations.lastObject;
  //  NSLog(@"UpdatedLocation %@", [locations lastObject]);
    NSLog(@"UpdatedLocation %f, %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    
    NSString *latitudeValue = [NSString stringWithFormat:@"%f", newLocation.coordinate.latitude];
    [[NSUserDefaults standardUserDefaults] setObject:latitudeValue forKey:@"CURRENT_LATITUDE"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *longitudeValue = [NSString stringWithFormat:@"%f", newLocation.coordinate.longitude];
    [[NSUserDefaults standardUserDefaults] setObject:longitudeValue forKey:@"CURRENT_LONGITUDE"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if(self.isFirstTime){
        self.isFirstTime = NO;
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:newLocation.coordinate.latitude
                                                                  longitude:newLocation.coordinate.longitude
                                                                       zoom:8];
        GMSMapView *mapView = [GMSMapView mapWithFrame:self.gMapView.frame camera:camera];
        mapView.myLocationEnabled = YES;
    //    mapView.settings.myLocationButton = YES;
    //    mapView.settings.compassButton = YES;
        
    /*    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(31.467526, 74.304373);
        GMSMarker *marker = [GMSMarker markerWithPosition:position];
        marker.title = @"Hello World";
        marker.map = mapView;
        
        CLLocationCoordinate2D position2 = CLLocationCoordinate2DMake(31.417526, 74.404373);
        GMSMarker *marker2 = [GMSMarker markerWithPosition:position2];
        marker2.title = @"Hello World 2";
        marker2.map = mapView;
        
        CLLocationCoordinate2D position3 = CLLocationCoordinate2DMake(31.497526, 74.604373);
        GMSMarker *marker3 = [GMSMarker markerWithPosition:position3];
        marker3.title = @"Hello World 3";
      //  marker3.map = mapView;
        
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0,100,100)];
        UIImageView *pinImageView =[[UIImageView alloc] initWithFrame:CGRectMake(5,5,90,90)];
        pinImageView.image=[UIImage imageNamed:@"add_friend"];
        pinImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        UIImageView *userImageView =[[UIImageView alloc] initWithFrame:CGRectMake(10,10,70,70)];
        userImageView.image=[UIImage imageNamed:@"person_avatar"];
        userImageView.layer.cornerRadius = 35;
        userImageView.layer.masksToBounds = YES;
        userImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        dispatch_async(dispatch_get_global_queue(0,0), ^{
                NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: @"https://globotracphoto.blob.core.windows.net/dev/5969.jpg"]];
                if ( data == nil )
                    return;
                dispatch_async(dispatch_get_main_queue(), ^{
                    userImageView.image = [UIImage imageWithData: data];
                });

            });
        
    
        
            UILabel *label = [UILabel new];
            label.text = @"AS";
            //label.font = ...;
            [label sizeToFit];

            [view addSubview:pinImageView];
            [view addSubview:userImageView];
        
        marker3.iconView = view;
        marker3.tracksViewChanges = YES;
        marker3.map = mapView;*/
        
        [self.gMapView addSubview:mapView];
        
//        _mapView = [GMSMapView mapWithFrame:self.gMapView.frame camera:camera];
//        _mapView.myLocationEnabled = YES;
//        self.view = _mapView;
        
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"failed to fetch current location : %@", error);
}

- (void)onDeviceStartScanning {
    
 //   if ([self.actionButton.title isEqualToString:ACTION_START_SCAN])
  //  {
        int nStartScan = [mBeaconsMgr startScanning];
        if (nStartScan == 0)
        {
            NSLog(@"start scan success");
         //   self.actionButton.title = ACTION_STOP_SCAN;
        }
        else if (nStartScan == SCAN_ERROR_BLE_NOT_ENABLE) {
            [self showMsgDlog:@"error" message:@"BLE function is not enable"];

        }
        else if (nStartScan == SCAN_ERROR_NO_PERMISSION) {
            [self showMsgDlog:@"error" message:@"BLE scanning has no location permission"];
        }
        else
        {
     //       [self showMsgDlog:@"error" message:@"BLE scanning unknown error"];
        }
 //   }
  /*  else
    {
        [mBeaconsMgr stopScanning];
      //  self.actionButton.title = ACTION_START_SCAN;
    }*/
}

-(void)showMsgDlog:(NSString*)strTitle message:(NSString*)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:ERR_TITLE message:ERR_BLE_FUNC_OFF preferredStyle:UIAlertControllerStyleAlert];
      UIAlertAction *OkAction = [UIAlertAction actionWithTitle:DLG_OK style:UIAlertActionStyleDestructive handler:nil];
      [alertController addAction:OkAction];
      [self presentViewController:alertController animated:YES completion:nil];
}

-(void)onBeaconDiscovered:(NSArray<KBeacon*>*)beacons
{
    KBeacon* pBeacon = nil;
    KBeacon* pConnectedBeacon = nil;
    NSString *CONNECTED_DEVICE = [[NSUserDefaults standardUserDefaults] stringForKey:@"CONNECTED_DEVICE"];
    
    [self.indicatorScan stopAnimating];
    [self.imgScan setHidden:NO];
    [self.btnScan setHidden:NO];
    
    for (int i = 0; i < beacons.count; i++)
    {
        pBeacon = [beacons objectAtIndex:i];
        
        [mBeaconsDictory setObject:pBeacon forKey:pBeacon.UUIDString];
        if([CONNECTED_DEVICE isEqualToString:pBeacon.name]){
            pConnectedBeacon = pBeacon;
        }
        /*
         //filter iBeacon packet
        if ([pBeacon getAdvPacketByType:KBAdvTypeIBeacon] > 0)
        {
            [mBeaconsDictory setObject:pBeacon forKey:pBeacon.UUIDString];
        }*/
    }
    if (pConnectedBeacon != nil){
        _beacon = pConnectedBeacon;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self Connect_Clicked];
        });
    }
    mBeaconsArray = [mBeaconsDictory allValues];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.availableDotsHeightConstraint setConstant:mBeaconsArray.count * 57];
    });
    
    [self.tvBLEDevices reloadData];      // mBeaconsPairedDOTS
    [self.tvAvailableDOTS reloadData];   // mBeaconsArray
  //  [self.tvFriends reloadData];
}

-(void)onCentralBleStateChange:(BLECentralMgrState)newState
{
    if (newState == BLEStatePowerOn)
    {
        //the app can start scan in this case
        NSLog(@"central ble state power on");
    }
}

-(IBAction)backToParentView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    self.beacon.delegate = nil;
    [self.beacon disconnect];
}

-(void)tap
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

-(void)updateActionButton
{
    if (_beacon.state == KBStateConnected)
    {
        [_actionConnect setTitle:BEACON_DISCONNECT];
        _actionConnect.tag = ACTION_DISCONNECT;
    }
    else
    {
        [_actionConnect setTitle:BEACON_CONNECT];
        _actionConnect.tag = ACTION_CONNECT;
    }
}

-(void)onConnStateChange:(KBeacon*)beacon state:(KBConnState)state evt:(KBConnEvtReason)evt;
{
    if (state == KBStateConnecting)
    {
        NSLog(@"Connecting to device.............");
        self.txtBeaconStatus.text = @"Connecting to device";
    }
    else if (state == KBStateConnected)
    {
        NSLog(@"Device connected.............");
        self.txtBeaconStatus.text = @"Device connected";
       // [self ShowAlert:@"Connected"];
        [[NSUserDefaults standardUserDefaults] setObject:beacon.name forKey:@"CONNECTED_DEVICE"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        self.lblConnectedDeviceName.text = [beacon.name stringByReplacingOccurrencesOfString:@"KBeacon_"
                                                                                    withString:@""];
        [self.vTopDeviceStatus setHidden:NO];
        
        // To fill Paired devices list
        if(mBeaconsPairedDOTS.count == 0){
            [mBeaconsPairedDOTS addObject:beacon];
            [self.tvBLEDevices reloadData];
        }
        if(mBeaconsArray.count > 0){
            NSMutableArray *modifyableArray = [[NSMutableArray alloc] initWithArray:mBeaconsArray];
            
        
            int index = -1;
            for (int i=0;i<modifyableArray.count; i++) {
                if(((KBeacon*)modifyableArray[i]).name == beacon.name){
                    
                    index = i;
                }
            }
            if(index >= 0){
                [modifyableArray removeObjectAtIndex:index];
            }
            mBeaconsArray = [[NSArray alloc] initWithArray:modifyableArray];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.availableDotsHeightConstraint setConstant:mBeaconsArray.count * 57];
            });
            
        //    [modifyableArray removeObjectAtIndex:index];
          //  [mBeaconsArray removeObject: beacon];
            [self.tvAvailableDOTS reloadData];
        }
        
        
        // [self updateDeviceToView];
        [self EnableTriggerLongPress];
    }
    else if (state == KBStateDisconnected)
    {
        NSLog(@"Device disconnected.............");
        self.txtBeaconStatus.text = @"Device disconnected";
        [self.vTopDeviceStatus setHidden:YES];
        
            
        
        
        if (evt == KBEvtConnAuthFail)
        {
            NSLog(@"auth failed");
            [self showPasswordInputDlg];
        }
    }
    
    [self updateActionButton];
}

-(void) showPasswordInputDlg
{
    UIAlertController *alertDlg = [UIAlertController alertControllerWithTitle:@"Auth fail" message:@"Please input beacon password" preferredStyle:UIAlertControllerStyleAlert];
    [alertDlg addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"password: 8~16 characteristics";
    }];
    [alertDlg addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [alertDlg addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        NSArray * arr = alertDlg.textFields;
        UITextField * field = arr[0];
        
        KBPreferance* pref = [KBPreferance sharedManager];
        [pref saveBeaconPassword:self.beacon.UUIDString pwd:field.text];
        
        KBConnPara* connPara = [[KBConnPara alloc]init];
        connPara.utcTime = [UTCTime getUTCTimeSecond];
        [self.beacon connectEnhanced:field.text timeout:20 para:connPara];
     }]];
    
    [self presentViewController:alertDlg animated:YES completion:nil];
}

-(void)updateDeviceToView
{
    KBCfgCommon* pCommonCfg = (KBCfgCommon*)[self.beacon getConfigruationByType:KBConfigTypeCommon];
    if (pCommonCfg != nil)
    {
        NSLog(@"support iBeacon:%@", [pCommonCfg isSupportIBeacon]?@"1":@"0");
        NSLog(@"support eddy url:%@", [pCommonCfg isSupportEddyURL]?@"1":@"0");
        NSLog(@"support eddy tlm:%@", [pCommonCfg isSupportEddyTLM]?@"1":@"0");
        NSLog(@"support eddy uid:%@", [pCommonCfg isSupportEddyUID]?@"1":@"0");
        NSLog(@"support ksensor:%@", [pCommonCfg isSupportKBSensor]?@"1":@"0");
        NSLog(@"support has button:%@", [pCommonCfg isSupportButton]?@"1":@"0");
        NSLog(@"support beep:%@", [pCommonCfg isSupportBeep]?@"1":@"0");
        NSLog(@"support accleration:%@", [pCommonCfg isSupportAccSensor]?@"1":@"0");
        NSLog(@"support humidify:%@", [pCommonCfg isSupportHumiditySensor]?@"1":@"0");
        NSLog(@"support max tx power:%d", [pCommonCfg.maxTxPower intValue]);
        NSLog(@"support min tx power:%d", [pCommonCfg.minTxPower intValue]);
        
        self.labelBeaconType.text = pCommonCfg.advTypeString;
        self.txtName.text = pCommonCfg.name;
        self.labelModel.text = pCommonCfg.model;
        self.labelVersion.text = pCommonCfg.version;
        self.txtTxPower.text = [pCommonCfg.txPower stringValue];
        self.txtAdvPeriod.text = [pCommonCfg.advPeriod stringValue];
        self.mLabelHardwareVersion.text = pCommonCfg.hversion;
        
        KBCfgIBeacon* pIBeacon = (KBCfgIBeacon*)[self.beacon getConfigruationByType:KBConfigTypeIBeacon];
        if (pIBeacon != nil)
        {
            self.txtBeaconUUID.text = pIBeacon.uuid;
            self.txtBeaconMajor.text = [pIBeacon.majorID stringValue];
            self.txtBeaconMinor.text = [pIBeacon.minorID stringValue];
        }
    }
}

- (IBAction)onActionItemClick:(id)sender {
    [self onDeviceStartScanning];
 /*   if (_actionConnect.tag == ACTION_CONNECT)
    {
        _beacon.delegate = self;
        KBPreferance* pref = [KBPreferance sharedManager];
        NSString* beaconPwd = [pref getBeaconPassword: _beacon.UUIDString];
        
        KBConnPara* connPara = [[KBConnPara alloc]init];
        connPara.utcTime = [UTCTime getUTCTimeSecond];
        [self.beacon connectEnhanced:beaconPwd timeout:20 para:connPara];
        
        [_actionConnect setTitle:BEACON_DISCONNECT];
        _actionConnect.tag = ACTION_DISCONNECT;
    }
    else
    {
        [_beacon disconnect];
        
        [_actionConnect setTitle:BEACON_CONNECT];
        _actionConnect.tag = ACTION_CONNECT;
    }*/
}

- (void)Connect_Clicked {
    
    _beacon.delegate = self;
    KBPreferance* pref = [KBPreferance sharedManager];
    NSString* beaconPwd = [pref getBeaconPassword: _beacon.UUIDString];
    
    KBConnPara* connPara = [[KBConnPara alloc]init];
    connPara.utcTime = [UTCTime getUTCTimeSecond];
    [self.beacon connectEnhanced:beaconPwd timeout:20 para:connPara];
    
    [_actionConnect setTitle:BEACON_DISCONNECT];
    _actionConnect.tag = ACTION_DISCONNECT;
}

- (void)Disconnect_Clicked {
    [_beacon disconnect];

    [_actionConnect setTitle:BEACON_CONNECT];
    _actionConnect.tag = ACTION_CONNECT;
}

//update device para from UI
-(void)updateViewToDevice
{
    if (_beacon.state != KBStateConnected)
    {
        NSLog(@"beacon not connected");
        return;
    }
    
    KBCfgIBeacon* pIBeaconCfg = [[KBCfgIBeacon alloc]init];
    KBCfgCommon* pCommonCfg = [[KBCfgCommon alloc]init];
    
    @try {
        
        //set beacon type to iBeacon
        pCommonCfg.advType = [NSNumber numberWithInt: KBAdvTypeIBeacon];
        
        //device name
        if (_txtName.tag == TXT_DATA_MODIFIED)
        {
            pCommonCfg.name = _txtName.text;
        }
        
        //tx power
        if (_txtTxPower.tag == TXT_DATA_MODIFIED)
        {
            int nTxPower = [_txtTxPower.text intValue];
            
            if (nTxPower > [_beacon.maxTxPower intValue]
                || nTxPower < [_beacon.minTxPower intValue])
            {
                [self showDialogMsg:@"error" message: @"Tx power is invalid"];
                return;
            }
            
            pCommonCfg.txPower = [NSNumber numberWithInt:nTxPower];
        }
        
        //set adv period
        if (_txtAdvPeriod.tag == TXT_DATA_MODIFIED)
        {
            if ([_txtAdvPeriod.text floatValue] < 100.0
                || [_txtAdvPeriod.text floatValue] > 10000.0)
            {
                [self showDialogMsg:@"error" message: @"adv period is invalid"];
                return;
            }
            
            pCommonCfg.advPeriod = [NSNumber numberWithFloat:[_txtAdvPeriod.text floatValue]];
        }
        
        //modify ibeacon uuid
        if (_txtBeaconUUID.tag == TXT_DATA_MODIFIED)
        {
            if (![KBUtility isUUIDString:_txtBeaconUUID.text])
            {
                [self showDialogMsg:@"error" message: @"UUID data length invalid"];
                return;
            }
                
            pIBeaconCfg.uuid = _txtBeaconUUID.text;
        }
        
        //modify ibeacon major id
        if (_txtBeaconMajor.tag == TXT_DATA_MODIFIED)
        {
            if ([_txtBeaconMajor.text intValue] > 65535)
            {
                [self showDialogMsg:@"error" message: @"major id data invalid"];
                return;
            }
            pIBeaconCfg.majorID = [NSNumber numberWithInt:[_txtBeaconMajor.text intValue]];
        }
        
        //modify ibeacon minor
        if (_txtBeaconMinor.tag == TXT_DATA_MODIFIED)
        {
            if ([_txtBeaconMinor.text intValue] > 65535)
            {
                [self showDialogMsg:@"error" message: @"minor id data invalid"];
                return;
            }
            pIBeaconCfg.minorID = [NSNumber numberWithInt:[_txtBeaconMinor.text intValue]];
        }
    }
    @catch (KBException *exception)
    {
        NSString* errorInfo = [NSString stringWithFormat:@"input paramaters invalid:%ld",
                               (long)exception.errorCode];
        [self showDialogMsg: @"error" message: errorInfo];
        return;
    }
    
    
    NSArray* configParas = @[pCommonCfg, pIBeaconCfg];
    
    //start configruation
    [_beacon modifyConfig:configParas callback:^(BOOL bCfgRslt, NSError* error)
     {
         if (bCfgRslt)
         {
             [self showDialogMsg: @"Success" message: @"config beacon success"];
         }
         else if (error != nil)
         {
             if (error.code == KBEvtCfgBusy)
             {
                 NSLog(@"Config busy, please make sure other configruation complete");
             }
             else if (error.code == KBEvtCfgTimeout)
             {
                 NSLog(@"Config timeout");
             }
             [self showDialogMsg:@"Failed" message:[NSString stringWithFormat:@"config error:%@",error.localizedDescription]];
         }
     }];
}

//example1: modify KBeacon common para
-(void)updateKBeaconCommonPara
{
    if (_beacon.state != KBStateConnected)
    {
        NSLog(@"beacon not connected");
        return;
    }

    KBCfgCommon* pCommonPara = [[KBCfgCommon alloc]init];

    //change the device name
    pCommonPara.name = @"MyBeacon";

    //change the tx power
    pCommonPara.txPower = [NSNumber numberWithInt:-4];
    
    //change advertisement period
    pCommonPara.advPeriod = [NSNumber numberWithFloat:1000.0];

    //set the device to un-connectable.
    //Warning: if the app set the KBeacon to un-connectable, the app can not connect to it if it does not has button.
    //If the device has button, the device can enter connect-able advertisement for 60 seconds when click on the button
    pCommonPara.advConnectable = [NSNumber numberWithBool:NO];

    //set device to always power on
    //the autoAdvAfterPowerOn is enable, the device will not allowed power off by long press button
    pCommonPara.autoAdvAfterPowerOn = [NSNumber numberWithBool:YES];

    //update password.
    //Warnning: Be sure to remember the new password, you won’t be able to connect to the device if you forget it.
    //pCommonPara.password = @"123456789";

    //start configruation
    NSArray* configParas = @[pCommonPara];
    [_beacon modifyConfig:configParas callback:^(BOOL bCfgRslt, NSError* error)
     {
         if (bCfgRslt)
         {
             [self showDialogMsg: @"Success" message: @"config beacon success"];
         }
         else if (error != nil)
         {
             [self showDialogMsg:@"Failed" message:[NSString stringWithFormat:@"config error:%@",error.localizedDescription]];
         }
     }];
}

//example2: update KBeacon to iBeacon
-(void)updateKBeaconToIBeacon
{
    if (_beacon.state != KBStateConnected)
    {
        NSLog(@"beacon does not connected");
        return;
    }

    KBCfgIBeacon* pIBeaconCfg = [[KBCfgIBeacon alloc]init];
    KBCfgCommon* pCommonCfg = [[KBCfgCommon alloc]init];

    //update beacon type to hybid iBeacon/TLM
    pCommonCfg.advType = [NSNumber numberWithInt: KBAdvTypeIBeacon];

    //update iBeacon paramaters
    pIBeaconCfg.uuid = @"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0";
    pIBeaconCfg.majorID = [NSNumber numberWithInt: 6454];
    pIBeaconCfg.minorID = [NSNumber numberWithInt: 1458];

    //start configruation
    NSArray* configParas = @[pCommonCfg, pIBeaconCfg];
    [_beacon modifyConfig:configParas callback:^(BOOL bCfgRslt, NSError* error)
     {
         if (bCfgRslt)
         {
             [self showDialogMsg: @"Success" message: @"config beacon success"];
         }
         else if (error != nil)
         {
             [self showDialogMsg:@"Failed" message:[NSString stringWithFormat:@"config error:%@",error.localizedDescription]];
         }
     }];
}

//example3: update KBeacon to hybid iBeacon/EddyTLM
-(void)updateKBeaconToIBeaconAndTLM
{
    if (_beacon.state != KBStateConnected)
    {
        NSLog(@"beacon not connected");
        return;
    }

    KBCfgIBeacon* pIBeaconCfg = [[KBCfgIBeacon alloc]init];
    KBCfgCommon* pCommonCfg = [[KBCfgCommon alloc]init];

    //update beacon type to hybid iBeacon/TLM
    pCommonCfg.advType = [NSNumber numberWithInt: KBAdvTypeIBeacon | KBAdvTypeEddyTLM];

    //updatet KBeacon send TLM packet every 8 advertisement packets
    pCommonCfg.tlmAdvInterval = [NSNumber numberWithInt:8];

    //update iBeacon paramaters
    pIBeaconCfg.uuid = @"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0";
    pIBeaconCfg.majorID = [NSNumber numberWithInt: 6454];
    pIBeaconCfg.minorID = [NSNumber numberWithInt: 1458];

    //start configruation
    NSArray* configParas = @[pCommonCfg, pIBeaconCfg];
    [_beacon modifyConfig:configParas callback:^(BOOL bCfgRslt, NSError* error)
     {
         if (bCfgRslt)
         {
             [self showDialogMsg: @"Success" message: @"config beacon success"];
         }
         else if (error != nil)
         {
             [self showDialogMsg:@"Failed" message:[NSString stringWithFormat:@"config error:%@",error.localizedDescription]];
         }
     }];
}

//example4: update KBeacon to Eddy URL
-(void)updateKBeaconToEddyURL
{
    if (_beacon.state != KBStateConnected)
    {
        NSLog(@"beacon not connected");
        return;
    }
    
    KBCfgCommon* pCommonPara = [[KBCfgCommon alloc]init];
    KBCfgEddyURL* pEddyUrlPara = [[KBCfgEddyURL alloc]init];

        
    //set beacon type to URL
    pCommonPara.advType = [NSNumber numberWithInt: KBAdvTypeEddyURL];
        
    //set address to google
    pEddyUrlPara.url = @"https://www.google.com/";
    
    //start configruation
    NSArray* configParas = @[pCommonPara, pEddyUrlPara];
    [_beacon modifyConfig:configParas callback:^(BOOL bCfgRslt, NSError* error)
     {
         if (bCfgRslt)
         {
             [self showDialogMsg: @"Success" message: @"config beacon success"];
         }
         else if (error != nil)
         {
             [self showDialogMsg:@"Failed" message:[NSString stringWithFormat:@"config error:%@",error.localizedDescription]];
         }
     }];
}

//example5: update KBeacon to UID
-(void)updateKBeaconToEddyUID
{
    if (_beacon.state != KBStateConnected)
    {
        NSLog(@"beacon not connected");
        return;
    }
    
    KBCfgCommon* pCommonPara = [[KBCfgCommon alloc]init];
    KBCfgEddyUID* pEddyUIDPara = [[KBCfgEddyUID alloc]init];
    
    //set beacon type to UID
    pCommonPara.advType = [NSNumber numberWithInt:  KBAdvTypeEddyUID];
    
    //update UID para
    pEddyUIDPara.nid = @"0x00010203040506070809";
    pEddyUIDPara.sid = @"0x010203040506";
    
    //start configruation
    NSArray* configParas = @[pCommonPara, pEddyUIDPara];
    [_beacon modifyConfig:configParas callback:^(BOOL bCfgRslt, NSError* error)
     {
         if (bCfgRslt)
         {
             [self showDialogMsg: @"Success" message: @"config beacon success"];
         }
         else if (error != nil)
         {
             [self showDialogMsg:@"Failed" message:[NSString stringWithFormat:@"config error:%@",error.localizedDescription]];
         }
     }];
}

//example6: modify KBeacon password
-(void)updateBeaconPassword
{
    if (_beacon.state != KBStateConnected)
    {
        NSLog(@"beacon not connected");
        return;
    }
    
    KBCfgCommon* pCommonPara = [[KBCfgCommon alloc]init];
    
    //the password length must >=8 bytes and <= 16 bytes
    //Be sure to remember your new password, if you forget it, you won’t be able to connect to it.
    pCommonPara.password = @"123456789";
    
    //start configruation
    NSArray* configParas = @[pCommonPara];
    [_beacon modifyConfig:configParas callback:^(BOOL bCfgRslt, NSError* error)
     {
         if (bCfgRslt)
         {
             [self showDialogMsg: @"Success" message: @"modify password success"];
         }
         else if (error != nil)
         {
             [self showDialogMsg:@"Failed" message:[NSString stringWithFormat:@"modify passwor failed"]];
         }
     }];
}

- (IBAction)onStartConfig:(id)sender {
    if (self.beacon.state != KBStateConnected){
     //   [self showDialogMsg:ERR_TITLE message:ERR_BEACON_NOT_CONNECTED];
        return;
    }
    
    [self updateViewToDevice];
}

- (IBAction)onEnableButtonTrigger:(id)sender
{
    if (self.beacon.state != KBStateConnected){
   //     [self showDialogMsg:ERR_TITLE message:ERR_BEACON_NOT_CONNECTED];
        return;
    }
    
    //[self enableButtonTrigger];
    [self enableBtnTriggerEvtToApp];
}

- (void)EnableTriggerLongPress
{
    if (self.beacon.state != KBStateConnected){
   //     [self showDialogMsg:ERR_TITLE message:ERR_BEACON_NOT_CONNECTED];
        return;
    }
    
    //[self enableButtonTrigger];
    [self enableBtnTriggerEvtToApp];
}

- (void)EnableDoubleClickTrigger
{
    if (self.beacon.state != KBStateConnected){
    //    [self showDialogMsg:ERR_TITLE message:ERR_BEACON_NOT_CONNECTED];
        return;
    }
    
    //[self enableButtonTrigger];
    [self enableBtnDoubleClickTriggerEvtToApp];
}

//enable button trigger event to advertisement
-(void)enableButtonTrigger
{
    NSLog(@"Enable Button Trigger ......");
    
    if (self.beacon.state != KBStateConnected){
        NSLog(@"device does not connected");
        return;
    }
    
    //check if device can support button trigger capibility
    if (([self.beacon.triggerCapibility intValue] & KBTriggerTypeButton) == 0)
    {
        [self showDialogMsg: @"Fail" message: @"device does not support button trigger"];
        return;
    }
    
    KBCfgTrigger* btnTriggerPara = [[KBCfgTrigger alloc]init];
    
    //set trigger type
    btnTriggerPara.triggerType = [NSNumber numberWithInt: KBTriggerTypeButton];
    
    //set trigger advertisement enable
    btnTriggerPara.triggerAction = [NSNumber numberWithInt: KBTriggerActionAdv];

    //set trigger adv mode to adv only on trigger
    btnTriggerPara.triggerAdvMode = [NSNumber numberWithInt:KBTriggerAdvOnlyMode];
    
    //set trigger button para
    btnTriggerPara.triggerPara = [NSNumber numberWithInt: (KBTriggerBtnSingleClick | KBTriggerBtnDoubleClick)];
    
    //set trigger adv type
    btnTriggerPara.triggerAdvType = [NSNumber numberWithInt:KBAdvTypeIBeacon];
    
    //set trigger adv duration to 20 seconds
    btnTriggerPara.triggerAdvTime = [NSNumber numberWithInt: 20];

    //set the trigger adv interval to 500ms
    btnTriggerPara.triggerAdvInterval = [NSNumber numberWithFloat: 500];
    
    [self.beacon modifyTriggerConfig:btnTriggerPara callback:^(BOOL bConfigSuccess, NSError * _Nonnull error) {
        if (bConfigSuccess)
        {
            NSLog(@"modify btn trigger success");
        }
        else
        {
            NSLog(@"modify btn trigger fail:%ld", (long)error.code);
        }
    }];
}


//enable button press trigger event to app when KBeacon was connected
//Requre the KBeacon firmware version >= 5.20
-(void)enableBtnTriggerEvtToApp
{
    if (self.beacon.state != KBStateConnected){
        NSLog(@"device does not connected");
        return;
    }
    
    //check if device can support button trigger capibility
    if (([self.beacon.triggerCapibility intValue] & KBTriggerTypeButton) == 0)
    {
        [self showDialogMsg: @"Fail" message: @"device does not support button trigger"];
        return;
    }
    
    KBCfgTrigger* btnTriggerPara = [[KBCfgTrigger alloc]init];
    
    //set trigger type
    btnTriggerPara.triggerType = [NSNumber numberWithInt: KBTriggerTypeButton];
    
    //set trigger action to app
    //you can also set the trigger event to both app and advertisement.  (KBCfgTrigger.KBTriggerActionRptApp | KBCfgTrigger.KBTriggerActionAdv)
    btnTriggerPara.triggerAction = [NSNumber numberWithInt: KBTriggerActionRptApp];
    
    //set trigger button para
   // btnTriggerPara.triggerPara = [NSNumber numberWithInt: (KBTriggerBtnSingleClick | KBTriggerBtnDoubleClick)];
    btnTriggerPara.triggerPara = [NSNumber numberWithInt: (KBTriggerBtnHold)];
    
    
    
    
    [self.beacon modifyTriggerConfig:btnTriggerPara callback:^(BOOL bConfigSuccess, NSError * _Nonnull error) {
        if (bConfigSuccess)
        {
            NSLog(@"modify btn trigger success");
            
            //subscribe humidity notify
            if (![self.beacon isSensorDataSubscribe:KBNotifyButtonEvtData.class])
            {
                [self.beacon subscribeSensorDataNotify:KBNotifyButtonEvtData.class delegate:self callback:^(BOOL bConfigSuccess, NSError * _Nullable error) {
                        if (bConfigSuccess) {
                            NSLog(@"subscribe button trigger event success");
                        } else {
                            NSLog(@"subscribe button trigger event failed");
                        }
                }];
            }
        }
        else
        {
            NSLog(@"modify btn trigger fail:%ld", (long)error.code);
        }
    }];
}

-(void)enableBtnDoubleClickTriggerEvtToApp
{
    if (self.beacon.state != KBStateConnected){
        NSLog(@"device does not connected");
        return;
    }
    
    //check if device can support button trigger capibility
    if (([self.beacon.triggerCapibility intValue] & KBTriggerTypeButton) == 0)
    {
        [self showDialogMsg: @"Fail" message: @"device does not support button trigger"];
        return;
    }
    
    KBCfgTrigger* btnTriggerPara = [[KBCfgTrigger alloc]init];
    
    //set trigger type
    btnTriggerPara.triggerType = [NSNumber numberWithInt: KBTriggerTypeButton];
    
    //set trigger action to app
    //you can also set the trigger event to both app and advertisement.  (KBCfgTrigger.KBTriggerActionRptApp | KBCfgTrigger.KBTriggerActionAdv)
    btnTriggerPara.triggerAction = [NSNumber numberWithInt: KBTriggerActionRptApp];
    
    //set trigger button para
    btnTriggerPara.triggerPara = [NSNumber numberWithInt: (KBTriggerBtnSingleClick | KBTriggerBtnDoubleClick)];
    
    [self.beacon modifyTriggerConfig:btnTriggerPara callback:^(BOOL bConfigSuccess, NSError * _Nonnull error) {
        if (bConfigSuccess)
        {
            NSLog(@"modify btn trigger success");
            
            //subscribe humidity notify
            if (![self.beacon isSensorDataSubscribe:KBNotifyButtonEvtData.class])
            {
                [self.beacon subscribeSensorDataNotify:KBNotifyButtonEvtData.class delegate:self callback:^(BOOL bConfigSuccess, NSError * _Nullable error) {
                        if (bConfigSuccess) {
                            NSLog(@"subscribe button trigger event success");
                        } else {
                            NSLog(@"subscribe button trigger event failed");
                        }
                }];
            }
        }
        else
        {
            NSLog(@"modify btn trigger fail:%ld", (long)error.code);
        }
    }];
}

//enable button press trigger event for alarm
//Requre the KBeacon firmware version >= 5.20
-(void)enableBtnTriggerEvtToAlarm
{
    if (self.beacon.state != KBStateConnected){
        NSLog(@"device does not connected");
        return;
    }
    
    //check if device can support button trigger capibility
    if (([self.beacon.triggerCapibility intValue] & KBTriggerTypeButton) == 0)
    {
        [self showDialogMsg: @"Fail" message: @"device does not support button trigger"];
        return;
    }
    
    KBCfgTrigger* btnTriggerPara = [[KBCfgTrigger alloc]init];
    
    //set trigger type
    btnTriggerPara.triggerType = [NSNumber numberWithInt: KBTriggerTypeButton];
    
    //set trigger action to app
    //you can also set the trigger event to multiple action  (KBTriggerActionRptApp | KBTriggerActionAdv | KBTriggerActionAlert)
    btnTriggerPara.triggerAction = [NSNumber numberWithInt: KBTriggerActionAlert];
    
    //set trigger button para
    btnTriggerPara.triggerPara = [NSNumber numberWithInt: (KBTriggerBtnSingleClick | KBTriggerBtnDoubleClick)];
    
    [self.beacon modifyTriggerConfig:btnTriggerPara callback:^(BOOL bConfigSuccess, NSError * _Nonnull error) {
        if (bConfigSuccess)
        {
            NSLog(@"modify btn trigger success");
            
            //subscribe humidity notify
            if (![self.beacon isSensorDataSubscribe:KBNotifyButtonEvtData.class])
            {
                [self.beacon subscribeSensorDataNotify:KBNotifyButtonEvtData.class delegate:self callback:^(BOOL bConfigSuccess, NSError * _Nullable error) {
                        if (bConfigSuccess) {
                            NSLog(@"subscribe button trigger event success");
                        } else {
                            NSLog(@"subscribe button trigger event failed");
                        }
                }];
            }
        }
        else
        {
            NSLog(@"modify btn trigger fail:%ld", (long)error.code);
        }
    }];
}

//handle button trigger event
- (void)onNotifyDataReceived:(nonnull KBeacon *)beacon type:(int)dataType data:(nonnull KBNotifyDataBase *)data
{
    if (dataType != KBNotifyDataTypeButton)
    {
        return;
    }
    
    KBNotifyButtonEvtData* notifyData = (KBNotifyButtonEvtData*)data;
    
    int eventIDCode = [notifyData.buttonNtfEvent intValue];
    NSLog(@"Receive button trigger event:%d", eventIDCode);
    
    if(eventIDCode == 2){
      //  [self ShowAlert:@"Call Started"];
        NSString *APP_STATE = [[NSUserDefaults standardUserDefaults] stringForKey:@"APP_STATE"];
        NSLog(@"Call Started....... %@", APP_STATE);
        if([APP_STATE isEqualToString: @"BACKGROUND"]){
            UserLocation *objLocation = [UserLocation new];
           // [objLocation TrackerAlert];
            [objLocation AddTrackerLocation];
        }
        else
        {
            UserLocation *objLocation = [UserLocation new];
           // [objLocation TrackerAlert];
            [objLocation AddTrackerLocation];
            [self performSegueWithIdentifier:@"CallViewController" sender:self];
        }
        
        [self EnableDoubleClickTrigger];
        
    }
    else if(eventIDCode == 4){
        NSString *APP_STATE = [[NSUserDefaults standardUserDefaults] stringForKey:@"APP_STATE"];
        NSLog(@"Call Ended....... %@", APP_STATE);
        if([APP_STATE isEqualToString: @"BACKGROUND"]){
            NSLog(@"Call Ended ....");
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DISCONNECT_CALL" object:@""];
            [self ShowAlert:@"Call Ended"];
        }
        [self EnableTriggerLongPress];
    }
    
}

//disable button trigger
- (IBAction)onDisableButtonTrigger:(id)sender {
    if (self.beacon.state != KBStateConnected){
        NSLog(@"device does not connected");
        return;
    }
    
    //check if device can support button trigger capibility
    if (([self.beacon.triggerCapibility intValue] & KBTriggerTypeButton) == 0)
    {
        [self showDialogMsg: @"Fail" message: @"device does not support button trigger"];
        return;
    }
    
    KBCfgTrigger* btnTriggerPara = [[KBCfgTrigger alloc]init];
    
    //set trigger type
    btnTriggerPara.triggerType = [NSNumber numberWithInt: KBTriggerTypeButton];
    
    //set trigger advertisement enable
    btnTriggerPara.triggerAction = [NSNumber numberWithInt: KBTriggerActionOff];
    
    [self.beacon modifyTriggerConfig:btnTriggerPara callback:^(BOOL bConfigSuccess, NSError * _Nonnull error) {
        if (bConfigSuccess)
        {
            NSLog(@"modify btn trigger success");
        }
        else
        {
            NSLog(@"modify btn trigger fail:%ld", (long)error.code);
        }
    }];
}


- (IBAction)onReadButtonTriggerPara:(id)sender {
    if (self.beacon.state != KBStateConnected){
       // [self showDialogMsg:ERR_TITLE message:ERR_BEACON_NOT_CONNECTED];
        return;
    }
    
    [self readButtonTriggerPara];
}

//read button trigger paramaters
-(void)readButtonTriggerPara
{
    if (self.beacon.state != KBStateConnected){
        NSLog(@"device does not connected");
        return;
    }
    
    //check if device can support button trigger capibility
    if (([self.beacon.triggerCapibility intValue] & KBTriggerTypeButton) == 0)
    {
        [self showDialogMsg: @"Fail" message: @"device does not support button trigger"];
        return;
    }
    
    [self.beacon readTriggerConfig:KBTriggerTypeButton callback:^(BOOL bConfigSuccess, NSDictionary * _Nullable readPara, NSError * _Nullable error) {
        if (bConfigSuccess)
        {
            NSArray* btnTriggerCfg = [readPara objectForKey:@"trObj"];
            if (btnTriggerCfg != nil)
            {
                KBCfgTrigger* btnCfg = [btnTriggerCfg objectAtIndex:0];
                NSLog(@"trigger type:%d", [btnCfg.triggerType intValue]);
                if ([btnCfg.triggerAction intValue] > 0)
                {
                    //button enable mask
                    int nButtonEnableInfo = [btnCfg.triggerPara intValue];
                    if ((nButtonEnableInfo & KBTriggerBtnSingleClick) > 0)
                    {
                        NSLog(@"Enable single click trigger");
                    }
                    if ((nButtonEnableInfo & KBTriggerBtnDoubleClick) > 0)
                    {
                        NSLog(@"Enable double click trigger");
                    }
                    if ((nButtonEnableInfo & KBTriggerBtnHold) > 0)
                    {
                        NSLog(@"Enable hold press trigger");
                    }
                    
                    //button trigger adv mode
                    if ([btnCfg.triggerAdvMode intValue] == KBTriggerAdvOnlyMode)
                    {
                        NSLog(@"device only advertisement when trigger event happened");
                    }
                    else if ([btnCfg.triggerAdvMode intValue] == KBTriggerAdv2AliveMode)
                    {
                        NSLog(@"device will always advertisement, but the uuid is difference when trigger event happened");
                    }
                                        
                    //button trigger adv type
                    NSLog(@"Button trigger adv type:%d", [btnCfg.triggerAdvType intValue]);
                    
                    //button trigger adv duration, uint is sec
                    NSLog(@"Button trigger adv duration:%dsec", [btnCfg.triggerAdvTime intValue]);

                    //button trigger adv interval, uint is ms
                    NSLog(@"Button trigger adv interval:%gms", [btnCfg.triggerAdvInterval floatValue]);
                }
                else
                {
                    NSLog(@"Button trigger disable");
                }
            }
        }
        else
        {
            NSLog(@"Button trigger failed, %ld", (long)error.code);
        }
    }];
}

- (IBAction)onEnableMotionTrigger:(id)sender {
    if (self.beacon.state != KBStateConnected){
        NSLog(@"device does not connected");
        return;
    }
    
    //check if device can support motion trigger capibility
    if (([self.beacon.triggerCapibility intValue] & KBTriggerTypeMotion) == 0)
    {
        [self showDialogMsg: @"Fail" message: @"device does not support motion trigger"];
        return;
    }
    
    KBCfgTrigger* motionTriggerPara = [[KBCfgTrigger alloc]init];
    
    //set trigger type
    motionTriggerPara.triggerType = [NSNumber numberWithInt: KBTriggerTypeMotion];
    
    //set trigger advertisement enable
    motionTriggerPara.triggerAction = [NSNumber numberWithInt: KBTriggerActionAdv];

    //set trigger adv mode to adv only on trigger
    motionTriggerPara.triggerAdvMode = [NSNumber numberWithInt:KBTriggerAdvOnlyMode];
    
    //set motion sensitivity (2~31)
    motionTriggerPara.triggerPara = [NSNumber numberWithInt: 5];
    
    //set trigger adv type
    motionTriggerPara.triggerAdvType = [NSNumber numberWithInt:KBAdvTypeIBeacon];
    
    //set trigger adv duration to 20 seconds
    motionTriggerPara.triggerAdvTime = [NSNumber numberWithInt: 20];

    //set the trigger adv interval to 500ms
    motionTriggerPara.triggerAdvInterval = [NSNumber numberWithFloat: 500];
    
    [self.beacon modifyTriggerConfig:motionTriggerPara callback:^(BOOL bConfigSuccess, NSError * _Nonnull error) {
        if (bConfigSuccess)
        {
            NSLog(@"modify motion trigger success");
        }
        else
        {
            NSLog(@"modify motion trigger fail:%ld", (long)error.code);
        }
    }];
}


- (IBAction)onDisableMotionTrigger:(id)sender {
    if (self.beacon.state != KBStateConnected){
        NSLog(@"device does not connected");
        return;
    }
    
    //check if device can support motion trigger capibility
    if (([self.beacon.triggerCapibility intValue] & KBTriggerTypeMotion) == 0)
    {
        [self showDialogMsg: @"Fail" message: @"device does not support motion trigger"];
        return;
    }
    
    KBCfgTrigger* motionTriggerPara = [[KBCfgTrigger alloc]init];
    
    //set trigger type
    motionTriggerPara.triggerType = [NSNumber numberWithInt: KBTriggerTypeMotion];
    
    //set trigger action off
    motionTriggerPara.triggerAction = [NSNumber numberWithInt: KBTriggerActionOff];
    
    [self.beacon modifyTriggerConfig:motionTriggerPara callback:^(BOOL bConfigSuccess, NSError * _Nonnull error) {
        if (bConfigSuccess)
        {
            NSLog(@"Disable motion trigger success");
        }
        else
        {
            NSLog(@"Disable motion trigger fail:%ld", (long)error.code);
        }
    }];
}

//The accelerometer can only be in one operating mode at the same time,
// detected X/Y/Z axis or detect motion, so please disable motion trigger before enable X/Y/Z axis detection
- (IBAction)onEnableAxisAdv:(id)sender {
    KBCfgCommon* oldCommCfg = (KBCfgCommon*)[self.beacon getConfigruationByType:KBConfigTypeCommon];
    KBCfgSensor* oldSensorCfg = (KBCfgSensor*)[self.beacon getConfigruationByType:KBConfigTypeSensor];
    if (![self.beacon isConnectable])
    {
        [self showDialogMsg:@"error" message:@"device does not connected"];
        return;
    }

    if (![oldCommCfg isSupportAccSensor])
    {
        [self showDialogMsg:@"error" message:@"Device does not supported acc sensor"];
        return;
    }
    
    NSMutableArray* cfgArray = [[NSMutableArray alloc]init];
    
    KBCfgCommon* pNewCommCfg = [[KBCfgCommon alloc]init];
    if (([oldCommCfg.advType intValue] & KBAdvTypeSensor) == 0)
    {
        [pNewCommCfg setAdvType:[NSNumber numberWithInt:KBAdvTypeSensor]];
        [cfgArray addObject:pNewCommCfg];
    }
    
    KBCfgSensor* newSensorCfg = [[KBCfgSensor alloc]init];
    if (([oldSensorCfg.sensorType intValue] & KBSensorTypeAcc) == 0)
    {
        [newSensorCfg setSensorType:[NSNumber numberWithInt:KBSensorTypeAcc]];
        [cfgArray addObject:newSensorCfg];
    }
    
    if (cfgArray.count > 0)
    {
        [self.beacon modifyConfig:cfgArray callback:^(BOOL bConfigSuccess, NSError * _Nullable error)
        {
            if (bConfigSuccess){
                NSLog(@"enable axis advertisement success");
            }else{
                NSLog(@"enable axis advertisement failed");
            }
        }];
    }
}


-(void)showDialogMsg:(NSString*)title message:(NSString*)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *OkAction = [UIAlertAction actionWithTitle:DLG_OK style:UIAlertActionStyleDestructive handler:nil];
    [alertController addAction:OkAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *deviceController = segue.destinationViewController;
    if ([deviceController isKindOfClass:KBDFUViewController.class])
    {
        KBDFUViewController* cfgCtrl = (KBDFUViewController*)deviceController;
        cfgCtrl.beacon = self.beacon;
    }
    else if ([deviceController isKindOfClass:CfgSensorDataHistoryController.class])
    {
        CfgSensorDataHistoryController* cfgCtrl = (CfgSensorDataHistoryController*)deviceController;
        cfgCtrl.beacon = self.beacon;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //tag means data was change
    textField.tag = TXT_DATA_MODIFIED;
    
    return YES;
}


- (IBAction)onTHLogData2Adv:(id)sender {
    
    if (self.beacon.state != KBStateConnected)
    {
        NSLog(@"Device is not connected");
        return;
    }

    KBCfgCommon* commCfg = (KBCfgCommon*)[self.beacon getConfigruationByType:KBConfigTypeCommon];
    if (![commCfg isSupportHumiditySensor])
    {
        NSLog(@"Device not support humidity sensor");
        return;
    }
    
    
    [htSensorHandler enableTHRealtimeDataToAdv];
}


- (IBAction)onThLogData2App:(id)sender {
    if (self.beacon.state != KBStateConnected)
    {
        NSLog(@"Device is not connected");
        return;
    }

    KBCfgCommon* commCfg = (KBCfgCommon*)[self.beacon getConfigruationByType:KBConfigTypeCommon];
    if (![commCfg isSupportHumiditySensor])
    {
        NSLog(@"Device not support humidity sensor");
        return;
    }
    
    
    [htSensorHandler enableTHRealtimeDataToApp];
    
}

- (IBAction)onTHLogViewHistory:(id)sender {
    if (self.beacon.state != KBStateConnected)
    {
    //    [self showDialogMsg:ERR_TITLE message:ERR_BEACON_NOT_CONNECTED];
        return;
    }
    
    KBCfgCommon* commCfg = (KBCfgCommon*)[self.beacon getConfigruationByType:KBConfigTypeCommon];
    if (![commCfg isSupportHumiditySensor])
    {
        NSLog(@"Device not support humidity sensor");
        return;
    }

    [self performSegueWithIdentifier:@"seqShowHistory" sender:self];
}

- (IBAction)onTHTrigger2Adv:(id)sender {
    if (self.beacon.state != KBStateConnected)
    {
        NSLog(@"Device is not connected");
        return;
    }

    KBCfgCommon* commCfg = (KBCfgCommon*)[self.beacon getConfigruationByType:KBConfigTypeCommon];
    if (![commCfg isSupportHumiditySensor])
    {
        NSLog(@"Device not support humidity sensor");
        return;
    }
    
    [htSensorHandler enableTHTriggerEvtRpt2Adv];
}

- (IBAction)onTHTriggerEvt2App:(id)sender {
    if (self.beacon.state != KBStateConnected)
    {
        NSLog(@"Device is not connected");
        return;
    }

    KBCfgCommon* commCfg = (KBCfgCommon*)[self.beacon getConfigruationByType:KBConfigTypeCommon];
    if (![commCfg isSupportHumiditySensor])
    {
        NSLog(@"Device not support humidity sensor");
        return;
    }
    
    [htSensorHandler enableTHTriggerEvtRpt2App];
}

-(void) ringDevice
{
//    if (self.beacon.state != KBStateConnected){
//        return;
//    }
    
    if (self.beacon.state != KBStateConnected){
        [self showDialogMsg:ERR_TITLE message:ERR_BEACON_NOT_CONNECTED];
        return;
    }
    
    KBCfgCommon* cfgCommon = (KBCfgCommon*)[self.beacon getConfigruationByType:KBConfigTypeCommon];
    if (![cfgCommon isSupportBeep])
    {
        [self showDialogMsg: @"Fail" message: @"device does not support beep"];
        return;
    }

    NSMutableDictionary* paraDicts = [[NSMutableDictionary alloc]init];

    [paraDicts setValue:@"ring" forKey:@"msg"];

    //ring times, unit is ms
    [paraDicts setValue:[NSNumber numberWithInt:5000] forKey:@"ringTime"];

    //0x0:led flash only; 0x1:beep alert only; 0x2 led flash and beep alert;
    [paraDicts setValue:[NSNumber numberWithInt:3] forKey:@"ringType"];

    //led flash on time. valid when ringType set to 0x0 or 0x2
    [paraDicts setValue:[NSNumber numberWithInt:200] forKey:@"ledOn"];

    //led flash off time. valid when ringType set to 0x0 or 0x2
    [paraDicts setValue:[NSNumber numberWithInt:1800] forKey:@"ledOff"];

    [self.beacon sendCommand:paraDicts callback:^(BOOL bConfigSuccess, NSError * _Nonnull error)
    {
        if (bConfigSuccess)
        {
            NSLog(@"send ring command to device success");
        }
        else
        {
            NSLog(@"send ring command to device failed");
        }
    }];
}

- (IBAction)onRingDevice:(id)sender
{
    if (self.beacon.state != KBStateConnected){
    //    [self showDialogMsg:ERR_TITLE message:ERR_BEACON_NOT_CONNECTED];
        return;
    }
    
    KBCfgCommon* cfgCommon = (KBCfgCommon*)[self.beacon getConfigruationByType:KBConfigTypeCommon];
    if (![cfgCommon isSupportBeep])
    {
        [self showDialogMsg: @"Fail" message: @"device does not support beep"];
        return;
    }

    NSMutableDictionary* paraDicts = [[NSMutableDictionary alloc]init];

    [paraDicts setValue:@"ring" forKey:@"msg"];
    
    //ring times, uint is ms
    [paraDicts setValue:[NSNumber numberWithInt:10000] forKey:@"ringTime"];
    
    //0x0:led flash only; 0x1:beep alert only; 0x2 led flash and beep alert;
    [paraDicts setValue:[NSNumber numberWithInt:2] forKey:@"ringType"];
    
    //led flash on time. valid when ringType set to 0x0 or 0x2
    [paraDicts setValue:[NSNumber numberWithInt:200] forKey:@"ledOn"];

    //led flash off time. valid when ringType set to 0x0 or 0x2
    [paraDicts setValue:[NSNumber numberWithInt:1800] forKey:@"ledOff"];

    [self.beacon sendCommand:paraDicts callback:^(BOOL bConfigSuccess, NSError * _Nonnull error)
    {
        if (bConfigSuccess)
        {
            NSLog(@"send ring command to device success");
        }
        else
        {
            NSLog(@"send ring command to device failed");
        }
    }];
}

- (IBAction)onDFUClick:(id)sender
{
    if (self.beacon.state != KBStateConnected)
    {
    //    [self showDialogMsg:ERR_TITLE message:ERR_BEACON_NOT_CONNECTED];
        return;
    }
    //only NRF52xx series support DFU
    if ([self.beacon.model containsString:@"NRF52XX"]
        && self.beacon.hardwareVersion != nil
        && self.beacon.version != nil)
    {
        [self performSegueWithIdentifier:@"seqKBeaconDFU" sender:self];
    }
    else
    {
        [self showDialogMsg:@"DFU" message:@"Device does not support DFU"];
    }
}
- (IBAction)SOS_CALL_Clicked:(id)sender {
    NSLog(@"SOS_CALL_Clicked");
    UserLocation *objLocation = [UserLocation new];
   // [objLocation TrackerAlert];
    [objLocation AddTrackerLocation];
    [self performSegueWithIdentifier:@"CallViewController" sender:self];

    [self EnableDoubleClickTrigger];
   // [self.vMessagePopUp setHidden:NO];
}

- (IBAction)Friends_Clicked:(id)sender {
    NSLog(@"Friends_Clicked");
    NSString *USER_TYPE = [[NSUserDefaults standardUserDefaults] stringForKey:@"USER_TYPE"];
    NSString *SECURITY_MODE = [[NSUserDefaults standardUserDefaults] stringForKey:@"SECURITY_MODE"];
    
    if([USER_TYPE isEqual:@"CHILD"] && [SECURITY_MODE isEqual:@"2"]){
        [self.vDevicesPanel setHidden:YES];
        [self.vFriends setHidden:!self.vFriends.isHidden];
        [self.vFriendsOuter setHidden:!self.vFriendsOuter.isHidden];
    }
    else if ([USER_TYPE isEqual:@"PARENT"]){
        [self.vDevicesPanel setHidden:YES];
        [self.vFriends setHidden:!self.vFriends.isHidden];
        [self.vFriendsOuter setHidden:!self.vFriendsOuter.isHidden];
    }
    
    
}

- (IBAction)Device_Clicked:(id)sender {
    [self.vFriends setHidden:YES];
    [self.vFriendsOuter setHidden:YES];
    [self.vDevicesPanel setHidden:!self.vDevicesPanel.isHidden];
}
- (IBAction)Menu_Clicked:(id)sender {
  //  NSLog(@"Menu_Clicked");
  //  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"Home_To_UserProfile" sender:self];
 //   });
    
}

- (IBAction)DeviceInfo_Clicked:(id)sender {
    NSLog(@"DeviceInfo_Clicked");
}
- (IBAction)OK_Message_Clicked:(id)sender {
    [self.vMessagePopUp setHidden:YES];
}
- (IBAction)Close_DOTS_Clicked:(id)sender {
    [self.vDevicesPanel setHidden:YES];
}
- (IBAction)Scan_Clicked:(id)sender {
    NSLog(@"DeviceInfo_Clicked");
    [self.indicatorScan startAnimating];
    [self.imgScan setHidden:YES];
    [self.btnScan setHidden:YES];
    
    [self onDeviceStartScanning];
    
}
- (IBAction)AddFriend_Clicked:(id)sender {
    [self performSegueWithIdentifier:@"Home_To_InviteFriend" sender:self];
}

- (IBAction)Close_Friends_Clicked:(id)sender {
    [self.vFriends setHidden:YES];
    [self.vFriendsOuter setHidden:YES];
}




//set parameter to default
- (IBAction)onResetParametersToDefault:(id)sender {
    if (self.beacon.state != KBStateConnected){
        NSLog(@"device does not connected");
        return;
    }

    NSMutableDictionary* paraDicts = [[NSMutableDictionary alloc]init];
    [paraDicts setValue:@"reset" forKey:@"msg"];
    [self.beacon sendCommand:paraDicts callback:^(BOOL bConfigSuccess, NSError * _Nonnull error)
    {
        if (bConfigSuccess)
        {
            [self.beacon disconnect];
            NSLog(@"send reset command to device success");
        }
        else
        {
            NSLog(@"send reset command to device failed");
        }
    }];
}

-(NSString*)getRemaningTime:(NSDate*)startDate endDate:(NSDate*)endDate
{
    NSDateComponents *components;
    NSInteger days;
    NSInteger hour;
    NSInteger minutes;
    NSString *durationString = @"0 minutes";

    components = [[NSCalendar currentCalendar] components: NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate: startDate toDate: endDate options: 0];

    days = [components day];
    hour = [components hour];
    minutes = [components minute];

    if(days>0)
    {
        if(days>1)
            durationString=[NSString stringWithFormat:@"%d days",days];
        else
            durationString=[NSString stringWithFormat:@"%d day",days];
        return durationString;
    }
    if(hour>0)
    {
        if(hour>1)
            durationString=[NSString stringWithFormat:@"%d hours",hour];
        else
            durationString=[NSString stringWithFormat:@"%d hour",hour];
        return durationString;
    }
    if(minutes>0)
    {
        if(minutes>1)
            durationString = [NSString stringWithFormat:@"%d minutes",minutes];
        else
            durationString = [NSString stringWithFormat:@"%d minute",minutes];

        return durationString;
    }
    return durationString;
}

-(int)getRemaningTimeValue:(NSDate*)startDate endDate:(NSDate*)endDate
{
    NSDateComponents *components;
    NSInteger days;
    NSInteger hour;
    NSInteger minutes;
    int durationValue = 0;

    components = [[NSCalendar currentCalendar] components: NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate: startDate toDate: endDate options: 0];

    days = [components day];
    hour = [components hour];
    minutes = [components minute];

    if(days>0)
    {
        return days * 24 * 60;
    }
    if(hour>0)
    {
        return hour * 60;
    }
    if(minutes>0)
    {
        return minutes;
    }
    return durationValue;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tvFriends){
        return friendsDataArray.count;
    }
    else if (tableView == self.tvAvailableDOTS){
        return mBeaconsArray.count;
    }
    else
    {
        return mBeaconsPairedDOTS.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.tvFriends){
        static NSString * cellIdentifier = @"FriendsTVC";
        FriendsTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        NSDictionary* friendData = [friendsDataArray objectAtIndex: indexPath.row];
        if (cell == nil)
        {
            return nil;
        }
        NSString *name = [friendData objectForKey:@"Name"];
        NSString *dateString = [friendData objectForKey:@"LastReported"];
        NSString *Photo = [friendData objectForKey:@"Photo"];
        NSString *Activity = [NSString stringWithFormat:@"%@", [friendData objectForKey:@"Activity"]];
        
        NSString *lActivity = @"None";
        if([Activity isEqual:@"0"]){
            lActivity = @"Still";
        }
        else if([Activity isEqual:@"1"]){
            lActivity = @"Still";
        }
        else if([Activity isEqual:@"2"]){
            lActivity = @"In Vehicle";
        }
        else if([Activity isEqual:@"3"]){
            lActivity = @"Walking";
        }
        else if([Activity isEqual:@"4"]){
            lActivity = @"Bicycle";
        }
        else if([Activity isEqual:@"5"]){
            lActivity = @"Running";
        }
        
        
        NSString * AccountID = [NSString stringWithFormat:@"%@", [friendData objectForKey:@"Tracker_ID"]] ;
        int userAccountID = [[NSUserDefaults standardUserDefaults] integerForKey:@"TRACKER_ID"];
        NSString * userAccountNo = [NSString stringWithFormat:@"%d", userAccountID] ;
        //"2000-01-01T00:00:00"
       // NSString *dateString =  @"2014-10-07T07:29:55.850Z";
        
        NSDate *today = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        NSDate *date = [dateFormatter dateFromString:dateString];
        NSLog(@"DAte: %@", date);
        
        NSTimeInterval secondsBetween = [today timeIntervalSinceDate:date];

        int numberOfDays = secondsBetween / 86400;

        NSLog(@"There are %d days in between the two dates.", numberOfDays);
        int totalMinutes = [self getRemaningTimeValue:date endDate:today];
        NSString *actualTime = [self getRemaningTime:date endDate:today];
        if (AccountID == userAccountNo){
            cell.lblFriendName.text = [NSString stringWithFormat:@"(me) (%@)", lActivity];
            [cell.imgMenu setHidden:YES];
            [cell.btnMenu setHidden:YES];
        }
        else
        {
            cell.lblFriendName.text = [NSString stringWithFormat:@"%@ (%@)", name, lActivity];
        }
        if(totalMinutes > 20){
            cell.lblTime.text = [NSString stringWithFormat:@"%@ ago", actualTime];
            cell.lblTime.textColor = UIColor.redColor;
            cell.lblStatus.text = @"Offline";
            cell.lblStatus.textColor = UIColor.redColor;
            cell.vSeperator.textColor = UIColor.redColor;
        }
        else
        {
            cell.lblTime.text = [NSString stringWithFormat:@"%@ ago", actualTime];
            cell.lblTime.textColor = UIColor.greenColor;
            cell.lblStatus.text = @"Online";
            cell.lblStatus.textColor = UIColor.greenColor;
            cell.vSeperator.textColor = UIColor.greenColor;
        }
        
        NSString *USER_TYPE = [[NSUserDefaults standardUserDefaults] stringForKey:@"USER_TYPE"];
        if (![USER_TYPE isEqual:@"PARENT"])
        {
            [cell.imgMenu setHidden:YES];
            [cell.btnMenu setHidden:YES];
        }
        
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: Photo]];
            if ( data == nil )
                return;
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.imgFriend.image = [UIImage imageWithData: data];
            });

        });
        
    //    cell.lblTime.textColor = UIColor.redColor;
     //   cell.lblStatus.textColor = UIColor.redColor;
        
     //   cell.vSeperator.textColor = UIColor.redColor;
        
        //
        cell.optionTapHandler = ^{
            UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

            [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {

                // Cancel button tappped do nothing.
                [self dismissViewControllerAnimated:YES completion:^{
                        }];

            }]];

            [actionSheet addAction:[UIAlertAction actionWithTitle:@"Delete Member" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSLog(@"Delete Member: %@", AccountID);
                
                UserLocation *objLocation = [UserLocation new];
               // [objLocation TrackerAlert];
                //[objLocation AddTrackerLocation];
                [objLocation DeleteTrackerWithTrackerId:AccountID];
                
                // take photo button tapped.
            }]];
            [self presentViewController:actionSheet animated:YES completion:nil];
        };
        return cell;
    }
    else if (tableView == self.tvAvailableDOTS){
        if (indexPath.row > mBeaconsArray.count)
        {
            return nil;
        }
        
        static NSString * cellIdentifier = @"AvailableDevicesTVC";
        AvailableDevicesTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            return nil;
        }
        
        KBeacon* pBeacons = [mBeaconsArray objectAtIndex: indexPath.row];
        if (pBeacons == nil)
        {
            return nil;
        }
        
        //device name
        if (pBeacons.name != nil){
            cell.lbDeviceName.text = [pBeacons.name stringByReplacingOccurrencesOfString:@"KBeacon_"
                                                                    withString:@""];
        }else{
            cell.lbDeviceName.text = @"N/A";
        }
        cell.vBackground.backgroundColor = [[UIColor alloc]initWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1.0];
        cell.pairButtonTapHandler = ^{
            NSLog(@"Pair Button Tapped -- %@", pBeacons.name);
        
          //  KBeacon* pBeacons = [mBeaconsArray objectAtIndex: indexPath.row];
               
            self->htSensorHandler = [[KBHTSensorHandler alloc]init];
            self->htSensorHandler.mBeacon = pBeacons;
            self->_beacon = pBeacons;
               
               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                   [self Connect_Clicked];
                   [self.vMessagePopUp setHidden:NO];
               });
        };
       
      //  cell.beacon = pBeacons;
       // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    else
    {
        if (indexPath.row > mBeaconsPairedDOTS.count)
        {
            return nil;
        }
        
        static NSString * cellIdentifier1 = @"PairedDevicesTVC";
        PairedDevicesTVC *cell1 = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
        if (cell1 == nil)
        {
            return nil;
        }
        
        KBeacon* pBeacons = [mBeaconsPairedDOTS objectAtIndex: indexPath.row];
        if (pBeacons == nil)
        {
            return nil;
        }
        
        //device name
        if (pBeacons.name != nil){
            cell1.lblBeaconDeviceName.text = [pBeacons.name stringByReplacingOccurrencesOfString:@"KBeacon_"
                                                                                      withString:@""];
        }else{
            cell1.lblBeaconDeviceName.text = @"N/A";
        }
        
        cell1.ringDotButtonTapHandler = ^{
            [self ringDevice];
        };
        
        cell1.unPairButtonTapHandler = ^{
            NSLog(@"unPair Button Tapped -- %@", pBeacons.name);
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"CONNECTED_DEVICE"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self Disconnect_Clicked];
            [mBeaconsPairedDOTS removeAllObjects];
            [self.tvBLEDevices reloadData];
        };
        cell1.lblPercentage.text = [NSString stringWithFormat:@"%@ %%", [pBeacons.batteryPercent stringValue]];
        cell1.lblDensity.text = [NSString stringWithFormat:@"%@", [pBeacons.rssi stringValue]];
        cell1.vBackground.backgroundColor = [[UIColor alloc]initWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1.0];
       // cell1.beacon = pBeacons;
     //   cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
 /*   KBeacon* pBeacons = [mBeaconsArray objectAtIndex: indexPath.row];
    
    htSensorHandler = [[KBHTSensorHandler alloc]init];
    htSensorHandler.mBeacon = pBeacons;
    _beacon = pBeacons;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self Connect_Clicked];
    });*/
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) ShowAlert:(NSString *)Message {
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:nil
                                                                  message:@""
                                                           preferredStyle:UIAlertControllerStyleAlert];
    UIView *firstSubview = alert.view.subviews.firstObject;
    UIView *alertContentView = firstSubview.subviews.firstObject;
    for (UIView *subSubView in alertContentView.subviews) {
        subSubView.backgroundColor = [UIColor colorWithRed:241/255.0f green:0/255.0f blue:154/255.0f alpha:1.0f];
    }
    NSMutableAttributedString *AS = [[NSMutableAttributedString alloc] initWithString:Message];
    [AS addAttribute: NSForegroundColorAttributeName value: [UIColor whiteColor] range: NSMakeRange(0,AS.length)];
    [alert setValue:AS forKey:@"attributedTitle"];
    [self presentViewController:alert animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:^{
        }];
    });
}

@end
