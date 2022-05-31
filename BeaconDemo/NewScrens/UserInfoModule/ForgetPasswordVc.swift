//
//  ForgetPasswordVc.swift
//  KBeaconDemo_Ios
//
//  Created by Hashmi on 14/03/2022.
//  Copyright © 2022 hogen. All rights reserved.
//

import UIKit
import Alamofire

class ForgetPasswordVc: UIViewController {

    @IBOutlet weak var vEmail: UIView!
    
    @IBOutlet weak var emailTf: UITextField!
    
    @IBOutlet weak var submitBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.vEmail.layer.cornerRadius = 10
        self.vEmail.layer.borderWidth = 1
        self.vEmail.layer.borderColor = UIColor.gray.cgColor
        
        self.vEmail.backgroundColor = UIColor.clear
        
        self.submitBtn.backgroundColor = Colors.GREEN_BUTTON_COLOR
        self.submitBtn.titleLabel?.textColor = UIColor.white
        self.submitBtn.layer.cornerRadius = 10
        
        self.submitBtn.setTitleColor(.white, for: .normal)
        
        self.emailTf.attributedPlaceholder = NSAttributedString(string: "Email address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
    }
    
    @IBAction func Back_Clicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitBtn(_ sender: Any) {
        if emailTf.text?.isEmpty == true{
            showToast(message: "Please enter Email address")
        }else{
                    guard let emailData = (self.emailTf.text!).addingPercentEncoding(withAllowedCharacters: .whitespacesAndNewlines) else{
                        return
                    }
                    Loader.shared.startAnimating(in: self.view)
            
            let parameters  = [
                "email": self.emailTf.text!,
      
            ]
            
            let apiService = APIManager(
                url: "\(APIs.baseURL)accounts/forgot_password?email=\(emailData)",
                parameters: parameters)
            apiService.postRequest { (result : Result<[String:Any],APIError>) in
                
                switch result {
                case .success(let json):
                    print("json is",json)
                    let Message = json["Message"] as? String
                    let Status = json["Status"] as? Int
                    
                    DispatchQueue.main.async {
                        if(Status == 0){
                            self.showAlert(title: "Forgot password", message: Message!)
                            Loader.shared.stopAnimating()
                        } else if(Status == 1){
                            self.showAlert(title: "Forgot password", message: Message!)
                            Loader.shared.stopAnimating()
                        }

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
    

}
