//
//  InviteNewFreindsVc.swift
//  KBeaconDemo_Ios
//
//  Created by Hashmi on 09/03/2022.
//  Copyright © 2022 hogen. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift


class InviteNewFreindsVc: UIViewController {
    
    @IBOutlet weak var myScrollView: UIScrollView!
    
    @IBOutlet weak var vPopUpInvite: UIView!
    @IBAction func backBtn(_ sender: Any) {
       // dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var nameTf: UITextField!
    @IBOutlet weak var phoneTf: UITextField!
    @IBOutlet weak var emailTf: UITextField!
    
    @IBOutlet weak var inviteBtn: UIButton!
    @IBAction func inviteBtn(_ sender: Any) {
//        let vc = storyboard?.instantiateViewController(withIdentifier: "UserProfileVC") as? UserProfileVC
//        vc?.modalPresentationStyle = .fullScreen
//        present(vc!, animated: true, completion: nil)
        if ((self.phoneTf.text!).isEmpty && (self.emailTf.text!).isEmpty) {
            self.showToast(message: "Enter Email or Phone number")
        }else if (!(self.emailTf.text!).isEmpty) {
            if (!(self.emailTf.text!).isValidEmail()) {
                self.showToast(message: "Invalid Email address")
            }
            else{
                self.vPopUpInvite.isHidden = false
            }
        }else if ((self.phoneTf.text!).count < 9){
            self.showToast(message: "Invalid Phone number")
            
        }
        else{
            self.vPopUpInvite.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myScrollView.bounces = false
        hideKeyboardWhenTappedAround()
        self.nameTf.delegate = self
        self.phoneTf.delegate = self
        self.emailTf.delegate = self
        
        self.vPopUpInvite.isHidden = true
    }

    override func viewDidLayoutSubviews() {
        nameTf.layer.borderColor = UIColor.lightGray.cgColor
        nameTf.layer.borderWidth = 0.5
        nameTf.layer.cornerRadius = 10
        phoneTf.layer.borderColor = UIColor.lightGray.cgColor
        phoneTf.layer.borderWidth = 0.5
        phoneTf.layer.cornerRadius = 10
        emailTf.layer.borderColor = UIColor.lightGray.cgColor
        emailTf.layer.borderWidth = 0.5
        emailTf.layer.cornerRadius = 10
        inviteBtn.layer.cornerRadius = 10
        IQKeyboardManager.shared.enable = true

    }
    
    @IBAction func OK_Invite_Clicked(_ sender: Any) {
        self.vPopUpInvite.isHidden = true
        self.AddTrackerID_API()
    }
    
    @IBAction func Cancel_invite_Clicked(_ sender: Any) {
        self.vPopUpInvite.isHidden = true
    }
    
    func AddTrackerID_API(){
        self.view.endEditing(true)
        Loader.shared.startAnimating(in: self.view)
        
        let parameters  = [
            "username": self.nameTf.text!,
            "password": self.phoneTf.text!
        ]
        
    
        let apiService = APIManager(
            url: "\(APIs.baseURL)trackers/invite?name=\(self.nameTf.text!)&phone_number=\(self.phoneTf.text!)&email=\(self.emailTf.text!)",
            parameters: parameters)
        apiService.getRequest{ (result : Result<[String:Any],APIError>) in
            
            switch result {
            case .success(let json):
                print("json is",json)
                
                
                DispatchQueue.main.async {
                    self.showToast(message: "User Invited!")
                    self.nameTf.text = ""
                    self.emailTf.text = ""
                    self.phoneTf.text = ""
                    Loader.shared.stopAnimating()
                  //  self.performSegue(withIdentifier: "Login_TO_DeviceViewController", sender: self)
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
extension InviteNewFreindsVc: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //self.view.endEditing(true)
        textField.resignFirstResponder()
        return true
    }
}

extension UIViewController{
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
