//
//  GoalCoreData.swift
//  Gosio
//
//  Created by ANKIT YADAV on 12/03/21.
//

import CoreData

// Goal CoreData

func createGoal(emoji: String, goalName: String, toalAmount: String, date: String) {
    
    let entity = NSEntityDescription.entity(forEntityName: coreDataIdentifierManager.goalKey, in: context)
    let newGoal = Goal(entity: entity!, insertInto: context)
    
    newGoal.emoji = emoji
    newGoal.goalName = goalName
    newGoal.goalAchievedAmount = 0.0
    newGoal.goalTotalAmount = NSNumber(value: Float(toalAmount)!)
    newGoal.goalStatus = GoalStatus.up
    newGoal.progressBar = 0
    newGoal.goalPercentage = 0
    newGoal.goalAccomplishmentDate = date
    
    goal.removeAll()
    
    do {
        try context.save()
    } catch {
        print("Array not saved to core data")
    }
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
//        print("Fetch Failed")
    }
}

