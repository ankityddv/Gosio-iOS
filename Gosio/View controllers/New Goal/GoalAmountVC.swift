//
//  GoalAmountVC.swift
//  Gosio
//
//  Created by ANKIT YADAV on 28/02/21.
//

import Hero
import UIKit
import SPAlert


class GoalAmountVC: UIViewController {
    
    
    var emojiStr: String = ""
    var goalNameStr: String = ""

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emojiLabel: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var nextBttn: UIButton!
    @IBOutlet weak var nextBttnTopConstraint: NSLayoutConstraint!
    
    
    @IBAction func dismissBttnDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func nextBttnDidTap(_ sender: Any) {
        
        let amount = amountTextField.text!
        
        switch amount {
        case "":
            SPAlert.present(message: "Please enter an amount", haptic: .error)
        default:
            if Float(amount) != nil {
                let vc = storyboard?.instantiateViewController(withIdentifier: VCIdentifierManager.goalDeadlineKey) as! GoalDeadlineVC
                vc.emojiStr = emojiStr
                vc.goalNameStr = goalNameStr
                vc.goalAmountStr = String(Float(amount)!)
                self.present(vc, animated: true, completion: nil)
            } else {
                SPAlert.present(message: "Please enter a valid amount", haptic: .error)
            }
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpHeroAnimations()
        setUpKeyboardNotifications()
        setUpUi()
    }
    

}


//MARK:- 🤡 functions()
extension GoalAmountVC {
    
    
    func setUpHeroAnimations(){
        titleLabel.hero.id = HeroIDs.goalNameKey
        emojiLabel.hero.id = HeroIDs.emojiKey
        amountTextField.hero.id = HeroIDs.goalAmountKey
        nextBttn.hero.id = HeroIDs.buttonKey
        self.hero.isEnabled = true
    }
    
    func setUpUi(){
        emojiLabel.text = emojiStr
        
        titleLabel.attributedText =  NSMutableAttributedString()
            .bold("What is the amount you need for ")
            .boldBlueHighlight("\(goalNameStr)")
            .bold(" ?")
    }
    
    
}


//MARK:- ⌨️ keyboard notifications
extension GoalAmountVC {
    
    
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
    //            print(screenHeight - (keyboardHeight + 50))
            
        }, completion: { [self]_ in
            nextBttnTopConstraint.constant = 91-68
    //            print("Done")
        })

    }

    @objc func keyboardWillHide(notification: NSNotification) {
        
    //        print("Dismissed")
        UIView.animate(withDuration: 0.3, animations: {
            self.nextBttn.frame.origin.y = 568
    //            print(screenHeight - (keyboardHeight + 50))
            
        }, completion: { [self]_ in
            nextBttnTopConstraint.constant = 91
            
        })
        
    }
    
    @objc func SwipehideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    
}
