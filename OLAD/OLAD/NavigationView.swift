//
//  NavigationView.swift
//  OneLine
//
//  Created by Christine Hall on 5/8/16.
//  Copyright © 2016 Christine Hall. All rights reserved.
//

import Foundation
import UIKit

class NavigationView: UIView {
    
    var title: UILabel!
    var leftButton: UIButton!
    var centerButton: UIButton!
    var rightButton: UIButton!
    var parent: UIViewController!
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        
        backgroundColor = UIColor(red: 52/255.0, green: 152/255.0, blue: 219/255.0, alpha: 1.0)
        let screenSize = UIScreen.mainScreen().bounds
        let w = screenSize.width

        title = UILabel(frame:CGRectMake(10, 25, w - 20, 30))
        title.font = UIFont(name: "Gotham-Medium", size: 15)
        title.textColor = UIColor.whiteColor()
        title.textAlignment = .Center
        
        leftButton = UIButton(frame: CGRectMake(10, 25, 30, 30))
        leftButton.contentMode = .ScaleAspectFit
        centerButton = UIButton(frame:CGRectMake(50, 0, w - 100, 65))
        rightButton = UIButton(frame: CGRectMake(w-40, 25, 30, 30))
        rightButton.contentMode = .ScaleAspectFit
        
        let subviews = [title, leftButton, centerButton, rightButton]
        for subview in subviews {
            self.addSubview(subview)
        }
    }
    
    func setNavTitle(s: String) {
        self.title.text = s
    }
    
    convenience init () {
        let screenSize = UIScreen.mainScreen().bounds
        let w = screenSize.width
        
        self.init(frame:CGRectMake(0,0,w,65))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    func displayButtons(show: Bool = false, buttons: [UIButton]) {
        for button in buttons {
            button.hidden = !hidden
        }
    }

    
}