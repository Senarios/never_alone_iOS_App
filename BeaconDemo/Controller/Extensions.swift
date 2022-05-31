//
//  Extensions.swift
//
//  Created by Azhar on 20/02/2022.
//  Copyright © 2022 Senarios. All rights reserved.
//

import Foundation
import UIKit

extension Double
{
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Dictionary {
    var myDesc: String {
        get {
            var v = ""
            var counter = 0
            for (key, value) in self {
                if counter > 0 {
                    v += "&"
                }
                //let lValue = "\(value)".utf8EncodedString()
                v += ("\(key)=\(value)")
                counter += 1
            }
            return v
        }
    }
}

extension UIView
{
    func setBorders(cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: CGColor)
    {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor
    }
}

extension String
{
    var isNumber : Bool {
        get{
            return !self.isEmpty && self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
        }
    }
    
    func isValidEmail() -> Bool
    {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var isValidLinkedinLink: Bool {
        NSPredicate(format: "SELF MATCHES %@", "http(s)?:\\/\\/([\\w]+\\.)?linkedin\\.com\\/in\\/[A-z0-9_-]+").evaluate(with: self)
    }
    
    func isStringContain(_ char : Character) -> Bool{
        
        for char in self{
            if char == "@"{
                return true
            }
            
        }
        return false
    }
    
    func isStartWithAlphabet() -> Bool{
        if let value = self.first?.asciiValue{
            if (value >= 97 && value <= 122) || (value >= 65 && value <= 90){
                return true
            }
            return false
        }
        return false
    }

}

extension NSMutableAttributedString
{
    func bold(text:String) -> NSMutableAttributedString
    {
        let attrs:[NSAttributedString.Key:AnyObject] = [NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue) : UIFont.boldSystemFont(ofSize: 13)]
        let boldString = NSMutableAttributedString(string:"\(text)", attributes:attrs)
        self.append(boldString)
        return self
    }
    
    func normal(text:String)->NSMutableAttributedString
    {
        let normal =  NSAttributedString(string: text)
        self.append(normal)
        return self
    }
    
    func bold(text:String, fontSize: CGFloat) -> NSMutableAttributedString
    {
        let attrs:[NSAttributedString.Key:AnyObject] = [NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue) : UIFont.boldSystemFont(ofSize: fontSize)]
        let boldString = NSMutableAttributedString(string:"\(text)", attributes:attrs)
        self.append(boldString)
        return self
    }
    
    func normal(text:String , fontSize: CGFloat) ->NSMutableAttributedString
    {
        let attrs:[NSAttributedString.Key:AnyObject] = [NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue) : UIFont.systemFont(ofSize: fontSize)]
        let boldString = NSMutableAttributedString(string:"\(text)", attributes:attrs)
        self.append(boldString)
        return self
    }
}

extension UITextField
{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[kCTForegroundColorAttributeName as NSAttributedString.Key: newValue!])
        }
    }
}

internal extension Array
{
    /**
     Returns the duplicate array
     */
    internal func get_DuplicateArray() -> NSArray
    {
        return NSArray(array:self, copyItems: true)
    }
}

public extension UIImage
{
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in PNG format
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the PNG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    var png: Data? { return self.pngData() }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ quality: JPEGQuality) -> Data? {
        return self.jpegData(compressionQuality: quality.rawValue)
    }
    
    var rounded: UIImage? {
        let imageView = UIImageView(image: self)
        imageView.layer.cornerRadius = min(size.height/4, size.width/4)
        imageView.layer.masksToBounds = true
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    var circle: UIImage? {
        let square = CGSize(width: min(size.width, size.height), height: min(size.width, size.height))
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: square))
        imageView.contentMode = .scaleAspectFill
        imageView.image = self
        imageView.layer.cornerRadius = square.width/2
        imageView.layer.masksToBounds = true
        
        imageView.layer.borderWidth = 1.5
        imageView.layer.borderColor = UIColor.white.cgColor
        
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
    convenience init(view: UIView) {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.init(cgImage: image!.cgImage!)
        }
        else{
            let image = UIImage(named: "shadow_line")
            self.init(cgImage: (image?.cgImage!)!)
        }
    }
    


    public static func loadFrom(url: URL, completion: @escaping (_ image: UIImage?) -> ()) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    completion(UIImage(data: data))
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }

    
}

extension TimeInterval
{
    var seconds: Int {
        return Int(self) % 60
    }
    
    var minutes: Int {
        return (Int(self) / 60 ) % 60
    }
    
    var hours: Int {
        return Int(self) / 3600
    }
    
    var stringValu: String
    {
        return "\(hours):\(minutes):\(seconds)"
    }
}

extension UIColor {

    convenience init(
        redByte   red:UInt8,
        greenByte green:UInt8,
        blueByte  blue:UInt8,
        alphaByte alpha:UInt8
        ) {
        self.init(
            red:   CGFloat(red  )/255.0,
            green: CGFloat(green)/255.0,
            blue:  CGFloat(blue )/255.0,
            alpha: CGFloat(alpha)/255.0
        )
    }
}

extension UIViewController {
   
