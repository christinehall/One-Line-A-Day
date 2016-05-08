//
//  LineCell.swift
//  OneLine
//
//  Created by Christine Hall on 5/7/16.
//  Copyright © 2016 Christine Hall. All rights reserved.
//

import Foundation
import UIKit

class LineCell: UITableViewCell {
    
    var classLabel: UILabel!
    var w: CGFloat!
    var h: CGFloat!
    
    var container: UIView!
    
    // all elements in the cell itself
    var yearLabel: UILabel!
    var line: UITextView!
    var editButton: UIButton!
    
    var cellHeight: CGFloat!
    var startYPos: CGFloat!
    
    var parentViewController: MainViewController!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.backgroundColor = UIColor.clearColor()
        self.selectionStyle = UITableViewCellSelectionStyle.None // no grey highlighting when you select a cell
        
        // get screen dimensions
        let screenSize = UIScreen.mainScreen().bounds
        w = screenSize.width
        h = screenSize.height
        cellHeight = ((h-65)/3)

        // create container
        container = UIView(frame: CGRectMake(0, 10, w, cellHeight - 10))
        container.backgroundColor = UIColor.redColor()
        container.layer.cornerRadius = 0.0
        self.addSubview(container)
        
        // year label
        yearLabel = UILabel(frame: CGRectMake(5,10,w-10,30))
        yearLabel.textColor = UIColor.darkGrayColor()
        yearLabel.font = UIFont(name: "Gotham-Bold", size: 20)
        yearLabel.textAlignment = .Left
        
        line = UITextView(frame: CGRectMake(5,35,w-10,50))
        line.font = UIFont(name: "Gotham-Medium", size: 14)
        line.textAlignment = .Left
        line.backgroundColor = UIColor.clearColor()
        line.editable = false
        
        editButton = UIButton(frame:CGRectMake(w-50, cellHeight - 40, 40,30))
        editButton.setTitle("Edit", forState: .Normal)
        editButton.titleLabel!.font = UIFont(name: "Gotham-Light", size: 13)
        editButton.alpha = 0.8
        editButton.addTarget(self, action: #selector(LineCell.edit), forControlEvents: .TouchUpInside)
        editButton.hidden = true
        
        // add them all to the container
        let viewsInContainer = [yearLabel, line, editButton]
        for thisView in viewsInContainer {
            container.addSubview(thisView)
        }
    }
    
    func setBackgroundTo(color: UIColor) {
        container.backgroundColor = color
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func expand() {
        
        print("Expanding")
    }
    
    func collapse(){
        
        print("Collapsing")
    }
    
    func edit() {
        parentViewController.clickedEdit(line.text!)
    }
    
    func setDayCell() {
        container.backgroundColor = UIColor.whiteColor()
        yearLabel.textColor = UIColor.darkGrayColor()
        line.textColor = UIColor.darkGrayColor()
        editButton.setTitleColor(UIColor(red: 52/255.0, green: 152/255.0, blue: 219/255.0, alpha: 1.0), forState: .Normal)
    }
    
    func setTodaysCell() {
        container.backgroundColor = UIColor(red: 52/255.0, green: 152/255.0, blue: 219/255.0, alpha: 1.0)
        yearLabel.textColor = UIColor.whiteColor()
        line.textColor = UIColor.whiteColor()
        editButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)

    }
    
    func clear() {
        container.backgroundColor = UIColor.clearColor()
        
        yearLabel.text = ""
        line.text = ""
        editButton.hidden = true
    }
}