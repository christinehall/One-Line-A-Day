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
    
    var startYPos: CGFloat!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clearColor()
        self.selectionStyle = UITableViewCellSelectionStyle.None // no grey highlighting when you select a cell
        
        // get screen dimensions
        let screenSize = UIScreen.mainScreen().bounds
        w = screenSize.width
        h = screenSize.height
        
        // create container
        container = UIView(frame: CGRectMake(0, 5, w, 200))
        container.backgroundColor = UIColor.redColor()
        container.layer.cornerRadius = 0.0
        self.addSubview(container)
        
        
        // add them all to self
//        let viewsInContainer = [yearLabel, line, editLine, editButton]
//        for thisView in viewsInContainer {
//            container.addSubview(thisView)
//        }
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
}