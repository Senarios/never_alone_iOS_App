//
//  UserLocation.swift
//  KBeaconDemo_Ios
//
//  Created by Senarios on 18/02/2022.
//  Copyright © 2022 hogen. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import UserNotifications


@objc public class UserLocation : NSObject , CLLocationManagerDelegate{
    
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!
    
    static var lat : CLLocationDegrees?
    static var lon : CLLocationDegrees?
    
   override init() {
    super.init()
        print("user location init run")
    
        if (CLLocationManager.locationServicesEnabled())
        {
            print("user location init run 2")
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
       
    }
    
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("locations",locations)
        let location = locations.last! as CLLocation
        UserLocation.lat = location.coordinate.latitude
        UserLocation.lon = location.coordinate.longitude
        print("uSERLOCATION",UserLocation.lat,UserLocation.lon)
    }
    
    @objc public func TrackerAlert(locationID: String){
        print("TrackerAlert ................")
        
        let Tracker_ID = UserDefaults.standard.integer(forKey: "TRACKER_ID")
        
        var trackerId : String = "0000\(Tracker_ID)" //"00005925"
        
        let parameters  = [
            "tracker_id": trackerId,
            "alert_type_id":"1"
        ]
        
        let apiService = APIManager(
            url: "\(APIs.baseURL)trackers/\(trackerId)/alerts?alert_type_id=\("4")&location_id=\(locationID)&alert_message=SOS%20Alert",
            parameters: parameters)
        apiService.postRequest { (result : Result<[String:Any],APIError>) in
            
            switch result {
            case .success(let json):
                print("json is",json)
                
                guard
                let timeStamp = json["Timestamp"] as? String,
                let trackerId = json["TrackerID"] as? Int else{
                    print("fail to get data from json")
                    return
                }
                let AlertID = json["AlertID"] as? Int
                AppValues.AlertID = "\(AlertID!)"
                
                print("time stamp is",timeStamp)
                print("tracker id is",trackerId)
               // self.AddTrackerLocation(time: timeStamp, id: trackerId)
            //    self.AddTrackerLocation()
                self.SendLocationNotification()
      
            case .failure(let failure):
                print(failure.errorDescription)
            }
        }
    }
    
    @objc public func AddTrackerLocation(){
        let CURRENT_LATITUDE = UserDefaults.standard.string(forKey: "CURRENT_LATITUDE")
        let CURRENT_LONGITUDE = UserDefaults.standard.string(forKey: "CURRENT_LONGITUDE")
        let Tracker_ID = UserDefaults.standard.integer(forKey: "TRACKER_ID")
        
       // let trackerId = String(id)
        let trackerId : String = "0000\(Tracker_ID)" // "00005925"
        let lat = CURRENT_LATITUDE // "31.520370"
        let lon = CURRENT_LONGITUDE //  "74.358749"
        
        let date = Date()
//        let df = DateFormatter()
//        df.dateFormat = "yyyy-MM-ddTHH:mm:ss"
        //let dateString = df.string(from: date)
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let second = calendar.component(.second, from: date)
        
     //   let dateString = "\(year)-\(month)-\(day)T\(hour):\(minutes):\(second)"
    //    print("Local Time : \(dateString)")
        
        
//        let dateFormatter = DateFormatter()
//               dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.zzzZ"
//               dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
//        let date1 = dateFormatter.date(from: dateString)
//                dateFormatter.dateFormat = "dd-MM-yyyy h:mm a"
//                dateFormatter.timeZone = NSTimeZone.local
//        let timestamp = dateFormatter.string(from: date1!)
//               print("New Date\(timestamp)")
        
        var currentDate = Date()
         
         
        // 1) Create a DateFormatter() object.
        let format = DateFormatter()
         
        // 2) Set the current timezone to .current, or America/Chicago.
        format.timeZone = .current
         
        // 3) Set the format of the altered date.
        format.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
         
        // 4) Set the current date, altered by timezone.
        let dateString = format.string(from: currentDate)
        print("dateString:", dateString)
        
        guard let newTime = dateString.addingPercentEncoding(withAllowedCharacters: .whitespacesAndNewlines) else{
            return
        }
        print("new time is",newTime)
        let parameters  = [
            "id":trackerId,
            "alert_type_id":newTime,
            "latitude": lat!, //"31.520370",
            "longitude": lon! //"74.358749"
        ]
        
        
        let t = dateString.addingPercentEncoding(withAllowedCharacters: .whitespacesAndNewlines) ?? "t not set"
        print("t is",t)
        
//        let model = AddLocationModel(id: id,timestamp: t, latitude: lat, longitude: lon)
//        print("model is",model)
        
        let apiService = APIManager(
            url: "\(APIs.baseURL)trackers/\(trackerId)/addlocation?timestamp=\(newTime)&latitude=\(lat!)&longitude=\(lon!)",
            parameters: parameters)
        apiService.postRequest { (result : Result<[String:Any],APIError>) in

            switch result {
            case .success(let json):
                print("json is",json)
                
                let timeStamp = json["TimeStamp"] as? String
                let LocationID = json["LocationID"] as? Int
//
                print("time stamp is",timeStamp)
                print("Location id is",LocationID!)
                let locId = "\(LocationID!)"
                self.TrackerAlert(locationID: locId)

            case .failure(let failure):
                print(failure.errorDescription)
            }
        }
    }
    
