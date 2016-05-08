//
//  EditView.swift
//  OneLine
//
//  Created by Christine Hall on 5/8/16.
//  Copyright © 2016 Christine Hall. All rights reserved.
//

import Foundation
import UIKit

class EditView: UIView {
    
    var w: CGFloat!
    var h: CGFloat!
    var textField: UITextView!
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        
        w = frame.width
        h = frame.height
        
        addUIBlur(UIBlurEffectStyle.Light)
        hidden = true
        
        setupUIElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    func setupUIElements() {
        textField = UITextView(frame: CGRectMake(10,10,w-20,h-20))
        textField.font = UIFont(name: "Gotham-Medium", size: 35)
        textField.textColor = UIColor(red: 52/255.0, green: 152/255.0, blue: 219/255.0, alpha: 1.0)
        textField.backgroundColor = UIColor.clearColor()
        addSubview(textField)
    }
    
    private func addUIBlur(style: UIBlurEffectStyle = UIBlurEffectStyle.ExtraLight) {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: style))
        blur.frame = self.bounds
        blur.userInteractionEnabled = false //This allows touches to forward to the button.
        self.insertSubview(blur, atIndex: 0)
        
    }
    
    func show(lineText: String) {
        alpha = 0.0
        hidden = false

        UIView.animateWithDuration(0.3) {
            self.alpha = 1.0
        }
        
        textField.text = lineText
        textField.becomeFirstResponder()
    }
    
    func hide() {
        alpha = 1.0
        
        UIView.animateWithDuration(0.3, animations: { 
            self.alpha = 0.0
            }, completion: { finished in
                if finished {
                    self.hidden = true
                }
        })
        textField.resignFirstResponder()
    }
    
}