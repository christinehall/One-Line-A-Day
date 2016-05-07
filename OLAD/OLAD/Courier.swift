//
//  Courier.swift
//  OneLine
//
//  Created by Christine Hall on 5/7/16.
//  Copyright © 2016 Christine Hall. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Courier {
    
    var foundEntries = [NSManagedObject]()
    
    private class var sharedInstance: Courier {
        struct Static {
            static let instance: Courier = Courier()
        }
        return Static.instance
    }
    
    class func getCourier() -> Courier {
        return sharedInstance
    }
    
    func fetchAllEntries() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext

        let fetchRequest = NSFetchRequest(entityName: "Entry")
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            foundEntries = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
    }
    
    private func splitDateToArray(date: NSDate) -> [String] {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let comparisonDate = dateFormatter.stringFromDate(date)
        let comparisonArray = comparisonDate.componentsSeparatedByString("-")
        return comparisonArray
    }
    
    func fetchEntriesForDate(date: NSDate) -> [NSManagedObject] {
        let comparison = splitDateToArray(date)
        var returnEntries = [NSManagedObject]()
        
        if foundEntries.count < 1 {
            fetchAllEntries()
        }
        
        for entry in foundEntries {
            let thisEntryDate = entry.valueForKey("date") as! NSDate
            let thisEntryDateArray = splitDateToArray(thisEntryDate)
            if thisEntryDateArray[0] == comparison[0] && thisEntryDateArray[1] == comparison[1] {
                returnEntries.append(entry)
            }
        }
        return returnEntries
    }
    
    
    func saveEntryForDate(date:NSDate, line: String) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName("Entry", inManagedObjectContext: managedContext)
        let entry = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        entry.setValue(line, forKey: "line")
        entry.setValue(date, forKey: "date")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func editEntryForDate(date:NSDate, line: String) {
        
    }
    
}
