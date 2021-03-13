//
//  GoalNameVC.swift
//  Gosio
//
//  Created by ANKIT YADAV on 28/02/21.
//

import Hero
import UIKit
import SPAlert


protocol EmojiDelegate {
func changeValue(value: String)
}


class GoalNameVC: UIViewController, EmojiDelegate {
    
    
    func changeValue(value: String) {
        emojiLabel.text = value
    }

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var goalNameTextField: UITextField!
    @IBOutlet weak var nextBttn: UIButton!
    @IBOutlet weak var nextBttnTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var dismissBttn: UIButton!
    
    
    @IBAction func dismissButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func nextBttnDidTap(_ sender: Any) {
        
        let emoji = emojiLabel.text
        let goalName = goalNameTextField.text
        
        if (emoji?.isEmpty == false) && (goalName?.isEmpty == false) {
            
            let vc = storyboard?.instantiateViewController(withIdentifier: VCIdentifierManager.goalAmountKey) as! GoalAmountVC
            vc.emojiStr = emojiLabel.text!
            vc.goalNameStr = goalNameTextField.text!
            self.present(vc, animated: true, completion: nil)
            
        } else {
            if (emoji?.isEmpty == true) && (goalName?.isEmpty == true)  {
                SPAlert.present(message: "Please enter an emoji and your goal", haptic: .error)
            } else if (emoji?.isEmpty == true) {
                SPAlert.present(message: "Please enter an emoji", haptic: .error)
            } else if (goalName?.isEmpty == true)  {
                SPAlert.present(message: "Please enter your goal", haptic: .error)
            }
        }
        
    }
    @IBAction func goProDidTap(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: VCIdentifierManager.inAppPurchasesKey) as! InAppPurchasesVC
        vc.isHeroEnabledd = true
        self.present(vc, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpGestures()
        setUpHeroAnimations()
        setUpKeyboardNotifications()
        setUpUi()
    }
    
    
}


//MARK:- 🤡 functions()
extension GoalNameVC {
    
    
    func setUpHeroAnimations(){
        
        emojiLabel.hero.id = HeroIDs.emojiKey
        goalNameTextField.hero.id = HeroIDs.goalNameKey
        nextBttn.hero.id = HeroIDs.buttonKey
        dismissBttn.hero.id = HeroIDs.dismissButtonKey
        self.hero.isEnabled = true
        
    }
    
    func setUpUi(){
        
        titleLabel.attributedText =  NSMutableAttributedString()
            .bold("What is it that you truly ")
            .boldBlueHighlight("desire")
            .bold(" ?")
        
    }
    
    func setUpGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(showChooseEmoji))
        emojiLabel.addGestureRecognizer(tap)
        emojiLabel.isUserInteractionEnabled = true
    }
    
    @objc func showChooseEmoji() {
        let vc = storyboard?.instantiateViewController(withIdentifier: VCIdentifierManager.ChooseEmojiKey) as! ChooseEmojiVC
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    
}


//MARK:- ⌨️ keyboard notifications
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
            
        }, completion: { [self]_ in
            nextBttnTopConstraint.constant = 91
            
        })
    }
    
    @objc func SwipehideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
