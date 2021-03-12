//
//  GoalDeadlineVC.swift
//  Gosio
//
//  Created by ANKIT YADAV on 28/02/21.
//

import Hero
import UIKit
import SPAlert
import CoreData

class GoalDeadlineVC: UIViewController {
    
    
    var emojiStr: String = ""
    var goalNameStr: String = ""
    var goalAmountStr: String = ""
    var goalAccomplishmentDateStr: String = ""
    var RenewalDateFormat = Date()

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emojiLabel: UITextField!
    @IBOutlet weak var goalName: UILabel!
    @IBOutlet weak var goalAmount: UILabel!
    @IBOutlet weak var doneBttn: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    @IBAction func dismissBttnDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func doneBttnDidTap(_ sender: Any) {
        
        switch goalAccomplishmentDateStr {
        case "":
            SPAlert.present(message: "Please select a date", haptic: .error)
        default:
            SPAlert.present(title: "Goal Set", preset: .done)
            createNewGoal()
            DispatchQueue.main.asyncAfter(deadline: .now()+1.6) {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: VCIdentifierManager.dashboardKey) as! DashboardVC
                self.present(vc, animated: true, completion: nil)
            }
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpHeroAnimations()
        
        switch goalAccomplishmentDateStr {
        case "":
            print("set picker")
            setUpRenewaDatePicker()
        default:
            break
        }
        
        titleLabel.attributedText =  NSMutableAttributedString()
            .bold("When you want to ")
            .boldBlueHighlight("accomplish")
            .bold(" this goal?")
        emojiLabel.text = emojiStr
        goalName.text = goalNameStr
        goalAmount.text = "\(getDefaultCurrency().currencySign) \(goalAmountStr)"
        
        let dismissKeyboard = UITapGestureRecognizer(target: self, action: #selector(SwipehideKeyboard))
        view.addGestureRecognizer(dismissKeyboard)
    }
    

}


//MARK:- function()
extension GoalDeadlineVC {
    
    func setUpHeroAnimations(){
        emojiLabel.hero.id = HeroIDs.emojiKey
        goalName.hero.id = HeroIDs.goalNameKey
        goalAmount.hero.id = HeroIDs.goalAmountKey
        doneBttn.hero.id = HeroIDs.buttonKey
        self.hero.isEnabled = true
    }
    
    func createNewGoal() {
        
        let entity = NSEntityDescription.entity(forEntityName: coreDataIdentifierManager.goalKey, in: context)
        let newGoal = Goal(entity: entity!, insertInto: context)
        
        newGoal.emoji = emojiStr
        newGoal.goalName = goalNameStr
        newGoal.goalAchievedAmount = 0.0
        newGoal.goalTotalAmount = NSNumber(value: Float(goalAmountStr)!)
        newGoal.goalStatus = GoalStatus.up
        newGoal.progressBar = 0
        newGoal.goalPercentage = 0
        newGoal.goalAccomplishmentDate = goalAccomplishmentDateStr
        
        goal.removeAll()
        
        do {
            try context.save()
        } catch {
            print("Array not saved to core data")
        }
        
    }
    
    @objc func SwipehideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}


extension GoalDeadlineVC {
    
    
    //Date Picker
    func setUpRenewaDatePicker(){
        datePicker.addTarget(self, action: #selector(renewalDate), for: .allEvents)
        datePicker.minimumDate = Date()
    }
    @objc func renewalDate() {
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .medium
        goalAccomplishmentDateStr = dateFormat.string(from: datePicker.date)
        RenewalDateFormat = datePicker.date
        print("Payment: \(goalAccomplishmentDateStr)")
    }
    
    
}
