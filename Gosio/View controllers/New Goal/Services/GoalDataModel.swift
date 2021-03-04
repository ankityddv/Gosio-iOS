//
//  Goal.swift
//  Gosio
//
//  Created by ANKIT YADAV on 03/03/21.
//

import UIKit
import CoreData

@objc(Goal)
class Goal: NSManagedObject {
    
    @NSManaged var emoji : String!
    @NSManaged var goalName : String!
    @NSManaged var goalAchievedAmount : NSNumber!
    @NSManaged var goalTotalAmount : NSNumber!
    @NSManaged var goalStatus : String!
    @NSManaged var progressBar: NSNumber!
    @NSManaged var goalPercentage: NSNumber!
    @NSManaged var goalAccomplishmentDate: String!
    
}

var goal = [Goal]()

