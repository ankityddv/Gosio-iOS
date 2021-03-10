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

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emojiTextField: UITextField!
    @IBOutlet weak var goalNameTextField: UITextField!
    @IBOutlet weak var nextBttn: UIButton!
    @IBOutlet weak var nextBttnTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var gotProAddView: AnimatedView!
    @IBOutlet weak var goProIllustration: UIImageView!
    @IBOutlet weak var goProLabel: UILabel!
    @IBOutlet weak var goProBttn: UIButton!
    @IBOutlet weak var dismissBttn: UIButton!
    
    @IBAction func dismissButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func nextBttnDidTap(_ sender: Any) {
        
        let emoji = emojiTextField.text
        let goalName = goalNameTextField.text
        
        if (emoji?.isEmpty == false) && (goalName?.isEmpty == false) {
            
            let vc = storyboard?.instantiateViewController(withIdentifier: VCIdentifierManager.goalAmountKey) as! GoalAmountVC
            vc.emojiStr = emojiTextField.text!
            vc.goalNameStr = goalNameTextField.text!
            self.present(vc, animated: true, completion: nil)
            
        } else {
            // Show error
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
        setUpHeroAnimations()
        setUpKeyboardNotifications()
        setUpUi()
    }
    
}


//MARK:- function()
extension GoalNameVC {
    
    
    func setUpHeroAnimations(){
        emojiTextField.hero.id = HeroIDs.emojiKey
        goalNameTextField.hero.id = HeroIDs.goalNameKey
        nextBttn.hero.id = HeroIDs.buttonKey
        self.hero.isEnabled = true
        
        goProIllustration.hero.id = HeroIDs.IAPIllustrationKey
        goProLabel.hero.id = HeroIDs.goProLabelKey
        goProBttn.hero.id = HeroIDs.goProBttnKey
        dismissBttn.hero.id = HeroIDs.dismissButtonKey
        
    }
    
    func setUpUi(){
        titleLabel.attributedText =  NSMutableAttributedString()
            .bold("What is it that you truly ")
            .boldBlueHighlight("desire")
            .bold(" ?")
        
        switch validateSubscription() {
        case .pro:
            gotProAddView.isHidden = true
        case .free:
            print("Free")
        case .unidentified:
            print("Unidentified")
        }
        
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
            self.gotProAddView.frame.origin.y = 650
    //            print(screenHeight - (keyboardHeight + 50))
            
        }, completion: { [self]_ in
            nextBttnTopConstraint.constant = 91
            
        })
    }
    
    @objc func SwipehideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
