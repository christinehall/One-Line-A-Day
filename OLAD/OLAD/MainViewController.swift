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
    
    var dayColors = Dictionary<String, DayColors>()
    @IBOutlet weak var calendarView: MJCalendarView!

    var dateHeader: NavigationView!
    var todaysEntries = [Entry]()
    var editView: EditView!
    
    var mainColor = SettingsController.getController().mainColor
    var secondaryColor = SettingsController.getController().secondaryColor
    var highlightColor = SettingsController.getController().highlightColor
    
    var monthTitle: UILabel!
    var currentDate: NSDate!
    var calendar: NSCalendar!
    var lineTable: UITableView!
    var zeroImage: UIImage!
    
    var closeButton: UIButton!
    var w: CGFloat!
    var h: CGFloat!
    
    
    var thisWeek = [NSDate]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendar = NSCalendar.currentCalendar()
        currentDate = NSDate()
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent

        setupCoreUI()
        buildThisWeek()
        setElement(currentDate)
        setUpDays()
        setUpCalendarConfiguration()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        UIApplication.sharedApplication().statusBarStyle = .Default

    }

    
    func setupCoreUI() {
        // grab the screen size and set width/height variables
        let screenSize = UIScreen.mainScreen().bounds
        w = screenSize.width
        h = screenSize.height
        
        view.backgroundColor = secondaryColor
        
        var header = UIView(frame: CGRectMake(0,0,w,65))
        header.backgroundColor = mainColor
        view.addSubview(header)
        
        // month Title
        monthTitle = UILabel(frame:CGRectMake(10, 25, w - 20, 30))
        monthTitle.font = SettingsController.getController().boldFont
        monthTitle.textAlignment = .Center
        monthTitle.textColor = UIColor.whiteColor()
        monthTitle.text = getDayAndMonthFromDate(currentDate)
        header.addSubview(monthTitle)
        
        // closeButton
        closeButton = UIButton(frame: CGRectMake(w-40, 25, 30, 30))
        closeButton.contentMode = .ScaleAspectFit
        closeButton.setImage(UIImage(named:"close_button"), forState: .Normal)
        closeButton.addTarget(self, action: #selector(MainViewController.closeEdit), forControlEvents: .TouchUpInside)
        closeButton.hidden = true
        header.addSubview(closeButton)
        
        
        // tableview
        lineTable = UITableView(frame: CGRectMake(0,150,w,h-150))
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
        view.bringSubviewToFront(calendarView)
        view.addSubview(editView)

    }
    
    
    func setUpCalendarConfiguration() {
        calendarView.backgroundColor = UIColor.clearColor()
        calendarView.frame = CGRectMake(0, 35, 180, 65)
        calendarView.calendarDelegate = self
        
        calendarView.configuration.periodType = .OneWeek
        calendarView.configuration.dayViewType = .Circle
        calendarView.configuration.selectedDayType = .Filled
        calendarView.configuration.dayTextColor = mainColor
        calendarView.configuration.dayBackgroundColor = UIColor.clearColor()
        calendarView.configuration.selectedDayTextColor = UIColor.whiteColor()
        calendarView.configuration.selectedDayBackgroundColor = SettingsController.getController().highlightColor
        
        calendarView.configuration.weekLabelTextColor = SettingsController.getController().highlightColor
        
        calendarView.configuration.startDayType = .Sunday
        calendarView.configuration.dayTextFont = SettingsController.getController().dateNumberFont
        calendarView.configuration.weekLabelFont = SettingsController.getController().regFont
        calendarView.configuration.dayViewSize = CGSizeMake(48, 48)
        calendarView.configuration.rowHeight = 50
        calendarView.configuration.weekLabelHeight = 25

        calendarView.reloadView()
    }
    
    
    func setUpDays() {
        for i in 0...365 {
            let day = dateByIndex(i)
            let thisDay = Courier.getCourier().fetchEntriesForDate(day)
            if thisDay.count > 0 {                
                let dayColors = DayColors(backgroundColor: SettingsController.getController().mainColor, textColor: UIColor.whiteColor())
                self.dayColors[convertDateToShortString(thisDay[0].valueForKey("date") as! NSDate)] = dayColors
            }
        }
    }
    
    func dateByIndex(index: Int) -> NSDate {
        return NSDate().dateBySubtractingDays(index)
    }

    
    //////////////////////////////////
    //////////////////////////////////
    // MJCalendarViewDelegate methods
    
    func calendar(calendarView: MJCalendarView, didChangePeriod periodDate: NSDate, bySwipe: Bool) {
        setElement(periodDate)
    }
    
    func calendar(calendarView: MJCalendarView, backgroundForDate date: NSDate) -> UIColor? {
        if self.dayColors[convertDateToShortString(date)]?.backgroundColor != nil {
        }
        return self.dayColors[convertDateToShortString(date)]?.backgroundColor
    }
    
    func calendar(calendarView: MJCalendarView, textColorForDate date: NSDate) -> UIColor? {
        return self.dayColors[convertDateToShortString(date)]?.textColor
    }
    
    func calendar(calendarView: MJCalendarView, didSelectDate date: NSDate) {
        setElement(date)
    }
    
    
    func buildThisWeek() {
        var i = -7
        while i <= 0 {
            let dateThisWeek = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: i, toDate: NSDate(), options: [])
            print("Adding \(dateThisWeek) to this week's dates!")
            thisWeek.append(dateThisWeek!)
            i += 1
        }
    }
    
    
    func setElement(date:NSDate) {
        currentDate = date
        monthTitle.text = getDayAndMonthFromDate(currentDate)
        todaysEntries.removeAll()
        
        UIView.animateWithDuration(0.5) {
            self.lineTable.alpha = 0.0
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        let longformDate = dateFormatter.stringFromDate(date)
        var dateArray = longformDate.componentsSeparatedByString(",")
        
        let fetchedEntries = Courier.getCourier().fetchEntriesForDate(date)
        for entry in fetchedEntries {
            let entryObj = Entry(obj: entry)
            todaysEntries.append(entryObj)
        }
        
        let dateTracker = NSDate().daysFrom(date)
        if dateTracker < 8 && dateTracker > 0 {
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
        
        UIView.animateWithDuration(0.5) {
            self.lineTable.alpha = 1.0
        }
    }

    
    private func getMonthFromDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        let longformDate = dateFormatter.stringFromDate(date)
        let dateArray = longformDate.componentsSeparatedByString(" ")
        return dateArray.first!
    }
    
    private func getDayAndMonthFromDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        let longformDate = dateFormatter.stringFromDate(date)
        let dateArray = longformDate.componentsSeparatedByString(",")
        return dateArray.first!
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
            cell.updateCellSize(lineTable.frame.size.height / 3.0)
            cell.parentViewController = self
            cell.yearLabel.text = getYearFromDate(entry.date)
            
            if convertDateToShortString(entry.date) == convertDateToShortString(NSDate()) { // i.e., if this is today's update
                cell.setTodaysCell()
            } else {
                cell.setDayCell()
            }
            
            if entry.line == nil {
                cell.showPlaceholder()
            } else {
                cell.line.text = entry.line
            }
            
            let dateTracker = NSDate().daysFrom(currentDate)
            if dateTracker < 8 && dateTracker > -1 {
                cell.editButton.hidden = false
            }
            
            return cell
        }
        return cell!
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! LineCell
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return lineTable.frame.size.height / 3.0
    }
    
    //////////////////////////////////
    //////////////////////////////////
    
    func clickedEdit(lineText: String) {
        editView.show(lineText)
        closeButton.hidden = false
    }
    
    func closeEdit() {
        editView.hide()
        closeButton.hidden = true
    }
    
    
}

