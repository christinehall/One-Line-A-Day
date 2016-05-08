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
    var line: UILabel!
    var editLine: UITextView!
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
        cellHeight = ((h-65)/5)

        // create container
        container = UIView(frame: CGRectMake(0, 10, w, cellHeight - 10))
        container.backgroundColor = UIColor.redColor()
        container.layer.cornerRadius = 0.0
        self.addSubview(container)
        
        // year label
        yearLabel = UILabel(frame: CGRectMake(5,5,w-10,50))
        yearLabel.textColor = UIColor.darkGrayColor()
        yearLabel.font = UIFont(name: "Gotham-Bold", size: 20)
        yearLabel.textAlignment = .Left
        
        line = UILabel(frame: CGRectMake(10,50,w-20,50))
        line.textColor = UIColor.darkGrayColor()
        line.textAlignment = .Left
        line.numberOfLines = 0
        
        editLine = UITextView(frame: CGRectMake(10,50,w-20,50))
        editLine.hidden = true
        
        editButton = UIButton(frame:CGRectMake(w-50, cellHeight - 40, 40,30))
        editButton.setTitle("Edit", forState: .Normal)
        editButton.addTarget(self, action: #selector(LineCell.edit), forControlEvents: .TouchUpInside)
        editButton.hidden = true
        
        // add them all to the container
        let viewsInContainer = [yearLabel, line, editLine, editButton]
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
        parentViewController.clickedEdit() 
    }
    
    func setTodaysCell() {
        container.backgroundColor = UIColor(red: 52/255.0, green: 152/255.0, blue: 219/255.0, alpha: 1.0)
        yearLabel.textColor = UIColor.whiteColor()
        line.textColor = UIColor.whiteColor()
    }
    
    func clear() {
        container.backgroundColor = UIColor.clearColor()
        yearLabel.text = ""
        line.text = ""
        editButton.hidden = true
        
    }
}