    var isModal: Bool {
        if let index = navigationController?.viewControllers.firstIndex(of: self), index > 0 {
            return false
        } else if presentingViewController != nil {
            if let parent = parent, !(parent is UINavigationController || parent is UITabBarController) {
                return false
            }
            return true
        } else if let navController = navigationController, navController.presentingViewController?.presentedViewController == navController {
            return true
        } else if tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        return false
    }
    
    func save(dictionary: NSMutableDictionary, forKey key: String) {
        let archiver = NSKeyedArchiver.archivedData(withRootObject: dictionary)
        UserDefaults.standard.set(archiver, forKey: key)
    }
    
    func save(array: NSArray, forKey key: String) {
        let archiver = NSKeyedArchiver.archivedData(withRootObject: array)
        UserDefaults.standard.set(archiver, forKey: key)
    }

    func retrieveDictionary(withKey key: String) -> NSMutableDictionary? {
        
        // Check if data exists
        guard let data = UserDefaults.standard.object(forKey: key) else {
            return nil
        }
        
        // Check if retrieved data has correct type
        guard let retrievedData = data as? Data else {
            return nil
        }
        
        // Unarchive data
        let unarchivedObject = NSKeyedUnarchiver.unarchiveObject(with: retrievedData)
        return unarchivedObject as? NSMutableDictionary
    }
    
    func retrieveArray(withKey key: String) -> NSArray? {
        
        // Check if data exists
        guard let data = UserDefaults.standard.object(forKey: key) else {
            return nil
        }
        
        // Check if retrieved data has correct type
        guard let retrievedData = data as? Data else {
            return nil
        }
        
        // Unarchive data
        let unarchivedObject = NSKeyedUnarchiver.unarchiveObject(with: retrievedData)
        return unarchivedObject as? NSArray
    }
    
    func showAlert(title : String , message : String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func removeUserData(){
        UserDefaults.standard.removeObject(forKey: "ISLOGIN")
        UserDefaults.standard.removeObject(forKey: "ProfileData")
        UserDefaults.standard.removeObject(forKey: "PROFILE_IMAGE")
    }
    
    func showToast(message : String) {
        let lWidth = message.count * 9
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - CGFloat(lWidth/2), y: self.view.frame.size.height-100, width: CGFloat(lWidth), height: 32))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "SourceSansPro-Regular", size: 14.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = toastLabel.bounds.height * 0.5;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 3.0, delay: 1.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func handleTapGesture(){
        
        self.view.endEditing(true)
    }
    
    func setupGesture(tapGesture : UITapGestureRecognizer,view :UIView){
        
        //gesture for keyboard remove
        tapGesture.cancelsTouchesInView = true
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func isValidEmail(email : String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func getUserDefaultData(pKey: String)-> String
    {
        return (UserDefaults.standard.string(forKey: pKey) == nil ? "" : UserDefaults.standard.string(forKey: pKey)!)
    }
    
    
    
    func setDataById(DataValue: String, Datakey: String)
    {
        UserDefaults.standard.removeObject(forKey: Datakey)
        UserDefaults.standard.set(DataValue, forKey: Datakey)
    }
    
    func replaceString(oldString : String,with: String , of : String) -> String{
        return oldString.replacingOccurrences(of: of, with: with)
    }
    
    func nullToNil(value : AnyObject?) -> AnyObject? {
        if value is NSNull {
            return nil
        } else {
            return value
        }
    }
    func getDataValue(value : AnyObject?) -> AnyObject? {
        if value is NSNull || value == nil {
            return "" as AnyObject
        }
        else {
            return value
        }
    }
    
    func getDataValueByType(value : AnyObject?, objectType: String) -> AnyObject? {
        if value is NSNull || value == nil {
            if objectType == "bool"
            {
                return false as AnyObject
            }
            else if objectType == "double"
            {
                return 0.0 as AnyObject
            }
            else if objectType == "int"
            {
                return 0 as AnyObject
            }
            else
            {
                return "" as AnyObject
            }
        }
        else {
            return value
        }
    }
}


extension Date {
    
    func today(format : String = "yyyy-MM-dd HH:mm:ss") -> String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    func todayDate() -> String{
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate = format.string(from: date)
        return formattedDate
    }
    
    
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
    
}

extension UIStatusBarStyle {
    static var black: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        }
        return .default
    }
}

extension UISwitch {

    func set(width: CGFloat, height: CGFloat) {

        let standardHeight: CGFloat = 31
        let standardWidth: CGFloat = 51

        let heightRatio = height / standardHeight
        let widthRatio = width / standardWidth

        transform = CGAffineTransform(scaleX: widthRatio, y: heightRatio)
    }
}
extension DateFormatter {

    convenience init (format: String) {
        self.init()
        dateFormat = format
        locale = Locale.current
    }
}

extension String {

    func toDate (dateFormatter: DateFormatter) -> Date? {
        return dateFormatter.date(from: self)
    }

    func toDateString (dateFormatter: DateFormatter, outputFormat: String) -> String? {
        guard let date = toDate(dateFormatter: dateFormatter) else { return nil }
        return DateFormatter(format: outputFormat).string(from: date)
    }
}

extension Date {

    func toString (dateFormatter: DateFormatter) -> String? {
        return dateFormatter.string(from: self)
    }

    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}

