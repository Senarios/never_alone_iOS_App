//
//  SettingMainVc.swift
//  KBeaconDemo_Ios
//
//  Created by Hashmi on 09/03/2022.
//  Copyright © 2022 hogen. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation


class SettingMainVc: UIViewController {
    
    //MARK: Height Constraint
    
    @IBOutlet weak var falMonitorSlider: UISlider!
    @IBOutlet weak var fallMonitorSwitch: UISwitch!
    @IBOutlet weak var switchLocation: UISwitch!
    @IBOutlet weak var vMode: UIView!
    @IBOutlet weak var modeViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var ringToneViewHieghtConstraint: NSLayoutConstraint!
    @IBOutlet weak var locationManagerViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var alertViewHieghtConstaint: NSLayoutConstraint!
    
    
    //MARK: Buttons
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var modeBtn: UIButton!
    @IBAction func modeBtn(_ sender: Any) {
        
        if checked {
            modeViewHeightConstraint.constant = 0
            modeBtn.setImage(UIImage(named: "arrow_down"), for: .normal)
            modeMainView.isHidden = true
            checked = false
        } else {
            modeViewHeightConstraint.constant = 634
            modeBtn.setImage(UIImage(named: "uparrow"), for: .normal)
            modeMainView.isHidden = false
            //To hide other views
            ringToneViewHieghtConstraint.constant = 0
            ringtoneBtn.setImage(UIImage(named: "arrow_down"), for: .normal)
            ringToneMainView.isHidden = true
            locationManagerViewHeightConstraint.constant = 0
            locationMonitonBtn.setImage(UIImage(named: "arrow_down"), for: .normal)
            locationMainView.isHidden = true
            alertViewHieghtConstaint.constant = 0
            fallAlertBtn.setImage(UIImage(named: "arrow_down"), for: .normal)
            alertMainView.isHidden = true
            checked = true
        }
    }
    
    @IBOutlet weak var ringtoneBtn: UIButton!
    @IBAction func ringtoneBtn(_ sender: Any) {
        
        if checked {
            ringToneViewHieghtConstraint.constant = 0
            ringtoneBtn.setImage(UIImage(named: "arrow_down"), for: .normal)
            ringToneMainView.isHidden = true
            checked = false
        } else {
            ringToneViewHieghtConstraint.constant = 314
            ringtoneBtn.setImage(UIImage(named: "uparrow"), for: .normal)
            ringToneMainView.isHidden = false
            //To hide other views
            modeViewHeightConstraint.constant = 0
            modeBtn.setImage(UIImage(named: "arrow_down"), for: .normal)
            modeMainView.isHidden = true
            locationManagerViewHeightConstraint.constant = 0
            locationMonitonBtn.setImage(UIImage(named: "arrow_down"), for: .normal)
            locationMainView.isHidden = true
            alertViewHieghtConstaint.constant = 0
            fallAlertBtn.setImage(UIImage(named: "arrow_down"), for: .normal)
            alertMainView.isHidden = true
            checked = true
        }
    }
    
    @IBOutlet weak var locationMonitonBtn: UIButton!
    @IBAction func locationMonitonBtn(_ sender: Any) {
        
        if checked {
            locationManagerViewHeightConstraint.constant = 0
            locationMonitonBtn.setImage(UIImage(named: "arrow_down"), for: .normal)
            locationMainView.isHidden = true
            checked = false
        } else {
            locationManagerViewHeightConstraint.constant = 180
            locationMonitonBtn.setImage(UIImage(named: "uparrow"), for: .normal)
            locationMainView.isHidden = false
            
            //To hide other views
            ringToneViewHieghtConstraint.constant = 0
            ringtoneBtn.setImage(UIImage(named: "arrow_down"), for: .normal)
            ringToneMainView.isHidden = true
            modeViewHeightConstraint.constant = 0
            modeBtn.setImage(UIImage(named: "arrow_down"), for: .normal)
            modeMainView.isHidden = true
            alertViewHieghtConstaint.constant = 0
            fallAlertBtn.setImage(UIImage(named: "arrow_down"), for: .normal)
            alertMainView.isHidden = true
            checked = true
        }
    }
    
