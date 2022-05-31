//
//  UserProfileVC.swift
//  KBeaconDemo_Ios
//
//  Created by Azhar on 3/9/22.
//  Copyright © 2022 hogen. All rights reserved.
//F2F2F7

import UIKit
import Alamofire

class UserProfileVC: UIViewController {

    @IBOutlet weak var lblVersion: UILabel!
    @IBOutlet weak var lblEmailAddress: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var editProfileView: UIView!
    
    @IBOutlet weak var editPasswordView: UIView!
    @IBOutlet weak var vPasswordHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var editSettingView: UIView!

    @IBOutlet weak var popupMainview: UIView!
    @IBOutlet weak var popupView: UIView!
    //MARK: Image Views
    
    @IBOutlet weak var changeImgBtn: UIButton!
    @IBOutlet weak var signoutBtn: UIButton!
    
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var editProfilImage: UIImageView!
    @IBOutlet weak var editPasswordImage: UIImageView!
    @IBOutlet weak var editSettingImage: UIImageView!
    
    var profileImagePicker = UIImagePickerController()
    var imageSize = Float()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: Updating Profile Image
        let Tracker_ID = UserDefaults.standard.integer(forKey: "TRACKER_ID")
        let imageUrl = URL(string: "https://globotracphoto.blob.core.windows.net/dev/\(Tracker_ID).jpg")
        let data = try? Data(contentsOf: imageUrl! as URL)
        if let imageData = data {
            let image = UIImage(data: imageData)
            profileImgView.image = image
        }
        
        
        myScrollView.bounces = false
        profileImagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
    