    @objc public func GetTrackerData(){
        
        let Tracker_ID = UserDefaults.standard.integer(forKey: "TRACKER_ID")
        print("TrackerAlert ................\(Tracker_ID)")
        var trackerId : String = "0000\(Tracker_ID)" //"00005925"
        
        let parameters  = [
            "tracker_id": trackerId,
            "alert_type_id":"1"
        ]
        
        let apiService = APIManager(
            url: "\(APIs.baseURL)trackers?tracker_id=\(Tracker_ID)",
            parameters: parameters)
        apiService.getRequest { (result : Result<[String:Any],APIError>) in
            
            switch result {
            case .success(let json):
                print("json is",json)
                
                
                let trackersData = json["trackers"] as? Array<Any>
                NotificationCenter.default.post(name:  Notification.Name("TRACKERS_DATA"), object: trackersData!)
                print("ArrayData",trackersData!)
              
               
      
            case .failure(let failure):
                print(failure.errorDescription)
            }
        }
    }
    
    @objc public func DeleteTracker(trackerId: String){
        
        let Tracker_ID = UserDefaults.standard.integer(forKey: "TRACKER_ID")
        print("TrackerAlert ................\(Tracker_ID)")
     //   var trackerId : String = "0000\(Tracker_ID)" //"00005925"
        
        let parameters  = [
            "alert_type_id":"1"
        ]
        
        let apiService = APIManager(
            url: "\(APIs.baseURL)trackers/\(trackerId)",
            parameters: parameters)
        apiService.deleteRequest{ (result : Result<[String:Any],APIError>) in
            
            switch result {
            case .success(let json):
                print("json is",json)
                
            NotificationCenter.default.post(name:  Notification.Name("TRACKERS_DELETED"), object: nil)
            //self.showToast(message: "Tracker deleted!")
            case .failure(let failure):
                print(failure.errorDescription)
            }
        }
    }
    
    @objc public func UpdateLocation(){
        let CURRENT_LATITUDE = UserDefaults.standard.string(forKey: "CURRENT_LATITUDE")
        let CURRENT_LONGITUDE = UserDefaults.standard.string(forKey: "CURRENT_LONGITUDE")
        let CURRENT_Activity = UserDefaults.standard.string(forKey: "CURRENT_Activity")
        var lActivity = "0"
        if(CURRENT_Activity != nil){
            lActivity = CURRENT_Activity!
        }
        
        let Tracker_ID = UserDefaults.standard.integer(forKey: "TRACKER_ID")
        print("TrackerAlert ................\(Tracker_ID)")
     //   var trackerId : String = "0000\(Tracker_ID)" //"00005925"
        if (CURRENT_LATITUDE == nil || CURRENT_LONGITUDE == nil){
            return
        }
        
        let parameters  = [
            "tracker_id": CURRENT_LATITUDE!,
            "alert_type_id":"1"
        ]
        
        var currentDate = Date()
         
        // 1) Create a DateFormatter() object.
        let format = DateFormatter()
         
        // 2) Set the current timezone to .current, or America/Chicago.
        format.timeZone = .current
         
        // 3) Set the format of the altered date.
        format.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
         
        // 4) Set the current date, altered by timezone.
        let dateString = format.string(from: currentDate)
        print("dateString:", dateString)
        
        guard let newTime = dateString.addingPercentEncoding(withAllowedCharacters: .whitespacesAndNewlines) else{
            return
        }
        
        let apiService = APIManager(
            url: "\(APIs.baseURL)trackers/\(Tracker_ID)/addlocation?timestamp=\(newTime)&latitude=\(CURRENT_LATITUDE!)&longitude=\(CURRENT_LONGITUDE!)&&activity=\(lActivity)/",
            parameters: parameters)
        apiService.postRequest{ (result : Result<[String:Any],APIError>) in
            
            switch result {
            case .success(let json):
                print("UpdateLocation json is",json)
                
            
                
            case .failure(let failure):
                print("UpdateLocation")
                print(failure.errorDescription)
            }
        }
    }
    
    @objc public func GetAccountInfo(){
        
        print("GetAccountInfo ................")
        
        let parameters  = [
            "alert_type_id":"1"
        ]
        
        let apiService = APIManager(
            url: "\(APIs.baseURL)accounts",
            parameters: parameters)
        apiService.getRequestArray { (result : Result<[Any],APIError>) in
            
            switch result {
            case .success(let json):
                print("Accounts json is",json)
                
                let trackersData = json
                if(trackersData.count > 0){
                    let accountData = trackersData[0] as! Dictionary<String, Any>
                    print(accountData)
                    let Mode = accountData["Mode"]
                    print("Mode :\(Mode!)")
                    
                    UserDefaults.standard.set( "\(Mode!)", forKey: "SECURITY_MODE")
                }
      
            case .failure(let failure):
                print(failure.errorDescription)
            }
        }
    }
    
    @objc public func SendLocationNotification(){
        print("Show user notificaiton")
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.badge, .sound, .alert]){(granted, error) in
            if error == nil {
                print("User permission is granted : \(granted)")
            }
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Call Notification"
        content.body = "Call triggered"
        
        let date = Date().addingTimeInterval(0.5)
        let dateComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        
        
        // Creat request
        
        let uuid = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)
        
        center.add(request){(error) in
            print("Notification sent")
        }
    }
}



