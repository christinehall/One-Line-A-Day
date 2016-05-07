//
//  ViewController.swift
//  OLAD
//
//  Created by Christine Hall on 5/7/16.
//  Copyright © 2016 Christine Hall. All rights reserved.
//

import UIKit
import CoreData

class Entry {
    
    var line: String!
    var date: NSDate!
    
    init(obj: NSManagedObject) {
        line = obj.valueForKey("line") as! String
        date = obj.valueForKey("date") as! NSDate
    }
    
    init(date: NSDate) {
        self.date = date
    }
    
}

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var dateHeader: UIView!
    var dateLabel: UILabel!
    var todaysEntries = [Entry]()
    
    var mainColor = UIColor(red: 52/255.0, green: 152/255.0, blue: 219/255.0, alpha: 1.0)
    var secondaryColor = UIColor(red: 218/255.0, green: 234/255.0, blue: 244/255.0, alpha: 1.0)
    
    var lineTable: UITableView!
    var zeroImage: UIImage!
    
    var w: CGFloat!
    var h: CGFloat!
    
    var dateTracker: Int = 0
    var selectedIndexPath: NSIndexPath!
    
    var thisWeek = [NSDate]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCoreUI()
        buildThisWeek()
        setElementsByDate(NSDate())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setupCoreUI() {
        // grab the screen size and set width/height variables
        var screenSize = UIScreen.mainScreen().bounds
        w = screenSize.width
        h = screenSize.height
        
        view.backgroundColor = secondaryColor
        
        // header
        dateHeader = UIView(frame: CGRectMake(0,0,w,65))
        dateHeader.backgroundColor = mainColor
        view.addSubview(dateHeader)
        
        // date labe
        dateLabel = UILabel(frame: CGRectMake(0,0,w,65))
        dateLabel.textColor = UIColor.whiteColor()
        dateLabel.textAlignment = .Center
        dateHeader.addSubview(dateLabel)
        
        // tableview
        lineTable = UITableView(frame: CGRectMake(0,65,w,h-65))
        lineTable.dataSource = self
        lineTable.delegate = self
        lineTable.registerClass(LineCell.self, forCellReuseIdentifier: "LineCell")
        view.addSubview(lineTable)
    }
    
    func buildThisWeek() {
        var i = -7
        let calendar = NSCalendar.currentCalendar()
        while i <= 0 {
            let dateThisWeek = calendar.dateByAddingUnit(.NSDayCalendarUnit, value: i, toDate: NSDate(), options: [])
            thisWeek.append(dateThisWeek!)
            i += 1
        }
    }
    
    func setElementsByDate(date: NSDate) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        var longformDate = dateFormatter.stringFromDate(date)
        var dateArray = longformDate.componentsSeparatedByString(",")
        dateLabel.text = dateArray[0]
        
        let fetchedEntries = Courier.getCourier().fetchEntriesForDate(date)
        for entry in fetchedEntries {
            todaysEntries.append(Entry(obj: entry))
        }
        
        
        if dateTracker > -8 && dateTracker < 1 {
            var found = false
            for entry in todaysEntries {
                if entry.date.isBetween(date: thisWeek.first!, andDate: thisWeek.last!) {
                    found = true
                }
            }
            if found == false {
                todaysEntries.append(Entry(date: date))
            }
        }
    }
    
    
    //////////////////////////////////
    // mark - table view delegate methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todaysEntries.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = lineTable.dequeueReusableCellWithIdentifier("LineCell", forIndexPath: indexPath) as? LineCell
        
        let postWithImage = todaysEntries[indexPath.row]
        if let cell = cell {
            // do things to the cell
            return cell
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! LineCell
        switch selectedIndexPath {
        case nil: // first time something is clicked
            selectedIndexPath = indexPath
            cell.expand()
        default: // another cell has been previously selected
            if selectedIndexPath! == indexPath {
                selectedIndexPath = nil // close it up!
                cell.collapse()
            } else {
                selectedIndexPath = indexPath
                let newCell = tableView.cellForRowAtIndexPath(selectedIndexPath!) as! LineCell
                cell.expand()
                newCell.collapse()
            }
        }
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let smallHeight: CGFloat = 220.0
        let expandedHeight: CGFloat = h - 70
        let ip = indexPath
        
        if selectedIndexPath != nil {
            if ip == selectedIndexPath! {
                return expandedHeight
            } else {
                return smallHeight
            }
        } else {
            return smallHeight
        }
    }


}