        //Tap Gestures
        let profiletap = UITapGestureRecognizer(target: self, action: #selector(editProfileSegue))
        editProfileView.addGestureRecognizer(profiletap)
        
        let passwordTap = UITapGestureRecognizer(target: self, action: #selector(editPasswordSegue))
        editPasswordView.addGestureRecognizer(passwordTap)
        
        let settingTap = UITapGestureRecognizer(target: self, action: #selector(editSettingSegue))
        editSettingView.addGestureRecognizer(settingTap)
        let hidePopupViewTap = UITapGestureRecognizer(target: self, action: #selector(showHideImageView))
        popupMainview.addGestureRecognizer(hidePopupViewTap)
        
        popupMainview.isHidden = true
        popupView.isHidden = true
        
        self.lblName.text = ""
        self.lblEmailAddress.text = ""
        
        let FIRST_NAME = UserDefaults.standard.string(forKey: "FIRST_NAME")
        let LAST_NAME = UserDefaults.standard.string(forKey: "LAST_NAME")
        let EMAIL_ADDRESS = UserDefaults.standard.string(forKey: "EMAIL_ADDRESS")
        let USER_TYPE = UserDefaults.standard.string(forKey: "USER_TYPE")
       
        if(FIRST_NAME != nil && LAST_NAME != nil){
            self.lblName.text = "\(FIRST_NAME!) \(LAST_NAME!)"
        }
        if(EMAIL_ADDRESS != nil){
            self.lblEmailAddress.text = "\(EMAIL_ADDRESS!)"
        }
        self.lblVersion.text = "Version: \(AppValues.AppVersion)"
        if(USER_TYPE! == "CHILD"){
            self.editPasswordView.isHidden = true
            self.vPasswordHeightConstraint.constant = 0
        }
        
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        changeImgBtn.layer.cornerRadius = 10.0
        editProfileView.layer.cornerRadius = 10.0
        editPasswordView.layer.cornerRadius = 10.0
        editSettingView.layer.cornerRadius = 10.0
        signoutBtn.layer.cornerRadius = 10.0
        profileImgView.makeRounded()
        
    }
    
    //MARK: Buttons
    @IBAction func backBtn(_ sender: Any) {
        //dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changeImgBtn(_ sender: Any) {
        popupMainview.isHidden = false
        popupView.isHidden = false
    }
    
    @IBAction func signoutBtn(_ sender: Any) {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        
        NotificationCenter.default.post(name:  Notification.Name("DISCONNECT_DOT"), object: nil)
        self.showToast(message: "Disconnecting dots ....")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            dictionary.keys.forEach { key in
                print(key)
                defaults.removeObject(forKey: key)

                let rootViewController = self.view.window?.rootViewController as? UINavigationController

                rootViewController?.setViewControllers([rootViewController!.viewControllers.first!],
                                                       animated: false)

                rootViewController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBOutlet weak var cameraImgPickerbtn: UIButton!
    @IBAction func cameraImgPickerbtn(_ sender: Any) {
        imagePickerEvent(btn: cameraImgPickerbtn)
    }
    
    @IBOutlet weak var gallaryImgPickerBtn: UIButton!
    @IBAction func gallaryImgPickerBtn(_ sender: Any) {
        imagePickerEvent(btn: gallaryImgPickerBtn)
    }
    //MARK: Views
    
    @objc func showHideImageView(){
        popupMainview.isHidden = true
        popupView.isHidden = true
    }
    
    @objc func editProfileSegue(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "EditPersonalnfo") as? EditPersonalnfo
        vc?.modalPresentationStyle = .fullScreen
        present(vc!, animated: true, completion: nil)
    }
    
    @objc func editPasswordSegue(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "EditPasswordVc") as? EditPasswordVc
        vc?.modalPresentationStyle = .fullScreen
        present(vc!, animated: true, completion: nil)
    }
    
    @objc func editSettingSegue(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "SettingMainVc") as? SettingMainVc
        vc?.modalPresentationStyle = .fullScreen
        present(vc!, animated: true, completion: nil)
    }
    
    func imagePickerEvent(btn: UIButton){
        if btn == gallaryImgPickerBtn{
            profileImagePicker.sourceType = .photoLibrary
            profileImagePicker.allowsEditing = true
            present(profileImagePicker, animated: true, completion: nil)
        }else if btn == cameraImgPickerbtn{
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                profileImagePicker.sourceType = .camera
                profileImagePicker.allowsEditing = true
                present(profileImagePicker, animated: true, completion: nil)
            }else{
                showToast(message: "Camera Not Availabe")
            }
           
        }
    }
    
    //MARK: upload profile Image
    func uploaddingImage( imageData: UIImage){
        
        Loader.shared.startAnimating(in: self.view)
        let apiKey = UserDefaults.standard.string(forKey: "TOKEN")
        let Tracker_ID = UserDefaults.standard.integer(forKey: "TRACKER_ID")
        let header : HTTPHeaders = [
            "Accept":"application/json",
            "apiKey": apiKey!, //"aca5ba61-f6f0-4c9c-8801-078e333382df"
        ]
        
        if let imageDataJPG = imageData.jpegData(compressionQuality: 0.1) {
            self.imageSize = Float(Double(imageDataJPG.count)/1024/1024)
            print(imageSize)
           
            AF.upload(multipartFormData: { multipartFormData in
                guard let image = self.profileImgView.image else { return }
                let jpegData = image.jpegData(compressionQuality: 1.0)
                multipartFormData.append(imageDataJPG, withName: "image", fileName: "image.jpeg", mimeType: "image/jpeg")
                
            }, to: "\(APIs.baseURL)trackers/update_photo?tracker_id=\(Tracker_ID)", headers: header).response { response in
                
                switch response.result {
                case .success(let data):
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject]
                        if let dictionary = json as? [String: Any] {
                            for (key , value) in dictionary{
                                print(key, value)
                                self.showToast(message: "\(value)")
                                Loader.shared.stopAnimating()
                            }
                        }
                    }catch{
                        print("fail to serialize json")
                        
                    }
                case .failure(_):
                    print("nothing")
                }
            }
            
        }
    }
}

extension UserProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
 
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            profileImgView.image = image
            dismiss(animated: true, completion: nil)
            popupView.isHidden = true
            popupMainview.isHidden = true
            uploaddingImage(imageData: image)
            
        }
    }
    
}

extension UIImageView {

    func makeRounded() {

        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
