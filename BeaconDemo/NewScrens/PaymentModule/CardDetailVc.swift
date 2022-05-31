//
//  CardDetailVc.swift
//  KBeaconDemo_Ios
//
//  Created by Hashmi on 30/05/2022.
//  Copyright © 2022 hogen. All rights reserved.
//

import UIKit
import iOSDropDown

class CardDetailVc: UIViewController, UITextFieldDelegate {
    
    //MARK: UIView
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var cardHeaderView: UIView!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    //MARK: Textfields
    @IBOutlet weak var firstTf: UITextField!
    @IBOutlet weak var seconfTf: UITextField!
    @IBOutlet weak var thirdTf: UITextField!
    @IBOutlet weak var fourthTf: UITextField!
    
    @IBOutlet weak var cardHoldernameTf: UITextField!
    
    @IBOutlet weak var monthTf: DropDown!
    @IBOutlet weak var yearTf: DropDown!
    
    @IBOutlet weak var cvvTf: UITextField!
    @IBOutlet weak var firstAddressTf: UITextField!
    @IBOutlet weak var secondAddressTf: UITextField!
    @IBOutlet weak var cityTf: UITextField!
    
    @IBOutlet weak var dropDownTfOne: DropDown!
    @IBOutlet weak var dropDownTfSecond: DropDown!
    
    @IBOutlet weak var zipCodeTf: UITextField!
    @IBOutlet weak var postalCodeTf: UITextField!
    
    
    var cardNumber = ""
    let monthArr =  ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myScrollView.bounces = false
        monthTf.delegate = self
        yearTf.delegate = self
        txtFeildAction()
        
        //MARK: Selected year
        let arr = Date().near(year: 7)
        yearTf.optionArray = arr.compactMap { String($0) }
        yearTf.didSelect { selectedText, index, id in
            print(selectedText, index, id)
        }
        
        monthTf.optionArray = monthArr
        monthTf.didSelect { selectedText, index, id in
            print(selectedText, index, id)
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.styling()
    }
    //MARK: Button Actions
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func nextBtn(_ sender: Any) {
    }
    
    func styling(){
        nextBtn.layer.cornerRadius = 10.0
        cardHeaderView.layer.cornerRadius = 10.0
    }
    
    //MARK: Textfiled switching functionality
    
    func txtFeildAction(){
        firstTf.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: UIControl.Event.editingChanged)
        seconfTf.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: UIControl.Event.editingChanged)
        thirdTf.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: UIControl.Event.editingChanged)
        fourthTf.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: UIControl.Event.editingChanged)
        cvvTf.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: UIControl.Event.editingChanged)
    }
    
    
    @objc func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == firstTf {
            if textField.text?.count == 4 {
                seconfTf.becomeFirstResponder()
            }
        }else if textField == seconfTf{
            if textField.text?.count == 4{
                thirdTf.becomeFirstResponder()
            }
        }else if textField == thirdTf{
            if textField.text?.count == 4{
                    fourthTf.becomeFirstResponder()
            }
        }else if textField == fourthTf{
            if textField.text?.count == 4{
                textField.resignFirstResponder()
            }
        }else if textField == cvvTf{
            if textField.text?.count == 3{
                textField.resignFirstResponder()
            }
        }
        self.cardNumber = firstTf.text! + seconfTf.text! + thirdTf.text! + fourthTf.text!
        print(cardNumber)
        
//        if final.count == 4{
//            verifyEmail()
//            hideKeyboard()
//        }else{
//            return
//        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == monthTf{
            view.endEditing(true)
        }else if textField == yearTf{
            view.endEditing(true)
        }
        
    }
    
}

extension Date {
    var day: Int {
        return Calendar.current.component(.year, from: self)
    }
    func adding(days: Int) -> Date {
        return Calendar.current.date(byAdding: .year, value: days, to: self)!
    }
    var last7days: [Int] {
        return (1...7).map {
            adding(days: -$0).day
        }
    }
    func near(year: Int) -> [Int] {
        return year == 0 ? [day] : (1...abs(year)).map {
            adding(days: $0 * (year < 0 ? -1 : 1) ).day
        }
    }
}
