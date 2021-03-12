//
//  GoalCoreData.swift
//  Gosio
//
//  Created by ANKIT YADAV on 12/03/21.
//

import CoreData

// Goal CoreData
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
//        print("Fetch Failed")
    }
}

