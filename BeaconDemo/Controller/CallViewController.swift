//
//  CallViewController.swift
//  KBeaconDemo_Ios
//
//  Created by Senarios on 17/02/2022.
//  Copyright © 2022 hogen. All rights reserved.
//

import UIKit
import AgoraRtcKit
import CoreLocation
import AVFoundation


struct KeyCenter{
    
    //static let appId = "e0c4b61492134d8e8cbd2fc273cf283b"
    static let appId = "d2b67ca1357f4dc2a3bf660c52596ba4"
    static let token = "006e0c4b61492134d8e8cbd2fc273cf283bIAAMPY9qbLUUvk7AiOUJHf2uOhPr0y9jOkTtC+aYJ/QX1aOcJNMh39v0EACQ4R06X8wQYgEAAQBfzBBi"
    static let channel = "zain"
}

class CallViewController: UIViewController {
    var locationManager = CLLocationManager()
    
    
    
    @IBOutlet weak var lblOperatorName: UILabel!
    @IBOutlet weak var imgOperator: UIImageView!
    @IBOutlet weak var vOperator: UIView!
    @IBOutlet weak var vParentStack: UIStackView!
    @IBOutlet weak var vMic: UIView!
    @IBOutlet weak var vDismissPhone: UIView!
    @IBOutlet weak var vSwitchCamera: UIView!
    
    @IBOutlet weak var imgMic: UIImageView!
    @IBOutlet weak var lblTryToConnect: UILabel!
    
    var localView: UIView!
    var remoteView: UIView!
    
    
    var isMicrophoneEnable = true
    
    var player: AVAudioPlayer!
    
    
    
    
    // Add this linke to add the agoraKit variable
    var agoraKit: AgoraRtcEngineKit?
    var timer : Timer!
    var musicString: Bool = true
    
    
    var trackerId : String = "00005925"
    
