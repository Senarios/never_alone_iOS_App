//
//  SubscriptionVc.swift
//  KBeaconDemo_Ios
//
//  Created by Hashmi on 30/05/2022.
//  Copyright © 2022 hogen. All rights reserved.
//

import UIKit

class SubscriptionVc: UIViewController {
    
    //MARK: UIViews
    
    @IBOutlet weak var premierView: UIView!
    @IBOutlet weak var feeView: UIView!
    @IBOutlet weak var closeAccView: UIView!
    @IBOutlet weak var myScrollView: UIScrollView!
    
    //MARK: ImageViews
    @IBOutlet weak var premierPaidImg: UIImageView!
    @IBOutlet weak var feeImg: UIImageView!
    @IBOutlet weak var closeAccImg: UIImageView!
    
    //MARK: Button Out lets
    @IBOutlet weak var premierPaidBtn: UIButton!
    @IBOutlet weak var feeBtn: UIButton!
    @IBOutlet weak var closeAccBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    
    
    var selectedString = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        myScrollView.bounces = false
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        styling()
    }
    func styling(){
        premierView.layer.cornerRadius = 10.0
        premierView.layer.borderColor = UIColor.black.cgColor
        premierView.layer.borderWidth = 1.0
        
        feeView.layer.cornerRadius = 10.0
        feeView.layer.borderColor = UIColor.black.cgColor
        feeView.layer.borderWidth = 1.0
        
        closeAccView.layer.cornerRadius = 10.0
        closeAccView.layer.borderColor = UIColor.black.cgColor
        closeAccView.layer.borderWidth = 1.0
        saveBtn.layer.cornerRadius = 10.0
    }
    
    //MARK: Button Actions
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func premierPaidBtn(_ sender: Any) {
        checkBox(btn: premierPaidBtn)
    }
    @IBAction func feeBtn(_ sender: Any) {
        checkBox(btn: feeBtn)
    }
    @IBAction func closeAccBtn(_ sender: Any) {
        checkBox(btn: closeAccBtn)
    }
    @IBAction func saveBtn(_ sender: Any) {
        if selectedString.isEmpty != true{
            let vc = storyboard?.instantiateViewController(withIdentifier: "CardDetailVc") as? CardDetailVc
            vc?.modalPresentationStyle = .fullScreen
            present(vc!, animated: true, completion: nil)
        }else{
            showToast(message: "Please Select Type of Payment")
        }
        
    }
    
    func checkBox(btn: UIButton){
        if btn == premierPaidBtn{
            premierPaidImg.image = UIImage(named: "check")
            feeImg.image = UIImage(named: "uncehck")
            closeAccImg.image = UIImage(named: "uncehck")
            selectedString = "premier"
        }else if btn == feeBtn{
            premierPaidImg.image = UIImage(named: "uncehck")
            feeImg.image = UIImage(named: "check")
            closeAccImg.image = UIImage(named: "uncehck")
            selectedString = "fee"
        }else if btn == closeAccBtn{
            premierPaidImg.image = UIImage(named: "uncehck")
            feeImg.image = UIImage(named: "uncehck")
            closeAccImg.image = UIImage(named: "check")
            selectedString = "acc"
        }
        
    }
    
}
