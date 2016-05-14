//
//  SettingsController.swift
//  OneLine
//
//  Created by Christine Hall on 5/14/16.
//  Copyright © 2016 Christine Hall. All rights reserved.
//

import Foundation
import UIKit

class SettingsController: NSObject {

    // arrays should be: main, secondary, contrast
    var tealAndDarkBlue = ["28b7d8 ", "f2f7f9", "242947"]
    var originalColors = ["3498DB", "DAEAF4", "0161A2"]
    
    // fonts
    var boldFont =  UIFont(name: "BebasNeueBold", size: 30)!
    var regFont = UIFont(name: "BebasNeueBook", size: 23)!
    var dateNumberFont = UIFont(name: "BebasNeueBold", size: 25)!
    var writingFont = UIFont(name: "BebasNeueBold", size: 40)!
    var buttonFont = UIFont(name: "BebasNeueBold", size: 20)!
    
    // colors
    var mainColor: UIColor!
    var secondaryColor: UIColor!
    var highlightColor: UIColor!
    var contrastColor: UIColor!
    
    private class var sharedInstance: SettingsController {
        struct Static {
            static let instance: SettingsController = SettingsController()
        }
        return Static.instance
    }
    
    class func getController() -> SettingsController {
        return sharedInstance
    }
    
    override init() {
        super.init()
        
        var colors = tealAndDarkBlue
        
        mainColor = UIColor(hexString: colors[0])
        secondaryColor = UIColor(hexString: colors[1])
        highlightColor = UIColor(hexString: colors[2])
        contrastColor = UIColor(hexString: "FFFFFF")

    }
}
