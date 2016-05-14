//
//  SettingsController.swift
//  OneLine
//
//  Created by Christine Hall on 5/14/16.
//  Copyright © 2016 Christine Hall. All rights reserved.
//

import Foundation
import UIKit

class SettingsController {
    
    // fonts
    var boldFont =  UIFont(name: "BebasNeueBold", size: 30)!
    var regFont = UIFont(name: "BebasNeueBook", size: 23)!
    var dateNumberFont = UIFont(name: "BebasNeueBold", size: 25)!
    var writingFont = UIFont(name: "BebasNeueBold", size: 40)!
    var buttonFont = UIFont(name: "BebasNeueBold", size: 20)!
    
    // colors
    var mainColor = UIColor(hexString: "3498DB")
    var secondaryColor = UIColor(hexString: "DAEAF4")
    var highlightColor = UIColor(hexString: "0161A2")
    var contrastColor = UIColor(hexString: "FFFFFF")
    
    private class var sharedInstance: SettingsController {
        struct Static {
            static let instance: SettingsController = SettingsController()
        }
        return Static.instance
    }
    
    class func getController() -> SettingsController {
        return sharedInstance
    }
}
