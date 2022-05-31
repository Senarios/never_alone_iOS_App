//
//  LoginViewController.swift
//  KBeaconDemo_Ios
//
//  Created by Azhar on 2/24/22.
//  Copyright © 2022 hogen. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Alamofire
import AVFoundation
import Network

class LoginViewController: UIViewController {
    
    @IBOutlet weak var vEmail: UIView!
    @IBOutlet weak var vPassword: UIView!
    
    @IBOutlet weak var tfEmailAddress: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    @IBOutlet weak var btnLogin: UIButton!
    
    var session: AVAudioSession = AVAudioSession.sharedInstance()
    
    var isNetworkAvailable: Bool = false
    var networkCheck = NetworkCheck.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setControls()
        checkCameraAccess()
        
        self.checkNetworkStatus()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let defaults = UserDefaults.standard
        print(defaults)
        tfEmailAddress.text = ""
        tfPassword.text = ""
        vPassword.isHidden = true
    }
    
    
    //MARK: Check Camera Permision
    
    func checkCameraAccess() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied:
            print("Denied, request permission from settings")
        case .restricted:
            print("Restricted, device owner must approve")
        case .authorized:
            print("Authorized, proceed")
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { success in
                if success {
                    print("Permission granted, proceed")
                } else {
                    print("Permission denied")
                }
            }
        @unknown default:
            print("Nothing")
        }
        microphoneAccess()
    }
    
    //MARK: Microphone access
    func microphoneAccess(){
        // let session = AVAudioSession.sharedInstance()
           if (session.responds(to: #selector(AVAudioSession.requestRecordPermission(_:)))) {
               AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
                   if granted {
                       print("granted")

                       do {
                           try self.session.setCategory(AVAudioSession.Category.playAndRecord)
                           try self.session.setActive(true)
                       }
                       catch {

                           print("Couldn't set Audio session category")
                       }
                   } else{
                       print("not granted")
                   }
               })
           }
    }
    
    
    // MARK: - Class Functions
    func setControls(){

     //   self.tfEmailAddress.text = "salmank888@gmail.com" // 123456
        
        self.vEmail.layer.cornerRadius = 10
        self.vEmail.layer.borderWidth = 1
        self.vEmail.layer.borderColor = UIColor.gray.cgColor
        
        self.vPassword.layer.cornerRadius = 10
        self.vPassword.layer.borderWidth = 1
        self.vPassword.layer.borderColor = UIColor.gray.cgColor
        
        self.vPassword.isHidden = true
        
        self.vEmail.backgroundColor = UIColor.clear
        self.vPassword.backgroundColor = UIColor.clear
        
        self.btnLogin.backgroundColor = Colors.GREEN_BUTTON_COLOR
        self.btnLogin.titleLabel?.textColor = UIColor.white
        self.btnLogin.layer.cornerRadius = 10
        
        self.btnLogin.setTitleColor(.white, for: .normal)
        
        self.tfEmailAddress.delegate = self
        self.tfPassword.delegate = self
        
        hideKeyboardWhenTappedAround()
        IQKeyboardManager.shared.enable = true
        
        self.tfEmailAddress.attributedPlaceholder = NSAttributedString(string: "Promo Code or Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        self.tfPassword.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
//        let button = UIButton(type: .roundedRect)
//              button.frame = CGRect(x: 20, y: 50, width: 100, height: 30)
//              button.setTitle("Test Crash", for: [])
//              button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), for: .touchUpInside)
//              view.addSubview(button)
    }
    
//    @IBAction func crashButtonTapped(_ sender: AnyObject) {
//        let numbers = [0]
//        let _ = numbers[1]
//    }
    
    func CallLoginAPI(){
        if(!self.isNetworkAvailable){
            print("Network not available")
            self.showToast(message: "Network not available ...")
            return
        }
        self.view.endEditing(true)
        Loader.shared.startAnimating(in: self.view)
        let parameters  = [
            "username": self.tfEmailAddress.text!,
            "password": self.tfPassword.text!
        ]
        UserDefaults.standard.set(self.tfEmailAddress.text!, forKey: "EMAIL_ADDRESS")
        
        let apiService = APIManager(
            url: "\(APIs.baseURL)login?username=\(self.tfEmailAddress.text!)&password=\(self.tfPassword.text!)",
            parameters: parameters)
        apiService.postRequest { (result : Result<[String:Any],APIError>) in
            
            switch result {
            case .success(let json):
                print("json is",json)
                
                let Token = json["Token"] as? String
                let IssueDateTime = json["IssueDateTime"] as? String
                let ExpiryDateTime = json["ExpiryDateTime"] as? String
                let FirstName = json["FirstName"] as? String
                let LastName = json["LastName"] as? String
                let ID = json["ID"] as? Int
                let AccountID = json["AccountID"] as? Int
                let Mode = json["Mode"] as? Int
                
                UserDefaults.standard.set(ID, forKey: "ID")
                UserDefaults.standard.set(AccountID, forKey: "ACCOUNT_ID")
                UserDefaults.standard.set(Mode, forKey: "MODE")
                UserDefaults.standard.set(Token, forKey: "TOKEN")
                UserDefaults.standard.set(IssueDateTime, forKey: "IssueDateTime")
                UserDefaults.standard.set(ExpiryDateTime, forKey: "ExpiryDateTime")
                UserDefaults.standard.set(FirstName, forKey: "FIRST_NAME")
                UserDefaults.standard.set(LastName, forKey: "LAST_NAME")
                UserDefaults.standard.set("PARENT", forKey: "USER_TYPE")
                UserDefaults.standard.set("YES", forKey: "LOCATION_UPDATE")
                
                print("time stamp is",Token)
                print("tracker id is",ID)
//                DispatchQueue.main.async {
//                    self.showToast(message: "Logged in successfully!")
//                    Loader.shared.stopAnimating()
//                    self.performSegue(withIdentifier: "Login_TO_DeviceViewController", sender: self)
//                }
                DispatchQueue.main.async {
                    if(AccountID == 0){
                        self.showToast(message: "Invalid login Credentials!")
                        Loader.shared.stopAnimating()
                    }
                    else
                    {
                        self.GetTrackerID_API()
                    }
                }
                
            
            case .failure(let failure):
                print(failure.errorDescription)
                Loader.shared.stopAnimating()
            }
        }
        
        /*
         {
         [
         "AccountID": 3287,
         "FirstName": Salman,
         "LastName": Khalid,
         "Token": 2cf74f00-36b6-45ea-8cc9-6247efeb9071,
         "ID": 212,
         "IssueDateTime": 2022-02-10T12:12:21,
         "ExpiryDateTime": 2022-02-10T16:12:21,
         "Mode": 1]
         }
         */
    }
    
    func CallPromoActivationAPI(){
        if(!self.isNetworkAvailable){
            print("Network not available")
            self.showToast(message: "Network not available ...")
            return
        }
        
        self.view.endEditing(true)
        Loader.shared.startAnimating(in: self.view)
        let parameters  = [
            "username": self.tfEmailAddress.text!,
            "password": self.tfPassword.text!
        ]
        let diceRoll = Int(arc4random_uniform(6000000) + 1)
        let apiService = APIManager(
            url: "\(APIs.baseURL)activation_code?code=\(self.tfEmailAddress.text!)&imei=asd\(diceRoll)",
            parameters: parameters)
        apiService.postRequest { (result : Result<[String:Any],APIError>) in
            
            switch result {
            case .success(let json):
                print("json is",json)
                
                
                let Token = json["AccountToken"] as? String
                let FirstName = json["TrackerName"] as? String
                let TRACKER_ID = json["TrackerID"] as? Int
                let AccountID = json["AccountID"] as? Int
                
                UserDefaults.standard.set(TRACKER_ID, forKey: "TRACKER_ID")
                UserDefaults.standard.set(AccountID, forKey: "ACCOUNT_ID")
                UserDefaults.standard.set(Token, forKey: "TOKEN")
                UserDefaults.standard.set(FirstName, forKey: "FIRST_NAME")
                UserDefaults.standard.set("", forKey: "LAST_NAME")
                UserDefaults.standard.set("CHILD", forKey: "USER_TYPE")
                UserDefaults.standard.set("YES", forKey: "LOCATION_UPDATE")
                
                print("time stamp is",Token)
                print("tracker id is",TRACKER_ID)
                
                DispatchQueue.main.async {
//                    self.showToast(message: "Logged in successfully!")
//                    Loader.shared.stopAnimating()
                    self.performSegue(withIdentifier: "Login_TO_DeviceViewController", sender: self)
                }

            case .failure(let failure):
                print(failure.errorDescription)
                if (failure.errorDescription != nil && failure.errorDescription! == "500"){
                    DispatchQueue.main.async {
                        self.showToast(message: "Invalid credentials!")
                    }
                }
                DispatchQueue.main.async {
                    Loader.shared.stopAnimating()
                }
            }
        }
        
        /*
         {
         "AccountID": 3302,
           "TrackerID": 5944,
           "AccountToken": "dcfdc841-362d-490d-8153-69965e08578b",
           "TrackerName": "Azhar"
         }
         */
    }
    
    func GetTrackerID_API(){
        let apiService = APIManager(
            url: "\(APIs.baseURL)trackers/account",
            parameters: nil)
        apiService.getRequest{ (result : Result<[String:Any],APIError>) in
            
            switch result {
            case .success(let json):
                print("json is",json)
                
                let AccountID = json["AccountID"] as? Int
                let Tracker_ID = json["Tracker_ID"] as? Int
                
                print("time stamp is",AccountID!)
                print("tracker id is",Tracker_ID!)
                UserDefaults.standard.set(Tracker_ID!, forKey: "TRACKER_ID")
                
                DispatchQueue.main.async {
                    self.showToast(message: "Logged in successfully!")
                    Loader.shared.stopAnimating()
                    self.performSegue(withIdentifier: "Login_TO_DeviceViewController", sender: self)
                }
                
            
            case .failure(let failure):
                print(failure.errorDescription)
                Loader.shared.stopAnimating()
            }
        }
    }
    
    @IBAction func Login_Clicked(_ sender: Any) {
        print("Login_Clicked")
        if(self.vPassword.isHidden){
            if ((self.tfEmailAddress.text!).isEmpty) {
                self.showToast(message: "Enter Promo Code or Email")
            }
            else if((self.tfEmailAddress.text!).count < 9){
                self.showToast(message: "Enter valid Promo Code")
            }
            else
            {
                if (!(self.tfEmailAddress.text!).isValidEmail())
                {
                    DispatchQueue.main.async {
                    self.CallPromoActivationAPI()
                    }
                }
                else
                {
                    self.vPassword.isHidden = false
                }
            }
            
        }
        else{
        if ((self.tfEmailAddress.text!).isEmpty) {
            self.showToast(message: "Enter your Email address")
        }else if (!(self.tfEmailAddress.text!).isValidEmail()) {
            self.showToast(message: "Invalid Email address")
        }else if ((self.tfPassword.text!).isEmpty) {
            self.showToast(message: "Enter your password")
        }else{
            self.CallLoginAPI()
        }
        }
        
       // self.performSegue(withIdentifier: "Login_TO_DeviceViewController", sender: self)
    }
    
    @IBAction func Forgot_Password_Clicked(_ sender: Any) {
        
        self.performSegue(withIdentifier: "Login_to_ForgotPassword", sender: self)
        
//        let vc = storyboard?.instantiateViewController(withIdentifier: "ForgetPasswordVc") as? ForgetPasswordVc
//        vc?.modalPresentationStyle = .fullScreen
//        present(vc!, animated: true, completion: nil)
//        let url = "\(APIs.baseURL)accounts?first_name=\(self.tfFirstName.text!)&last_name=\(self.tfLastName.text!)&email=\(emailData)&password=\(self.tfPassword.text!)&phone_number=\(phoneData)&role=3"
        
//        guard let emailData = (self.tfEmailAddress.text!).addingPercentEncoding(withAllowedCharacters: .whitespacesAndNewlines) else{
//            return
//        }
//        Loader.shared.startAnimating(in: self.view)
//        let apiKey = UserDefaults.standard.string(forKey: "TOKEN")
//        let header : HTTPHeaders = [
//            "Accept":"application/json",
//            "apiKey": apiKey!
//        ]
//
//        let url = "https://globotrac-api-dev.azurewebsites.net/accounts/forgot_password?email=\(emailData)"
//
//        AF.request(url, method: .post, encoding: JSONEncoding.default, headers: header).response { response in
//            switch response.result{
//            case .success(let data):
//                do {
//                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject]
//                    if let dictionary = json as? [String: Any] {
//                        for (key , value) in dictionary{
//                            print(key, value)
//                            self.showToast(message: "\(value)")
//                            Loader.shared.stopAnimating()
//                        }
//                    }
//                }catch{
//                    print("fail to serialize json")
//
//                }
//            case .failure(_):
//                print("nothing")
//            }
//        }
        
        
    }
    
    @IBAction func AlreadyHaveAccount_Clicked(_ sender: Any) {
        print("AlreadyHaveAccount_Clicked")//
        self.performSegue(withIdentifier: "Login_To_Signup", sender: self)
    }
    
    
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LoginViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //self.view.endEditing(true)
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if (textField == tfEmailAddress){
            if((textField.text!).isValidEmail()){
                self.vPassword.isHidden = false
            }
            else
            {
                self.vPassword.isHidden = true
            }
        }
        
        return true
    }
}

extension LoginViewController:NetworkCheckObserver{
    
    func statusDidChange(status: NWPath.Status) {
        if status == .satisfied {
            print("Network Available....")
            self.isNetworkAvailable = true
        }else if status == .unsatisfied {
            //Show no network alert
            print("Network not Available....")
            self.isNetworkAvailable = false
        }
    }
    func checkNetworkStatus() {
        if networkCheck.currentStatus == .satisfied{
            //Do something
            print("Network Available....")
            self.isNetworkAvailable = true
        }else{
            //Show no network alert
            print("Network not Available....")
            self.isNetworkAvailable = false
        }
        networkCheck.addObserver(observer: self)
    }
}
