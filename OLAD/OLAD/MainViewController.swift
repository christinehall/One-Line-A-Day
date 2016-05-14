//
//  ViewController.swift
//  OLAD
//
//  Created by Christine Hall on 5/7/16.
//  Copyright © 2016 Christine Hall. All rights reserved.
//

import UIKit
import CoreData
import MJCalendar

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

struct DayColors {
    var backgroundColor: UIColor
    var textColor: UIColor
}


class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MJCalendarViewDelegate {
    
    var dayColors = Dictionary<NSDate, DayColors>()
    @IBOutlet weak var calendarView: MJCalendarView!
    let daysRange = 365

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
        setUpDays()
        setUpCalendarConfiguration()

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
//        view.addSubview(dateHeader)
        
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
        
        var calendarView = MJCalendarView()
        calendarView.configuration.periodType = .OneWeek
        calendarView.configuration.dayViewType = .Circle
        calendarView.reloadView()
        view.addSubview(calendarView)
        
        // editView
        editView = EditView(frame: CGRectMake(0,65,w,h-65))
        editView.parentViewController = self
        view.addSubview(editView)
        view.bringSubviewToFront(calendarView)
    }
    
    
    func setUpCalendarConfiguration() {
        calendarView.backgroundColor = UIColor.clearColor()
        calendarView.frame = CGRectMake(0, 35, w, 55)
        calendarView.calendarDelegate = self
        
        // Set displayed period type. Available types: Month, ThreeWeeks, TwoWeeks, OneWeek
        calendarView.configuration.periodType = .OneWeek
        
        // Set shape of day view. Available types: Circle, Square
        calendarView.configuration.dayViewType = .Circle
        
        // Set selected day display type. Available types:
        // Border - Only border is colored with selected day color
        // Filled - Entire day view is filled with selected day color
        calendarView.configuration.selectedDayType = .Filled
        
        // Set width of selected day border. Relevant only if selectedDayType = .Border
        calendarView.configuration.selectedBorderWidth = 1
        
        // Set day text color
        calendarView.configuration.dayTextColor = UIColor(hexString: "3498DB")
        
        // Set day background color
        calendarView.configuration.dayBackgroundColor = UIColor.clearColor()
        
        // Set selected day text color
        calendarView.configuration.selectedDayTextColor = UIColor.whiteColor()
        
        // Set selected day background color
        calendarView.configuration.selectedDayBackgroundColor = UIColor(hexString: "3498DB")
        
        // Set other month day text color. Relevant only if periodType = .Month
        calendarView.configuration.otherMonthTextColor = UIColor(hexString: "6f787c")
        
        // Set other month background color. Relevant only if periodType = .Month
        calendarView.configuration.otherMonthBackgroundColor = UIColor(hexString: "E7E7E7")
        
        // Set week text color
        calendarView.configuration.weekLabelTextColor = UIColor(hexString: "6f787c")
        
        // Set start day. Available type: .Monday, Sunday
        calendarView.configuration.startDayType = .Sunday
        
        // Set day text font
        calendarView.configuration.dayTextFont = UIFont.systemFontOfSize(12)
        
        //Set week's day name font
        calendarView.configuration.weekLabelFont = UIFont.systemFontOfSize(12)
        
        //Set day view size. It includes border width if selectedDayType = .Border
        calendarView.configuration.dayViewSize = CGSizeMake(24, 24)
        
        //Set height of row with week's days
        calendarView.configuration.rowHeight = 30
        
        // Set height of week's days names view
        calendarView.configuration.weekLabelHeight = 25
        
        // To commit all configuration changes execute reloadView method
        calendarView.reloadView()
    }
    
    func setTitleWithDate(date: NSDate) {
//        self.dateFormatter.dateFormat = "MMMM yy"
//        self.navigationItem.title = self.dateFormatter.stringFromDate(date)
    }
    
    func setUpDays() {
        
    }
    
    //MARK: MJCalendarViewDelegate
    func calendar(calendarView: MJCalendarView, didChangePeriod periodDate: NSDate, bySwipe: Bool) {
        print(periodDate)
    }
    
    func calendar(calendarView: MJCalendarView, backgroundForDate date: NSDate) -> UIColor? {
        return self.dayColors[date]?.backgroundColor
    }
    
    func calendar(calendarView: MJCalendarView, textColorForDate date: NSDate) -> UIColor? {
        return self.dayColors[date]?.textColor
    }
    
    func calendar(calendarView: MJCalendarView, didSelectDate date: NSDate) {
        setElement(date)
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
    
    
    func setElement(date:NSDate) {
        todaysEntries.removeAll()
        
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
    
    func convertDateToShortString(date:NSDate) -> String{
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
        let smallHeight: CGFloat = (self.h - 65) / 3
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
        editView.hide()
        dateHeader.rightButton.removeTarget(nil, action: nil, forControlEvents: .AllEvents)

        dateHeader.displayButtons(true, buttons: [dateHeader.leftButton, dateHeader.centerButton])
        dateHeader.rightButton.setImage(UIImage(named: "forward_button"), forState: .Normal)
        dateHeader.rightButton.addTarget(self, action: #selector(MainViewController.forwardOneDay), forControlEvents: .TouchUpInside)
        dateHeader.rightButton.hidden = shouldHideForwardButton()

    }
    
    
}

