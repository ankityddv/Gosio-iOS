//
//  GoalDeadlineVC.swift
//  Gosio
//
//  Created by ANKIT YADAV on 28/02/21.
//

import Hero
import SPAlert
import UIKit

class GoalDeadlineVC: UIViewController {
    
    var emojiStr: String = ""
    var goalNameStr: String = ""
    var goalAmountStr: String = ""
    var NextPaymentDateString = ""
    var RenewalDateFormat = Date()

    @IBAction func dismissBttnDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emojiLabel: UITextField!
    @IBOutlet weak var goalName: UILabel!
    @IBOutlet weak var goalAmount: UILabel!
    @IBOutlet weak var doneBttn: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func doneBttnDidTap(_ sender: Any) {
        SPAlert.present(title: "Goal Set!", preset: .done)
        
//        print("Date: \(RenewalDateFormat) and \(NextPaymentDateString)")
        createNewGoal()
        DispatchQueue.main.asyncAfter(deadline: .now()+1.6) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: VCIdentifierManager.dashboardKey) as! DashboardVC
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
    func createNewGoal() {
        goalArr.insert(goalModel(emoji: emojiStr, goalName: goalNameStr, goalAchievedAmount: 0.0, goalTotalAmount: Float(goalAmountStr)!, goalStatus: "ahead", progressBar: 0, goalPercentage: 0), at: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpHeroAnimations()
        
        switch NextPaymentDateString {
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
        goalAmount.text = goalAmountStr
        
        let dismissKeyboard = UITapGestureRecognizer(target: self, action: #selector(SwipehideKeyboard))
        view.addGestureRecognizer(dismissKeyboard)
    }
    @objc func SwipehideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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
        NextPaymentDateString = dateFormat.string(from: datePicker.date)
        RenewalDateFormat = datePicker.date
        print("Payment: \(NextPaymentDateString)")
    }
}
