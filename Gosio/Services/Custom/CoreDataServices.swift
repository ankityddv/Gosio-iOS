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
    static let IAP : String = "InAppPurchase"
    static let entity : String = "Entity"
    
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

func updateIAPStatus(status: Bool) {
    
    let entity = NSEntityDescription.entity(forEntityName: coreDataIdentifierManager.IAP, in: context)
     let newEntity = NSManagedObject(entity: entity!, insertInto: context)
     
     newEntity.setValue(status, forKey: "isPro")
 
     do {
        try context.save()
     } catch {
//        print("Fucked it while saving!")
     }
    
}

func getIAPStatus() -> subscriptionType {
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: coreDataIdentifierManager.IAP)
    request.returnsObjectsAsFaults = false
    var boole : Bool!
    do {
        let result = try context.fetch(request)
        for data in result as! [NSManagedObject] {
            boole = (data.value(forKey: "isPro") as! Bool)
        }
    } catch {
//        print("Fucked it while fetching!")
    }
    
    if boole == true {
        return .pro
    } else if boole == false {
        return .free
    } else {
        return .unidentified
    }
    
}
