//
//  GoalModel.swift
//  Gosio
//
//  Created by ANKIT YADAV on 01/03/21.
//

import Foundation

struct goalModel: Hashable
{
    var emoji : String = ""
    var goalName : String = ""
    var goalAchievedAmount : Float = 0.0
    var goalTotalAmount : Float = 0.0
    var goalStatus : String = ""
    var progressBar: Float = 0.0
    var goalPercentage: Int = 0
}


var goalArr = [goalModel(emoji: "♻️", goalName: "Buy Lambo", goalAchievedAmount: 0.0, goalTotalAmount: 45000.8, goalStatus: "ahead", progressBar: 0.3, goalPercentage: 0)]
