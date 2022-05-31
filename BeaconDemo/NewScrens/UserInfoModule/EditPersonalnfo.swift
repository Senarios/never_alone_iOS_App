//
//  EditPersonalnfo.swift
//  KBeaconDemo_Ios
//
//  Created by Hashmi on 09/03/2022.
//  Copyright © 2022 hogen. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class EditPersonalnfo: UIViewController {
    
    
    @IBOutlet weak var vPhoneNumber: UIView!
    @IBOutlet weak var vEmail: UIView!
    
    //MARK: Buttons
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var saveBtn: UIButton!
    @IBAction func saveBtn(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "SubscriptionVc") as? SubscriptionVc
        vc?.modalPresentationStyle = .fullScreen
        present(vc!, animated: true, completion: nil)
        
        //checkFields()
    }
    
    //MARK: Views
    @IBOutlet weak var myScrollView: UIScrollView!
    
    @IBOutlet weak var firstNameView: UIView!
    @IBOutlet weak var lastNameView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var phoneView: UIView!

    //MARK: Textfields
    
    @IBOutlet weak var firstNameTf: UITextField!
    @IBOutlet weak var lastNameTf: UITextField!
    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var phoneTf: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        myScrollView.bounces = false
        self.emailTf.isEnabled = false
        
        hideKeyboardWhenTappedAround()
        
        let FIRST_NAME = UserDefaults.standard.string(forKey: "FIRST_NAME")
        let LAST_NAME = UserDefaults.standard.string(forKey: "LAST_NAME")
        let EMAIL_ADDRESS = UserDefaults.standard.string(forKey: "EMAIL_ADDRESS")
        let USER_TYPE = UserDefaults.standard.string(forKey: "USER_TYPE")
       
        if(FIRST_NAME != nil){
            self.firstNameTf.text = "\(FIRST_NAME!)"
        }
        if(LAST_NAME != nil){
            self.lastNameTf.text = "\(LAST_NAME!)"
        }
        if(EMAIL_ADDRESS != nil){
            self.emailTf.text = "\(EMAIL_ADDRESS!)"
        }
//        if(EMAIL_ADDRESS != nil){
//            self.phoneTf.text = "\(EMAIL_ADDRESS!)"
//        }
        if(USER_TYPE! == "CHILD"){
            self.vEmail.isHidden = true
            self.vPhoneNumber.isHidden = true
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        styling()
        IQKeyboardManager.shared.enable = true
    }
    
    func checkFields(){
        if firstNameTf.text?.isEmpty == true{
            showToast(message: "Enter First name")
        }else if lastNameTf.text?.isEmpty == true{
            showToast(message: "Enter Last name")
        }else{
        //else if phoneTf.text?.isEmpty == true{
      //      showToast(message: "Enter Phone No.")
       // }else{
            self.CallEditPersonalInfoAPI()
        }
    }
    func styling(){
        saveBtn.layer.cornerRadius = 10.0
        firstNameView.layer.cornerRadius = 10.0
        firstNameView.layer.borderWidth = 1
        firstNameView.layer.borderColor = UIColor.lightGray.cgColor
        
        lastNameView.layer.cornerRadius = 10.0
        lastNameView.layer.borderWidth = 1
        lastNameView.layer.borderColor = UIColor.lightGray.cgColor
        
        emailView.layer.cornerRadius = 10.0
        emailView.layer.borderWidth = 1
        emailView.layer.borderColor = UIColor.lightGray.cgColor
        
        phoneView.layer.cornerRadius = 10.0
        phoneView.layer.borderWidth = 1
        phoneView.layer.borderColor = UIColor.lightGray.cgColor
    }
    @objc func onClickDoneButton() {
        self.view.endEditing(true)
    }

    func CallEditPersonalInfoAPI(){
       // self.performSegue(withIdentifier: "Signup_To_Home", sender: self)
        
        let ACCOUNT_ID = UserDefaults.standard.integer(forKey: "ACCOUNT_ID")
        
        guard let emailData = (self.emailTf.text!).addingPercentEncoding(withAllowedCharacters: .whitespacesAndNewlines) else{
            return
        }
        
        guard let phoneNumberData = (self.phoneTf.text!).addingPercentEncoding(withAllowedCharacters: .whitespacesAndNewlines) else{
            return
        }
        
        self.view.endEditing(true)
        Loader.shared.startAnimating(in: self.view)
        let parameters  = [
            "username": self.firstNameTf.text!,
            "password": self.lastNameTf.text!
        ]
        
        let apiService = APIManager(
            url: "\(APIs.baseURL)accounts/update?account_id=\(ACCOUNT_ID)&first_name=\(self.firstNameTf.text!)&last_name=\(self.lastNameTf.text!)&email=\(emailData)&phone_number=\(phoneNumberData)&role=3",
            parameters: parameters)
        apiService.postRequest { (result : Result<[String:Any],APIError>) in
            
            switch result {
            case .success(let json):
                print("json is",json)
            
                DispatchQueue.main.async {
                    UserDefaults.standard.set(self.firstNameTf.text!, forKey: "FIRST_NAME")
                    UserDefaults.standard.set(self.lastNameTf.text!, forKey: "LAST_NAME")
                    Loader.shared.stopAnimating()
                    self.showToast(message: "Account Profile Updated!")
                }

            case .failure(let failure):
                print(failure.errorDescription)
                Loader.shared.stopAnimating()
            }
        }
        
    }
}
