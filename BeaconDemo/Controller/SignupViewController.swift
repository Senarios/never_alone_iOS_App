//
//  SignupViewController.swift
//  KBeaconDemo_Ios
//
//  Created by Azhar on 3/1/22.
//  Copyright © 2022 hogen. All rights reserved.
//

import UIKit
import Network
import IQKeyboardManagerSwift

class SignupViewController: UIViewController {
    
    @IBOutlet weak var vFirstName: UIView!
    @IBOutlet weak var vLastName: UIView!
    @IBOutlet weak var vPhoneNumber: UIView!
    @IBOutlet weak var vEmail: UIView!
    @IBOutlet weak var vPassword: UIView!
        
    @IBOutlet weak var tfFirstName: UITextField!
    @IBOutlet weak var tfLastName: UITextField!
    @IBOutlet weak var tfPhoneNumber: UITextField!
    @IBOutlet weak var tfEmailAddress: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
        
    @IBOutlet weak var btnSignUp: UIButton!
    
    var isNetworkAvailable: Bool = false
    var networkCheck = NetworkCheck.sharedInstance()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setControls()
    }
    
    func setControls(){

     //   self.tfEmailAddress.text = "salmank888@gmail.com" // 123456
        
        self.vFirstName.layer.cornerRadius = 10
        self.vFirstName.layer.borderWidth = 1
        self.vFirstName.layer.borderColor = UIColor.gray.cgColor
        
        self.vLastName.layer.cornerRadius = 10
        self.vLastName.layer.borderWidth = 1
        self.vLastName.layer.borderColor = UIColor.gray.cgColor
        
        self.vPhoneNumber.layer.cornerRadius = 10
        self.vPhoneNumber.layer.borderWidth = 1
        self.vPhoneNumber.layer.borderColor = UIColor.gray.cgColor
        
        self.vEmail.layer.cornerRadius = 10
        self.vEmail.layer.borderWidth = 1
        self.vEmail.layer.borderColor = UIColor.gray.cgColor
        
        self.vPassword.layer.cornerRadius = 10
        self.vPassword.layer.borderWidth = 1
        self.vPassword.layer.borderColor = UIColor.gray.cgColor
        
        hideKeyboardWhenTappedAround()
        IQKeyboardManager.shared.enable = true
        
        self.vFirstName.backgroundColor = UIColor.clear
        self.vLastName.backgroundColor = UIColor.clear
        self.vEmail.backgroundColor = UIColor.clear
        self.vPhoneNumber.backgroundColor = UIColor.clear
        self.vPassword.backgroundColor = UIColor.clear
        
        self.btnSignUp.backgroundColor = Colors.GREEN_BUTTON_COLOR
        self.btnSignUp.titleLabel?.textColor = UIColor.white
        self.btnSignUp.layer.cornerRadius = 10
        
        self.btnSignUp.setTitleColor(.white, for: .normal)
        
        self.tfFirstName.delegate = self
        self.tfLastName.delegate = self
        self.tfEmailAddress.delegate = self
        self.tfPassword.delegate = self
        self.tfPhoneNumber.delegate = self
        
        self.tfFirstName.attributedPlaceholder = NSAttributedString(string: "First Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        self.tfLastName.attributedPlaceholder = NSAttributedString(string: "Last Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        self.tfPhoneNumber.attributedPlaceholder = NSAttributedString(string: "Phone Number", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        self.tfEmailAddress.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        self.tfPassword.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
    }
    

    @IBAction func Back_Clicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func SignUp_Clicked(_ sender: Any) {
        print("Login_Clicked")
        
//        let vc = storyboard?.instantiateViewController(withIdentifier: "InviteNewFreindsVc") as? InviteNewFreindsVc
//        vc?.modalPresentationStyle = .fullScreen
//        present(vc!, animated: true, completion: nil)

        if ((self.tfFirstName.text!).isEmpty) {
            self.showToast(message: "Enter your First Name")
        }else
        if ((self.tfLastName.text!).isEmpty) {
            self.showToast(message: "Enter your Last Name")
        }else
        if ((self.tfPhoneNumber.text!).isEmpty || (self.tfPhoneNumber.text!).count < 9) {
            self.showToast(message: "Enter valid Phone Number")
        }else
        if ((self.tfEmailAddress.text!).isEmpty) {
            self.showToast(message: "Enter your Email address")
        }else if (!(self.tfEmailAddress.text!).isValidEmail()) {
            self.showToast(message: "Invalid Email address")
        }else if ((self.tfPassword.text!).isEmpty) {
            self.showToast(message: "Enter your password")
        }else{
            self.CallRegisterAPI()
        }

       // self.performSegue(withIdentifier: "Login_TO_DeviceViewController", sender: self)
    }
    
    func CallRegisterAPI(){
       // self.performSegue(withIdentifier: "Signup_To_Home", sender: self)
        if (networkCheck.currentStatus != .satisfied){
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
        
        guard let emailData = (self.tfEmailAddress.text!).addingPercentEncoding(withAllowedCharacters: .whitespacesAndNewlines) else{
            return
        }
        
        guard let phoneData = (self.tfPhoneNumber.text!).addingPercentEncoding(withAllowedCharacters: .whitespacesAndNewlines) else{
            return
        }
        
        let apiService = APIManager(
            url: "\(APIs.baseURL)accounts?first_name=\(self.tfFirstName.text!)&last_name=\(self.tfLastName.text!)&email=\(emailData)&password=\(self.tfPassword.text!)&phone_number=\(phoneData)&role=3",
            parameters: parameters)
        apiService.postRequest { (result : Result<[String:Any],APIError>) in
            
            switch result {
            case .success(let json):
                print("json is",json)
                
                
//                let Token = json["Token"] as? String
//                let IssueDateTime = json["IssueDateTime"] as? String
//                let ExpiryDateTime = json["ExpiryDateTime"] as? String
//                let FirstName = json["FirstName"] as? String
//                let LastName = json["LastName"] as? String
//                let ID = json["ID"] as? Int
//                let AccountID = json["AccountID"] as? Int
//
//                UserDefaults.standard.set(ID, forKey: "ID")
//                UserDefaults.standard.set(AccountID, forKey: "ACCOUNT_ID")
//                UserDefaults.standard.set(Token, forKey: "TOKEN")
//                UserDefaults.standard.set(IssueDateTime, forKey: "IssueDateTime")
//                UserDefaults.standard.set(ExpiryDateTime, forKey: "ExpiryDateTime")
//                UserDefaults.standard.set(FirstName, forKey: "FIRST_NAME")
//                UserDefaults.standard.set(LastName, forKey: "LAST_NAME")
                
          //      print("time stamp is",Token)
         //       print("tracker id is",ID)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.AddTrackerID_API()
                }
//                DispatchQueue.main.async {
//                    self.AddTrackerID_API()
//                }
                
                
              //  self.GetTrackerID_API()
            
            case .failure(let failure):
                print(failure.errorDescription)
                Loader.shared.stopAnimating()
            }
        }
        
    }
    
    func AddTrackerID_API(){
        let parameters  = [
            "username": self.tfEmailAddress.text!,
            "password": self.tfPassword.text!
        ]
        let diceRoll = Int(arc4random_uniform(60000) + 1)
        let id = UIDevice.current.identifierForVendor?.uuidString
        print("imei=\(id)")
        
        guard let imei = (id!).addingPercentEncoding(withAllowedCharacters: .whitespacesAndNewlines) else{
            return
        }
        
        
        let imeei =  (self.tfPhoneNumber.text!).replacingOccurrences(of: "+", with: "00") + "\(diceRoll)"
        
        guard let phoneData = (self.tfPhoneNumber.text!).addingPercentEncoding(withAllowedCharacters: .whitespacesAndNewlines) else{
            return
        }
        
        let apiService = APIManager(
            url: "\(APIs.baseURL)trackers?model_id=2&phone_number=\(phoneData)&imei=\(imeei)",
            parameters: parameters)
        apiService.postRequest { (result : Result<[String:Any],APIError>) in
            
            switch result {
            case .success(let json):
                print("json is",json)
                
                
                DispatchQueue.main.async {
                    self.showToast(message: "Signup in successfully!")
                  //  Loader.shared.stopAnimating()
                  //  self.performSegue(withIdentifier: "Login_TO_DeviceViewController", sender: self)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    self.navigationController?.popViewController(animated: true)
                }
            
            case .failure(let failure):
                print(failure.errorDescription)
               // Loader.shared.stopAnimating()
            }
        }
    }

}
extension SignupViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //self.view.endEditing(true)
        textField.resignFirstResponder()
        return true
    }
}
extension SignupViewController:NetworkCheckObserver{
    
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