    @IBOutlet weak var fallAlertBtn: UIButton!
    @IBAction func fallAlertBtn(_ sender: Any) {
        
        if checked {
            alertViewHieghtConstaint.constant = 0
            fallAlertBtn.setImage(UIImage(named: "arrow_down"), for: .normal)
            alertMainView.isHidden = true
            checked = false
        } else {
            alertViewHieghtConstaint.constant = 314
            fallAlertBtn.setImage(UIImage(named: "uparrow"), for: .normal)
            alertMainView.isHidden = false
            //To hide other views
            ringToneViewHieghtConstraint.constant = 0
            ringtoneBtn.setImage(UIImage(named: "arrow_down"), for: .normal)
            ringToneMainView.isHidden = true
            modeViewHeightConstraint.constant = 0
            modeBtn.setImage(UIImage(named: "arrow_down"), for: .normal)
            modeMainView.isHidden = true
            locationManagerViewHeightConstraint.constant = 0
            locationMonitonBtn.setImage(UIImage(named: "arrow_down"), for: .normal)
            locationMainView.isHidden = true
            checked = true
        }
    }
    
    
    @IBOutlet weak var locationSaveBtn: UIButton!
    @IBAction func locationSaveBtn(_ sender: Any) {

        if (self.switchLocation.isOn) == true{
            UserDefaults.standard.set("YES", forKey: "LOCATION_UPDATE")
            print("Swict On")
            self.showToast(message: "Starting the Location Monitor")
        }else{
            UserDefaults.standard.set("NO", forKey: "LOCATION_UPDATE")
            print("Switch Off")
            self.showToast(message: "Stopping the Location Monitor")
        }
        
        
    }
    @IBOutlet weak var alertSaveBtn: UIButton!
    @IBAction func alertSaveBtn(_ sender: Any) {
        
        if (self.fallMonitorSwitch.isOn) == true{
            UserDefaults.standard.set("YES", forKey: "FALL_MONITOR_UPDATE")
            print("Swict On")
            self.showToast(message: "Starting the Fall Monitor")
        }else{
            UserDefaults.standard.set("NO", forKey: "FALL_MONITOR_UPDATE")
            print("Switch Off")
            self.showToast(message: "Stopping the Fall Monitor")
        }
        
        
        var currentValue = Int(self.falMonitorSlider.value)
        UserDefaults.standard.set(currentValue, forKey: "FALL_MONITOR_SLIDER")
    }
    
    
    
    @IBOutlet weak var loudBtn: UIButton!
    @IBAction func loudBtn(_ sender: Any) {
        ringToneBtnConditions(btn: loudBtn)
        playAudio(btn: loudBtn)
    }
    @IBOutlet weak var mediumBtn: UIButton!
    @IBAction func mediumBtn(_ sender: Any) {
        ringToneBtnConditions(btn: mediumBtn)
        playAudio(btn: mediumBtn)
    }
    @IBOutlet weak var softBtn: UIButton!
    @IBAction func softBtn(_ sender: Any) {
        ringToneBtnConditions(btn: softBtn)
        playAudio(btn: softBtn)
    }
    @IBOutlet weak var noneBtn: UIButton!
    @IBAction func noneBtn(_ sender: Any) {
        ringToneBtnConditions(btn: noneBtn)
        playAudio(btn: noneBtn)
    }
    //MARK: Switches
    
   
    @IBAction func locationSwitch(_ sender: UISwitch) {
//        if (sender.isOn) == true{
//            UserDefaults.standard.set("YES", forKey: "LOCATION_UPDATE")
//            print("Swict On")
//        }else{
//            UserDefaults.standard.set("NO", forKey: "LOCATION_UPDATE")
//            print("Switch Off")
//        }
    }
    @IBAction func alertSwitch(_ sender: UISwitch) {
        if (sender.isOn) == true{
            print("Swict On")
        }else{
            print("Switch Off")
        }
    }
    
    @IBAction func customSliderBar(_ sender: UISlider) {
        var currentValue = Int(sender.value)
        print(currentValue)
    }
    
    
    //MARK: Views
    
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var modeMainView: UIView!
    @IBOutlet weak var secureModeView: UIView!
    @IBOutlet weak var familyModeView: UIView!

    @IBOutlet weak var ringToneMainView: UIView!
    @IBOutlet weak var loudView: UIView!
    @IBOutlet weak var mediumView: UIView!
    @IBOutlet weak var softView: UIView!
    @IBOutlet weak var noneView: UIView!

    @IBOutlet weak var locationMainView: UIView!
    @IBOutlet weak var alertMainView: UIView!
    
