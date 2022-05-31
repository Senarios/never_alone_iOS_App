//
//  Loader.swift
//  KBeaconDemo_Ios
//
//  Created by Azhar on 2/24/22.
//  Copyright © 2022 hogen. All rights reserved.
//

import Foundation
import UIKit
import JGProgressHUD

class Loader{
    
    let hud = JGProgressHUD()
    static let shared = Loader()
    init(){
        
        hud.textLabel.text = "Loading"
    }
    
    func startAnimating(in  view : UIView){
        hud.show(in: view)
    }
    
    func stopAnimating(){
        hud.dismiss(animated: true)
    }
    
}
