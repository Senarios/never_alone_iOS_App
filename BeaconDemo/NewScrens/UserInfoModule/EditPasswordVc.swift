//
//  EditPasswordVc.swift
//  KBeaconDemo_Ios
//
//  Created by Hashmi on 09/03/2022.
//  Copyright © 2022 hogen. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class EditPasswordVc: UIViewController {

    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var saveBtn: UIButton!
    @IBAction func saveBtn(_ sender: Any) {
        checkFields()
    }
    //MARK: Views
    @IBOutlet weak var myScrollView: UIScrollView!
    
    @IBOutlet weak var currecntPassView: UIView!
    @IBOutlet weak var newPasswordView: UIView!
    @IBOutlet weak var confirmPasswordView: UIView!

    //MARK: Textfields
    @IBOutlet weak var currentPassTf: UITextField!
    @IBOutlet weak var newPassTf: UITextField!
    @IBOutlet weak var confirmPassTf: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        myScrollView.bounces = false
        hideKeyboardWhenTappedAround()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        styling()
        IQKeyboardManager.shared.enable = true
    }
    
    func checkFields(){
        if currentPassTf.text?.isEmpty == true{
            showToast(message: "Enter Password")
        }else if newPassTf.text?.isEmpty == true{
            showToast(message: "Minimum 8 characters password")
        }else if confirmPassTf.text?.isEmpty == true{
            showToast(message: "Enter Confirm Password")
        }else if confirmPassTf.text! != newPassTf.text!{
            showToast(message: "New and Re-Type Password does not match!")
        }else{
            self.UpdatePassword_API()
        }
    }
    func styling(){
        saveBtn.layer.cornerRadius = 10.0
        currecntPassView.layer.cornerRadius = 10.0
        currecntPassView.layer.borderColor = UIColor.lightGray.cgColor
        currecntPassView.layer.borderWidth = 1
        newPasswordView.layer.cornerRadius = 10.0
        newPasswordView.layer.borderColor = UIColor.lightGray.cgColor
        newPasswordView.layer.borderWidth = 1
        confirmPasswordView.layer.cornerRadius = 10.0
        confirmPasswordView.layer.borderColor = UIColor.lightGray.cgColor
        confirmPasswordView.layer.borderWidth = 1
    }
    
    func UpdatePassword_API(){
        let parameters  = [
            "username": self.currentPassTf.text!,
            "password": self.newPassTf.text!
        ]
        
        let apiService = APIManager(
            url: "\(APIs.baseURL)accounts/change_password?current_password=\(self.currentPassTf.text!)&new_password=\(self.newPassTf.text!)",
            parameters: parameters)
        apiService.putRequest { (result : Result<[String:Any],APIError>) in
            
            switch result {
            case .success(let json):
                print("json is",json)
                let Message = json["Message"] as? String
                let Status = json["Status"] as? Int
                
                DispatchQueue.main.async {
                    if(Status == 0){
                        self.showToast(message: Message!)
                        Loader.shared.stopAnimating()
                    } else if(Status == 1){
                        self.showToast(message: Message!)
                        Loader.shared.stopAnimating()
                    }

                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    self.navigationController?.popViewController(animated: true)
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