    var token : String = ""
    var channelName : String {
        let Tracker_ID = UserDefaults.standard.integer(forKey: "TRACKER_ID")
        let tId = Int(trackerId)
        print("tId is",tId)
        return "globotrac_"+String(Tracker_ID ?? 0)
        //   return "zain"
    }
    var isHitBackgroundApi = false
    var appId = "d2b67ca1357f4dc2a3bf660c52596ba4" //"e0c4b61492134d8e8cbd2fc273cf283b"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let Tracker_ID = UserDefaults.standard.integer(forKey: "TRACKER_ID")
        trackerId = "0000\(Tracker_ID)"
        checkSelectedMusic()
        initView()
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name("DISCONNECT_CALL"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onDisconnectCallSignalData(_:)), name: Notification.Name("DISCONNECT_CALL"), object: nil)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        remoteView.frame = self.view.bounds
        localView.frame = CGRect(x: self.view.bounds.width - 110, y: 40, width: 90, height: 160)
    }
    
    @objc func onDisconnectCallSignalData(_ notification: Notification) {
        print("onDisconnectCallSignalData ....")
        endCall()
    }
    
    private func checkSelectedMusic(){
        let musicType = UserDefaults.standard.string(forKey: "music")
        if musicType == "Loud"{
            playSound(sound: "loud", type: "mpeg")
        }else if musicType == "Medium"{
            playSound(sound: "medium", type: "mpeg")
        }else if musicType == "Soft"{
            playSound(sound: "soft", type: "mpeg")
        }else if musicType == "None"{
            player.stop()
        }else{
            playSound(sound: "loud", type: "mpeg")
        }
    }
    
    func initView() {
        
        
        
        vMic.makeItRound()
        vMic.addShadow()
        vSwitchCamera.makeItRound()
        vSwitchCamera.addShadow()
        vDismissPhone.makeItRound()
        
        
        
        
        remoteView = UIView()
        self.view.addSubview(remoteView)
        localView = UIView()
        localView.backgroundColor = .white
        self.view.addSubview(localView)
        view.bringSubviewToFront(vParentStack)
        
        self.vOperator.isHidden = true
        
        //    trackerAlert()
        getAgoraCredentials()
        
        
    }
    
    private func getAgoraCredentials(){
        print("come in getAgoraCredentials")
        let Tracker_ID = UserDefaults.standard.integer(forKey: "TRACKER_ID")
        let APIKEY = UserDefaults.standard.string(forKey: "TOKEN")
        let shared = URLSession.shared
        
        guard
            let url1 = URL(string: "\(APIs.baseURL)token/agora?tracker_id=0000\(Tracker_ID)") else{
                print("return from url")
                return
            }
        
        
        var request = URLRequest(url: url1)
        print("hit api")
        request.httpMethod = "GET"
        request.setValue(APIKEY!, forHTTPHeaderField: "apiKey")
        // request.setValue("78408836-f4a2-41fe-a39e-4b32f8c97b2f", forHTTPHeaderField: "apiKey")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        shared.dataTask(with: request) { data, response, error in
            
            print("Token Agora is")
            let res = response as? HTTPURLResponse
            print("code is",res?.statusCode)
            print("data is",data)
            print("error is",error)
            
            
            guard
                let data = data else{
                    print("Fail to get the data")
                    return
                }
            print("data is",data)
            
            print("string is",String(data: data, encoding: .utf8))
            
            
            
            
            do{
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print("json is",json)
                let arr = json as? [String:Any]
                print("arr is",arr?["Token"])
                
                let ftoken  = arr?["Token"] as? String ?? ""
                print("fToken is",ftoken)
                self.token = ftoken
                DispatchQueue.main.async {
                    self.initializeAndJoinChannel()
                }
                
                
            }catch{
                print(error.localizedDescription)
            }
            
        }.resume()
        
    }
    
    private func trackerAlert(){
        let Tracker_ID = UserDefaults.standard.integer(forKey: "TRACKER_ID")
        
        
        let parameters  = [
            "tracker_id":"0000\(Tracker_ID)",
            "alert_type_id":"1"
        ]
        
        let apiService = APIManager(
            url: "https://globotrac-api-dev.azurewebsites.net/trackers/\(trackerId)/alerts?alert_type_id=\("1")",
            parameters: parameters)
        apiService.postRequest { (result : Result<[String:Any],APIError>) in
            
            switch result {
            case .success(let json):
                print("Tracker Alerts JSON is",json)
                
                guard
                    let timeStamp = json["Timestamp"] as? String,
                    let trackerId = json["TrackerID"] as? Int else{
                        print("fail to get data from json")
                        return
                    }
                
                print("time stamp is",timeStamp)
                print("tracker id is",trackerId)
                self.addTrackerLocation(time: timeStamp, id: trackerId)
                
                
            case .failure(let failure):
                print(failure.errorDescription)
            }
        }
        
        
    }
    
    
    
    private func addTrackerLocation(time : String,id : Int){
        let CURRENT_LATITUDE = UserDefaults.standard.string(forKey: "CURRENT_LATITUDE")
        let CURRENT_LONGITUDE = UserDefaults.standard.string(forKey: "CURRENT_LONGITUDE")
        
        let trackerId = String(id)
        let lat = CURRENT_LATITUDE // "31.520370"
        let lon = CURRENT_LONGITUDE //  "74.358749"
        guard let newTime = time.addingPercentEncoding(withAllowedCharacters: .whitespacesAndNewlines) else{
            return
        }
        print("new time is",newTime)
        let parameters  = [
            "id":trackerId,
            "alert_type_id":newTime,
            "latitude": lat!, //"31.520370",
            "longitude": lon! //"74.358749"
        ]
        
        
        let t = time.addingPercentEncoding(withAllowedCharacters: .whitespacesAndNewlines) ?? "t not set"
        print("t is",t)
        
        //        let model = AddLocationModel(id: id,timestamp: t, latitude: lat, longitude: lon)
        //        print("model is",model)
        
        let apiService = APIManager(
            url: "https://globotrac-api-dev.azurewebsites.net/trackers/\(trackerId)/addlocation?timestamp=\(newTime)&latitude=\(lat)&longitude=\(lon)",
            parameters: parameters)
        apiService.postRequest { (result : Result<[String:Any],APIError>) in
            
            switch result {
            case .success(let json):
                print("AddLocation Timestamp json is",json)
                //                let timeStamp = json["Timestamp"] as? String
                //                let trackerId = json["TrackerID"] as? Int
                //
                //                print("time stamp is",timeStamp)
                //                print("tracker id is",trackerId)
                
                
            case .failure(let failure):
                print(failure.errorDescription)
            }
        }
        
        
    }
    
    
    @IBAction func didTapDismissCall(_ sender: Any) {
        
        endCall()
        
    }
    
    @IBAction func didTapSwitchCamera(_ sender: UIButton) {
        
        agoraKit?.switchCamera()
    }
    
    @available(iOS 13.0, *)
    @IBAction func didTapMuteMicrophone(_ sender: UIButton) {
        
        if isMicrophoneEnable{
            imgMic.image = UIImage(systemName: "mic.slash.fill")
            agoraKit?.disableAudio()
            isMicrophoneEnable = false
        } else {
            imgMic.image = UIImage(systemName: "mic.fill")
            agoraKit?.enableAudio()
            isMicrophoneEnable = true
        }
    }
    
    private func endCall(){
        if(player != nil){
            player.stop()
        }
        self.musicString = false
        
        agoraKit?.leaveChannel(nil)
        AgoraRtcEngineKit.destroy()
        navigationController?.popViewController(animated: true)
    }
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("View did disappear call")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        
    }
    
    
    func playSound(sound: String, type: String) {
        if let path = Bundle.main.path(forResource: sound, ofType: type) {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
                try AVAudioSession.sharedInstance().setActive(true)

                player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                //audioPlayer?.play()
                self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
                    
                    if self.musicString == true{
                        self.player?.play()
                    }else{
                        timer.invalidate()
                        self.player?.stop()
                    }
                    
                    
                        })
            } catch {
                print("ERROR")
            }
        }
    }
    
    
    
    
    
    private func initializeAndJoinChannel() {
        let Tracker_ID = UserDefaults.standard.integer(forKey: "TRACKER_ID")
        print("AppId is => ",appId)
        print("channelName => ",channelName)
        print("token is => ",token)
        print("Tracker_ID is => ",Tracker_ID, UInt(Tracker_ID))
        
        // Pass in your App ID here
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: appId, delegate: self)
        // Video is disabled by default. You need to call enableVideo to start a video stream.
        agoraKit?.enableVideo()
        
        // Create a videoCanvas to render the local video
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = 0
        videoCanvas.renderMode = .hidden
        videoCanvas.view = localView
        agoraKit?.setupLocalVideo(videoCanvas)
        
        
        
        // Join the channel with a token. Pass in your token and channel name here
        agoraKit?.joinChannel(byToken: token, channelId: channelName, info: nil, uid: UInt(Tracker_ID), joinSuccess: { (channel, uid, elapsed) in
        })
    }
    
    // AppValues.AlertID
    func GetOperatorInfo(){
        
        let Tracker_ID = UserDefaults.standard.integer(forKey: "TRACKER_ID")
        let parameters  = [
            "Tracker_ID": "\(Tracker_ID)",
            "alerts_id": "\(AppValues.AlertID)"
        ]
        
        let apiService = APIManager(
            url: "\(APIs.baseURL)trackers/\(Tracker_ID)/alerts/operator?tracker_alert_id=\(AppValues.AlertID)",
            parameters: parameters)
        apiService.getRequest { (result : Result<[String:Any],APIError>) in
            
            switch result {
            case .success(let json):
                print("json is",json)
                let Photo = json["Photo"] as? String
                let Name = json["Name"] as? String
                let AccountID = json["AccountID"] as? Int
                
                DispatchQueue.main.async {
                    self.lblOperatorName.text = Name
                    guard let url = URL(string: Photo!) else { return }

                    UIImage.loadFrom(url: url) { image in
                        self.imgOperator.image = image
                        
                    }
                    //Loader.shared.stopAnimating()
                    self.vOperator.isHidden = false

                }
                
            
            case .failure(let failure):
                print(failure.errorDescription)
                DispatchQueue.main.async {
                    Loader.shared.stopAnimating()
                }
            }
        }
    }
    
}

extension CallViewController: AgoraRtcEngineDelegate {
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        print("didJoinedOfUid ................", uid)
        
        if(player != nil){
            player.stop()
            DispatchQueue.main.async { [self] in
                player.stop()
            }
        }
        self.musicString = false
        
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.renderMode = .hidden
        videoCanvas.view = remoteView
        agoraKit?.setupRemoteVideo(videoCanvas)
        lblTryToConnect.isHidden = true
        self.GetOperatorInfo()
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        print("did join cannel",uid)
        
        
        
    }
    func rtcEngine(_ engine: AgoraRtcEngineKit, didLeaveChannelWith stats: AgoraChannelStats) {
        print("didLeaveChannelWith .....", stats)
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        print("didOfflineOfUid join",uid)
        endCall()
    }
}

extension UIView{
    
    func addShadow(){
        
     
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 1
        layer.shadowRadius = 2
    }
    
    func makeItRound(){
        layer.cornerRadius = frame.height/2
    }
    
}

extension UIColor{
    
    @available(iOS 11.0, *)
    static let phoneDismissColor = UIColor(named: "PhoneDismissColor")
}
