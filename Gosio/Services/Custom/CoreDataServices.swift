//
//  CoreDataServices.swift
//  Gosio
//
//  Created by ANKIT YADAV on 05/03/21.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext

struct coreDataIdentifierManager {
    
    static let goalKey = "Goal"
    
}

func deleteGoal(selectedGoal: Goal) {
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: coreDataIdentifierManager.goalKey)
    
    do {
        let results:NSArray = try context.fetch(request) as NSArray
        for result in results {
            let goal = result as! Goal
            if (goal == selectedGoal) {
                goal.deletedDate = Date()
                try context.save()
            }
        }
    }
    catch {
        print("Fetch Failed")
    }
}