    //MARK: ImageViews
    
    @IBOutlet weak var secureModeImageView: UIImageView!
    @IBOutlet weak var familyModeImageView: UIImageView!
    
    @IBOutlet weak var loudImgView: UIImageView!
    @IBOutlet weak var mediumImgView: UIImageView!
    @IBOutlet weak var softImgView: UIImageView!
    @IBOutlet weak var noneImgView: UIImageView!

    var checked = false
    var player: AVAudioPlayer!
    override func viewDidLoad() {
        super.viewDidLoad()
        styling()
        myScrollView.bounces = false
        
        modeViewHeightConstraint.constant = 0
        modeMainView.isHidden = true
        ringToneViewHieghtConstraint.constant = 0
        ringToneMainView.isHidden = true
        locationManagerViewHeightConstraint.constant = 0
        locationMainView.isHidden = true
        
        let secureModeTap = UITapGestureRecognizer(target: self, action: #selector(secureModeCheck(_:)))
        secureModeView.addGestureRecognizer(secureModeTap)
        
        let familyModeTap = UITapGestureRecognizer(target: self, action: #selector(familyModeCheck(_:)))
        familyModeView.addGestureRecognizer(familyModeTap)
        
        let loudViewTap = UITapGestureRecognizer(target: self, action: #selector(loudViewLayout))
        loudView.addGestureRecognizer(loudViewTap)
        
        let mediumViewTap = UITapGestureRecognizer(target: self, action: #selector(midiumViewLayout))
        mediumView.addGestureRecognizer(mediumViewTap)
        
        let softViewTap = UITapGestureRecognizer(target: self, action: #selector(softViewLayout))
        softView.addGestureRecognizer(softViewTap)
        
        let noneViewTap = UITapGestureRecognizer(target: self, action: #selector(noneViewLayout))
        noneView.addGestureRecognizer(noneViewTap)
        
        alertViewHieghtConstaint.constant = 0
        alertMainView.isHidden = true
        
        let USER_TYPE = UserDefaults.standard.string(forKey: "USER_TYPE")
        if(USER_TYPE! == "CHILD"){
            self.vMode.isHidden = true
        }
        let LOCATION_UPDATE = UserDefaults.standard.string(forKey: "LOCATION_UPDATE")
        if(LOCATION_UPDATE != nil && LOCATION_UPDATE! == "YES"){
            self.switchLocation.isOn = true
        }
        else
        {
            self.switchLocation.isOn = false
        }
        let FALL_MONITOR_UPDATE = UserDefaults.standard.string(forKey: "FALL_MONITOR_UPDATE")
        if(FALL_MONITOR_UPDATE != nil && FALL_MONITOR_UPDATE! == "YES"){
            self.fallMonitorSwitch.isOn = true
        }
        else
        {
            self.fallMonitorSwitch.isOn = false
        }
        var FALL_MONITOR_SLIDER = UserDefaults.standard.integer(forKey: "FALL_MONITOR_SLIDER")
        self.falMonitorSlider.value = Float(FALL_MONITOR_SLIDER)
        
      
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        self.styling()
    }
    func styling(){
        locationSaveBtn.layer.cornerRadius = 10.0
        alertSaveBtn.layer.cornerRadius = 10.0
        secureModeView.layer.cornerRadius = 10.0
        familyModeView.layer.cornerRadius = 10.0
        secureModeView.layer.borderWidth = 1.5
        familyModeView.layer.borderWidth = 1.5
        loudView.layer.cornerRadius = 10.0
        loudView.layer.borderColor = UIColor.lightGray.cgColor
        loudView.layer.borderWidth = 1.5
        
        mediumView.layer.cornerRadius = 10.0
        mediumView.layer.borderColor = UIColor.lightGray.cgColor
        mediumView.layer.borderWidth = 1.5
        
        softView.layer.cornerRadius = 10.0
        softView.layer.borderColor = UIColor.lightGray.cgColor
        softView.layer.borderWidth = 1.5
        
        noneView.layer.cornerRadius = 10.0
        noneView.layer.borderColor = UIColor.lightGray.cgColor
        noneView.layer.borderWidth = 1.5
        checkSelectedMusic()
        
    }
    
    func ringToneBtnConditions(btn: UIButton){
        if btn == loudBtn{

            loudBtn.setImage(UIImage(named: "pause"), for: .normal)
            mediumBtn.setImage(UIImage(named: "play"), for: .normal)
            softBtn.setImage(UIImage(named: "play"), for: .normal)
            noneBtn.setImage(UIImage(named: "play"), for: .normal)

        }else if btn == mediumBtn{
            
            loudBtn.setImage(UIImage(named: "play"), for: .normal)
            mediumBtn.setImage(UIImage(named: "pause"), for: .normal)
            softBtn.setImage(UIImage(named: "play"), for: .normal)
            noneBtn.setImage(UIImage(named: "play"), for: .normal)

        }else if btn == softBtn{
            
            loudBtn.setImage(UIImage(named: "play"), for: .normal)
            mediumBtn.setImage(UIImage(named: "play"), for: .normal)
            softBtn.setImage(UIImage(named: "pause"), for: .normal)
            noneBtn.setImage(UIImage(named: "play"), for: .normal)

        }else if btn == noneBtn{
            
            loudBtn.setImage(UIImage(named: "play"), for: .normal)
            mediumBtn.setImage(UIImage(named: "play"), for: .normal)
            softBtn.setImage(UIImage(named: "play"), for: .normal)
            noneBtn.setImage(UIImage(named: "pause"), for: .normal)

        }
        
    }
    
    //MARK: Tap Gestures
    @objc func secureModeCheck(_ sender:UITapGestureRecognizer){
        secureModeImageView.image = UIImage(named: "checkmark")
        familyModeImageView.image = UIImage(named: "")
        secureModeView.layer.borderColor = UIColor.green.cgColor
        familyModeView.layer.borderColor = UIColor.lightGray.cgColor
        UserDefaults.standard.set("1", forKey: "SECURITY_MODE") // Secure
        self.UpdateMode_API(modeData: "1")
    }
    @objc func familyModeCheck(_ sender:UITapGestureRecognizer){
        secureModeImageView.image = UIImage(named: "")
        familyModeImageView.image = UIImage(named: "checkmark")
        secureModeView.layer.borderColor = UIColor.lightGray.cgColor
        familyModeView.layer.borderColor = UIColor.green.cgColor
        UserDefaults.standard.set("2", forKey: "SECURITY_MODE") // Family
        self.UpdateMode_API(modeData: "2")
    }
    //MARK: Check mode
    func checkSelectedMode(){ // Secure= 1, Family=2
        
        let modeType = UserDefaults.standard.string(forKey: "SECURITY_MODE")
        if modeType == "1"{
            secureModeView.layer.borderColor = UIColor.green.cgColor
            familyModeView.layer.borderColor = UIColor.lightGray.cgColor
            secureModeView.layer.borderWidth = 1.5
            secureModeImageView.image = UIImage(named: "checkmark")
        }else if modeType == "2"{
            secureModeView.layer.borderColor = UIColor.lightGray.cgColor
            familyModeView.layer.borderColor = UIColor.green.cgColor
            familyModeView.layer.borderWidth = 1.5
            familyModeImageView.image = UIImage(named: "checkmark")
        }else{
            secureModeView.layer.borderColor = UIColor.green.cgColor
            familyModeView.layer.borderColor = UIColor.lightGray.cgColor
            secureModeView.layer.borderWidth = 1.5
            secureModeImageView.image = UIImage(named: "checkmark")
        }
        
    }
    
    func checkSelectedMusic(){
        let musicType = UserDefaults.standard.string(forKey: "music")
        if musicType == "Loud"{
            loudView.layer.borderColor = UIColor.green.cgColor
            loudView.layer.borderWidth = 1.5
            loudImgView.image = UIImage(named: "checkmark")
        }else if musicType == "Medium"{
            mediumView.layer.borderColor = UIColor.green.cgColor
            mediumView.layer.borderWidth = 1.5
            mediumImgView.image = UIImage(named: "checkmark")
        }else if musicType == "Soft"{
            softView.layer.borderColor = UIColor.green.cgColor
            softView.layer.borderWidth = 1.5
            softImgView.image = UIImage(named: "checkmark")
        }else if musicType == "None"{
            noneView.layer.borderColor = UIColor.green.cgColor
            noneView.layer.borderWidth = 1.5
            noneImgView.image = UIImage(named: "checkmark")
        }else{
            loudView.layer.borderColor = UIColor.green.cgColor
            loudView.layer.borderWidth = 1.5
            loudImgView.image = UIImage(named: "checkmark")
        }
        checkSelectedMode()
    }
    
    func playAudio(btn: UIButton) {
        if btn == loudBtn{
//            let url = Bundle.main.url(forResource: "loud", withExtension: "mpeg")
//            player = try! AVAudioPlayer(contentsOf: url!)
//            player.play()
            playSound(sound: "loud", type: "mpeg")
            UserDefaults.standard.set("Loud", forKey: "music")
        }else if btn == mediumBtn{
//            let url = Bundle.main.url(forResource: "medium", withExtension: "mpeg")
//            player = try! AVAudioPlayer(contentsOf: url!)
//            player.play()
            playSound(sound: "medium", type: "mpeg")
            UserDefaults.standard.set("Medium", forKey: "music")
        }else if btn == softBtn{
//            let url = Bundle.main.url(forResource: "soft", withExtension: "mpeg")
//            player = try! AVAudioPlayer(contentsOf: url!)
//            player.play()
            playSound(sound: "soft", type: "mpeg")
            UserDefaults.standard.set("Soft", forKey: "music")
        }else if btn == softBtn{
            player.stop()
            UserDefaults.standard.set("None", forKey: "music")
        }
           
    }
    
    
    func playSound(sound: String, type: String) {
        if let path = Bundle.main.path(forResource: sound, ofType: type) {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
                try AVAudioSession.sharedInstance().setActive(true)

                player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                player?.play()
                
            } catch {
                print("ERROR")
            }
        }
    }
    
    
    //MARK: View Layout check
   @objc func loudViewLayout(){
       loudImgView.image = UIImage(named: "checkmark")
       mediumImgView.image = UIImage(named: "")
       softImgView.image = UIImage(named: "")
       noneImgView.image = UIImage(named: "")
        loudView.layer.borderColor = UIColor.green.cgColor
        mediumView.layer.borderColor = UIColor.lightGray.cgColor
        softView.layer.borderColor = UIColor.lightGray.cgColor
        noneView.layer.borderColor = UIColor.lightGray.cgColor
    }
    @objc func midiumViewLayout(){
        loudImgView.image = UIImage(named: "")
        mediumImgView.image = UIImage(named: "checkmark")
        softImgView.image = UIImage(named: "")
        noneImgView.image = UIImage(named: "")
        loudView.layer.borderColor = UIColor.lightGray.cgColor
        mediumView.layer.borderColor = UIColor.green.cgColor
        softView.layer.borderColor = UIColor.lightGray.cgColor
        noneView.layer.borderColor = UIColor.lightGray.cgColor
    }
    @objc func softViewLayout(){
        loudImgView.image = UIImage(named: "")
        mediumImgView.image = UIImage(named: "")
        softImgView.image = UIImage(named: "checkmark")
        noneImgView.image = UIImage(named: "")
        loudView.layer.borderColor = UIColor.lightGray.cgColor
        mediumView.layer.borderColor = UIColor.lightGray.cgColor
        softView.layer.borderColor = UIColor.green.cgColor
        noneView.layer.borderColor = UIColor.lightGray.cgColor
    }
    @objc func noneViewLayout(){
        loudImgView.image = UIImage(named: "")
        mediumImgView.image = UIImage(named: "")
        softImgView.image = UIImage(named: "")
        noneImgView.image = UIImage(named: "checkmark")
        loudView.layer.borderColor = UIColor.lightGray.cgColor
        mediumView.layer.borderColor = UIColor.lightGray.cgColor
        softView.layer.borderColor = UIColor.lightGray.cgColor
        noneView.layer.borderColor = UIColor.green.cgColor
    }
    
    
    
    //MARK: API call
    func UpdateMode_API(modeData: String){
        let parameters  = [
            "mode": modeData,
        ]
        
        let apiService = APIManager(
            url: "\(APIs.baseURL)accounts/update_mode?mode=\(modeData)",
            parameters: parameters)
        apiService.putRequest { (result : Result<[String:Any],APIError>) in
            
            switch result {
            case .success(let json):
                print("json is",json)
                let Message = json["Message"] as? String
                let Status = json["Status"] as? Int
                
                DispatchQueue.main.async {
                  //  if(Status == 0){
                        self.showToast(message: Message!)
                        Loader.shared.stopAnimating()
//                    } else if(Status == 1){
//                        self.showToast(message: Message!)
//                        Loader.shared.stopAnimating()
//                    }

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
