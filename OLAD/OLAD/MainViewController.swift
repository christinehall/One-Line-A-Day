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
    
    func save() {
        Courier.getCourier().saveEntryForDate(self.date, line: self.line)
    }
    
}

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var dateHeader: NavigationView!
    var todaysEntries = [Entry]()
    var editView: EditView!
    
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
        setElementsByDate(0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setupCoreUI() {
        // grab the screen size and set width/height variables
        let screenSize = UIScreen.mainScreen().bounds
        w = screenSize.width
        h = screenSize.height
        
        view.backgroundColor = secondaryColor
        
        // header
        dateHeader = NavigationView()
        view.addSubview(dateHeader)
        
        // back and forth buttons
        dateHeader.leftButton.setImage(UIImage(named: "back_button"), forState: .Normal)
        dateHeader.leftButton.addTarget(self, action: #selector(MainViewController.backOneDay), forControlEvents: .TouchUpInside)
        dateHeader.centerButton.addTarget(self, action: #selector(MainViewController.goToToday), forControlEvents: .TouchUpInside)
        dateHeader.rightButton.setImage(UIImage(named: "forward_button"), forState: .Normal)
        dateHeader.rightButton.addTarget(self, action: #selector(MainViewController.forwardOneDay), forControlEvents: .TouchUpInside)
        dateHeader.rightButton.hidden = shouldHideForwardButton()
        
        // tableview
        lineTable = UITableView(frame: CGRectMake(0,65,w,h-65))
        lineTable.backgroundColor = secondaryColor
        lineTable.separatorStyle = .None
        lineTable.dataSource = self
        lineTable.delegate = self
        lineTable.registerClass(LineCell.self, forCellReuseIdentifier: "LineCell")
        view.addSubview(lineTable)
        
        // editView
        editView = EditView(frame: CGRectMake(0,65,w,h-65))
        view.addSubview(editView)
    }
    
    func buildThisWeek() {
        var i = -7
        let calendar = NSCalendar.currentCalendar()
        while i <= 0 {
            let dateThisWeek = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: i, toDate: NSDate(), options: [])
            thisWeek.append(dateThisWeek!)
            i += 1
        }
    }
    
    func shouldHideForwardButton() -> Bool {
        if dateTracker >= 0 {
            return true
        }
        return false
    }
    
    func setElementsByDate(dayNum: Int) {
        todaysEntries.removeAll()
        
        let calendar = NSCalendar.currentCalendar()
        let date = calendar.dateByAddingUnit(.Day, value: dayNum, toDate: NSDate(), options: [])!
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        let longformDate = dateFormatter.stringFromDate(date)
        var dateArray = longformDate.componentsSeparatedByString(",")
        dateHeader.setNavTitle(dateArray[0])
        
        let fetchedEntries = Courier.getCourier().fetchEntriesForDate(date)
        for entry in fetchedEntries {
            let entryObj = Entry(obj: entry)
            todaysEntries.append(entryObj)
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
        
        lineTable.reloadData()
    }
    
    private func getYearFromDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        let longformDate = dateFormatter.stringFromDate(date)
        let dateArray = longformDate.componentsSeparatedByString(",")
        return dateArray.last!
    }
    
    private func convertDateToShortString(date:NSDate) -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.stringFromDate(date)
    }
    
    //////////////////////////////////
    //////////////////////////////////
    // table view delegate methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todaysEntries.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = lineTable.dequeueReusableCellWithIdentifier("LineCell", forIndexPath: indexPath) as? LineCell
        
        let entry = todaysEntries[indexPath.row]
        if let cell = cell {
            cell.clear()
            cell.parentViewController = self
            cell.yearLabel.text = getYearFromDate(entry.date)
            
            
            if convertDateToShortString(entry.date) == convertDateToShortString(NSDate()) { // i.e., if this is today's update
                cell.setTodaysCell()
            } else {
                cell.setDayCell()
            }
            
            if entry.line == nil {
                cell.line.text = "Placeholder"
            } else {
                cell.line.text = entry.line
            }
            
            if dateTracker > -7 && dateTracker < 1 {
                cell.editButton.hidden = false
            }
            
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
        let smallHeight: CGFloat = (self.h - 65) / 5
        let expandedHeight: CGFloat = h - 65
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
    
    //////////////////////////////////
    //////////////////////////////////
    // date movement methods
    
    func goToToday() {
        // don't show the animation if you're already in the right spot
        if dateTracker == 0 {
            return
        }
        UIView.animateWithDuration(0.5) {
            self.lineTable.alpha = 0.0
        }
        dateTracker = 0
        setElementsByDate(dateTracker)
        dateHeader.rightButton.hidden = shouldHideForwardButton()
        UIView.animateWithDuration(0.5) {
            self.lineTable.alpha = 1.0
        }
    }


    func backOneDay() {
        UIView.animateWithDuration(0.5) { 
            self.lineTable.alpha = 0.0
        }
        dateTracker -= 1
        setElementsByDate(dateTracker)
        dateHeader.rightButton.hidden = shouldHideForwardButton()
        UIView.animateWithDuration(0.5) {
            self.lineTable.alpha = 1.0
        }
    }
    
    func forwardOneDay() {
        UIView.animateWithDuration(0.5) {
            self.lineTable.alpha = 0.0
        }
        dateTracker += 1
        setElementsByDate(dateTracker)
        dateHeader.rightButton.hidden = shouldHideForwardButton()
        UIView.animateWithDuration(0.5) {
            self.lineTable.alpha = 1.0
        }
    }
    
    func clickedEdit(lineText: String) {
        editView.show(lineText)
        dateHeader.rightButton.removeTarget(nil, action: nil, forControlEvents: .AllEvents)

        dateHeader.displayButtons(false, buttons: [dateHeader.leftButton, dateHeader.centerButton])
        dateHeader.rightButton.hidden = false
        dateHeader.rightButton.setImage(UIImage(named: "close_button"), forState: .Normal)
        dateHeader.rightButton.addTarget(self, action: #selector(MainViewController.closeEdit), forControlEvents: .TouchUpInside)
    }
    
    func closeEdit() {
        saveLine()
        
        editView.hide()
        dateHeader.rightButton.removeTarget(nil, action: nil, forControlEvents: .AllEvents)

        dateHeader.displayButtons(true, buttons: [dateHeader.leftButton, dateHeader.centerButton])
        dateHeader.rightButton.setImage(UIImage(named: "forward_button"), forState: .Normal)
        dateHeader.rightButton.addTarget(self, action: #selector(MainViewController.forwardOneDay), forControlEvents: .TouchUpInside)
        dateHeader.rightButton.hidden = shouldHideForwardButton()

    }
    
    func saveLine() {
        let calendar = NSCalendar.currentCalendar()
        let date = calendar.dateByAddingUnit(.Day, value: dateTracker, toDate: NSDate(), options: [])!
        let line = self.editView.textField.text!
        
        let newEntry = Entry(date: date)
        newEntry.line = line
        newEntry.save()
        
        var i = 0
        while i < todaysEntries.count {
            if convertDateToShortString(todaysEntries[i].date) == convertDateToShortString(newEntry.date) {
                todaysEntries.removeAtIndex(i)
            }
            i += 1
        }
        todaysEntries.append(newEntry)
        lineTable.reloadData()
    }

}

