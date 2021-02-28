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

    @IBAction func dismissBttnDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var emojiLabel: UITextField!
    @IBOutlet weak var goalName: UILabel!
    @IBOutlet weak var goalAmount: UILabel!
    @IBOutlet weak var doneBttn: UIButton!
    
    @IBAction func doneBttnDidTap(_ sender: Any) {
        SPAlert.present(title: "Goal Set!", preset: .done)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1.6) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: VCIdentifierManager.dashboardKey) as! DashboardVC
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpHeroAnimations()
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
