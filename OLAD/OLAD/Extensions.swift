//
//  Extensions.swift
//  OneLine
//
//  Created by Christine Hall on 5/7/16.
//  Copyright © 2016 Christine Hall. All rights reserved.
//

import Foundation
import UIKit

extension NSDate {
    func isBetween(date date1: NSDate, andDate date2: NSDate) -> Bool {
        return date1.compare(self).rawValue * self.compare(date2).rawValue >= 0
    }
}

extension UIColor {
    convenience init(hexString: String) {
        var cString:String = hexString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.characters.count != 6) {
            self.init(red:155/255.0, green:155/255.0, blue: 155/255.0, alpha: 1.0)
            return
        }
        
        let rString = (cString as NSString).substringToIndex(2)
        let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
        let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
}