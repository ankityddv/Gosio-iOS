//
//  GoalNameVC.swift
//  Gosio
//
//  Created by ANKIT YADAV on 28/02/21.
//

import Hero
import UIKit
import SPAlert

class GoalNameVC: UIViewController {

    @IBAction func dismissButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emojiTextField: UITextField!
    @IBOutlet weak var goalNameTextField: UITextField!
    @IBOutlet weak var nextBttn: UIButton!
    @IBOutlet weak var nextBttnTopConstraint: NSLayoutConstraint!
    
    @IBAction func nextBttnDidTap(_ sender: Any) {
        
        let emoji = emojiTextField.text
        let goalName = goalNameTextField.text
        
        if emoji != "" && goalName != "" {
            
            let vc = storyboard?.instantiateViewController(withIdentifier: VCIdentifierManager.goalAmountKey) as! GoalAmountVC
            vc.emojiStr = emojiTextField.text!
            vc.goalNameStr = goalNameTextField.text!
            self.present(vc, animated: true, completion: nil)
            
        } else {
            // Edit Stat
            if (emoji == "") && (goalName == "")  {
                SPAlert.present(message: "Please enter an emoji and your goal", haptic: .error)
            } else if (emoji == "") {
                SPAlert.present(message: "Please enter an emoji", haptic: .error)
            } else if (goalName == "")  {
                SPAlert.present(message: "Please enter your goal", haptic: .error)
            }
            
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpHeroAnimations()
        setUpKeyboardNotifications()
        
        titleLabel.attributedText =  NSMutableAttributedString()
            .bold("What is it that you truly ")
            .boldBlueHighlight("desire")
            .bold(" ?")
        
    }
    

}


//MARK:- function()
extension GoalNameVC {
    
    func setUpHeroAnimations(){
        emojiTextField.hero.id = HeroIDs.emojiKey
        goalNameTextField.hero.id = HeroIDs.goalNameKey
        nextBttn.hero.id = HeroIDs.buttonKey
        self.hero.isEnabled = true
    }
    
}

//MARK:- keyboard notifications
extension GoalNameVC {
    
    func setUpKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        let dismissKeyboard = UITapGestureRecognizer(target: self, action: #selector(SwipehideKeyboard))
        view.addGestureRecognizer(dismissKeyboard)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {

        let userInfo = notification.userInfo
        let keyboardSize = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let keyboardHeight = keyboardSize.cgRectValue.height
        
        UIView.animate(withDuration: 0.3, animations: {
            self.nextBttn.frame.origin.y = screenHeight - (keyboardHeight + 50)
            print(screenHeight - (keyboardHeight + 50))
            
        }, completion: { [self]_ in
            nextBttnTopConstraint.constant = 91-68
            print("Done")
        })

    }

    @objc func keyboardWillHide(notification: NSNotification) {
        print("Dismissed")
    }
    
    @objc func SwipehideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
