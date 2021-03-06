//
//  GoalExpandVC.swift
//  Gosio
//
//  Created by ANKIT YADAV on 03/03/21.
//

import UIKit
import Hero
import SPAlert
import CoreData


class GoalExpandVC: UIViewController {

    
    var selectedGoal: Goal? = nil
    var achievedAmount = Float()
    var oldAchievedAmount = Float()
    var deletAlertContainerView   = UIView()
    let deleteAlertpopUpViewHeight: CGFloat = 410
    var isUpdated: Bool = false
    
    
    @IBOutlet weak var slideAssistView: UIView!
    @IBOutlet weak var titleLabelInPopUp: UILabel!
    @IBOutlet var editOptionsView: UIView!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var emoji: UILabel!
    @IBOutlet weak var goalTotalAmount: UILabel!
    @IBOutlet weak var goalAccomplishmentDate: UILabel!
    @IBOutlet weak var goalStatus: UIImageView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var picker: BalloonPickerView!
    @IBOutlet weak var deleteBttn: UIButton!
    @IBOutlet weak var addMoneyBttn: UIButton!
    @IBOutlet var updatePopUpView: UIView!
    @IBOutlet weak var dismissBttn: UIButton!
    
    
    // ⬆️ Pro popUp
    @IBOutlet weak var gotProAdView: AnimatedView!
    @IBOutlet weak var goProIllustration: UIImageView!
    @IBOutlet weak var goProLabel: UILabel!
    @IBOutlet weak var goProBttn: UIButton!
    
    
    @IBAction func goProBttnDidTap(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: VCIdentifierManager.inAppPurchasesKey) as! InAppPurchasesVC
        vc.isHeroEnabledd = true
        self.present(vc, animated: true, completion: nil)
        
    }
    @IBAction func dismissPopUpBttnDidTao(_ sender: Any) {
        
        dissmissUpdatePopUp()
    
    }
    @IBAction func addMoneyDidTap(_ sender: Any) {
        
        showUpdatePopUp(sender)
    
    }
    @IBAction func dismissButtonDidTap(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    
    }
    //Edit
    @IBAction func saveButtonDidTap(_ sender: Any) {
        
        let percentage = Int(((achievedAmount) / Float(truncating: (selectedGoal!.goalTotalAmount!)))*100)
        let progress = Float(((achievedAmount) / Float(truncating: (selectedGoal!.goalTotalAmount!))))

    //        print(achievedAmount)
    //        print(percentage)
    //        print("Progress = \(achievedAmount) / \(selectedGoal!.goalTotalAmount!) =  \(progress)")
        
        if selectedGoal == nil {
            print("New Note")
        } else {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: coreDataIdentifierManager.goalKey)
            do {
                let results:NSArray = try context.fetch(request) as NSArray
                for result in results
                {
                    let goal = result as! Goal
                    if(goal == selectedGoal)
                    {
                        goal.emoji = selectedGoal!.emoji
                        goal.goalName = selectedGoal!.goalName
                        goal.goalAchievedAmount = NSNumber(value: achievedAmount)
                        goal.goalTotalAmount = selectedGoal!.goalTotalAmount
                        if (achievedAmount > oldAchievedAmount ) {
                            goal.goalStatus = GoalStatus.up
//                            print("up")
                        } else if (achievedAmount == oldAchievedAmount ) {
                            goal.goalStatus = GoalStatus.pause
//                            print("pause")
                        } else if (achievedAmount < oldAchievedAmount ) {
                            goal.goalStatus = GoalStatus.down
//                            print("down")
                        }
                        goal.progressBar = NSNumber(value: progress)
                        goal.goalPercentage = NSNumber(value: percentage)
                        goal.goalAccomplishmentDate = selectedGoal!.goalAccomplishmentDate
                        try context.save()
    //                        print("Saved ✅")
                        isUpdated = true
                        dissmissUpdatePopUp()
                    }
                }
                SPAlert.present(title: "Updated", preset: .done, haptic: .success)
            } catch {
//                print("Fetch Failed")
            }
            
        }
        
        if (achievedAmount > oldAchievedAmount ) {
            goalStatus.image = UIImage(named: "\(GoalStatus.up)Expand")
        } else if (achievedAmount == oldAchievedAmount ) {
            goalStatus.image = UIImage(named: "\(GoalStatus.pause)Expand")
        } else if (achievedAmount < oldAchievedAmount ) {
            goalStatus.image = UIImage(named: "\(GoalStatus.down)Expand")
        }
        
    }
    @IBAction func deleteBttnDidTap(_ sender: Any) {
        
        lightImpactHeptic()
        
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Give up", style: .destructive) { [self] _ in
            deleteGoal(selectedGoal: self.selectedGoal!)
            self.dismiss(animated: true, completion: nil)
        }
        
        let titleFont = [NSAttributedString.Key.font: UIFont(name: "AirbnbCerealApp-Bold", size: 18.0)!]
        let messageFont = [NSAttributedString.Key.font: UIFont(name: "AirbnbCerealApp-Book", size: 12.0)!]

        let titleAttrString = NSMutableAttributedString(string: "Are you sure?", attributes: titleFont)
        let messageAttrString = NSMutableAttributedString(string: "Procrastination isn't healthy, think once again, you can still achieve it 💪🏻", attributes: messageFont)

        alertController.setValue(titleAttrString, forKey: "attributedTitle")
        alertController.setValue(messageAttrString, forKey: "attributedMessage")
        
        alertController.addAction(deleteAction)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.view.tintColor = UIColor(named: "AccentColor")
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUi()
        setUpHeroAnimations()
        setUpBalloon()
        oldAchievedAmount = selectedGoal!.goalAchievedAmount as! Float
        
    }
    
    
}


//MARK:- 🤡 functions() 
extension GoalExpandVC {
    
    
    func setUpUi() {
        
        let goalToAchieve = Int(truncating: selectedGoal!.goalTotalAmount!) - Int(truncating: selectedGoal!.goalAchievedAmount)
        
        let goalAccomplishmentDatee = "\(selectedGoal!.goalAccomplishmentDate!)".replacingOccurrences(of: "-", with: " ", options: .literal, range: nil)
        
        emoji.text = selectedGoal!.emoji
        goalTotalAmount.text = "\(getDefaultCurrency().currencySign) \(selectedGoal!.goalTotalAmount!)"
        goalAccomplishmentDate.text = String("\(getDefaultCurrency().currencySign) \(goalToAchieve) by \(goalAccomplishmentDatee)")
        goalStatus.image = UIImage(named: "\(selectedGoal!.goalStatus ?? "")Expand")
        progressBar.setProgress(selectedGoal!.progressBar! as! Float, animated: true)
        deleteBttn.layer.borderColor = UIColor(named: "SecondaryBgColor")?.cgColor
        slideAssistView.roundCorners(.allCorners, radius: 10)
        
        titleLabelInPopUp.attributedText = NSMutableAttributedString()
            .bold("You've ")
            .boldBlueHighlight("earned")
            .bold(" it, now \nupdate it 💪🏻")
        
        switch getIAPStatus() {
        case .unidentified:
//            print("Unidentified")
            break
        case .pro:
            gotProAdView.isHidden = true
        case .free:
//            print("Free")
            break
        
        }
        
        
    }
    
    func setUpHeroAnimations() {
        
        goalTotalAmount.hero.id = HeroIDs.totalGoalAmountKey
        dismissButton.hero.id = HeroIDs.dismissButtonKey
        emoji.hero.id = HeroIDs.emojiInDashboardKey
        goalAccomplishmentDate.hero.id = HeroIDs.goalAccomplishmentDateKey
        
        addMoneyBttn.hero.id = HeroIDs.buttonKey
        goProIllustration.hero.id = HeroIDs.IAPIllustrationKey
        goProLabel.hero.id = HeroIDs.goProLabelKey
        goProBttn.hero.id = HeroIDs.goProBttnKey
        dismissBttn.hero.id = HeroIDs.dismissButtonKey
//        gotProAdView.hero.id = HeroIDs.goProAdBgViewKey
        self.hero.isEnabled = true
        
    }
    
    func setUpBalloon() {
        
        let balloonView = BalloonView()
        balloonView.image = #imageLiteral(resourceName: "balloon")
        picker.baloonView = balloonView
        picker.maximumValue = Double(truncating: selectedGoal!.goalTotalAmount!)
        picker.value = Double(truncating: selectedGoal!.goalAchievedAmount!)
        picker.tintColor = UIColor(named: "AccentColor")
        valueChanged()
    }

    @IBAction func valueChanged() {
        
        achievedAmount = Float(picker.value)
        let progress = Float(((achievedAmount) / Float(truncating: (selectedGoal!.goalTotalAmount!))))
        let goalToAchieve = Int(truncating: selectedGoal!.goalTotalAmount!) - Int(truncating: NSNumber(value: achievedAmount))
        
        let goalAccomplishmentDatee = "\(selectedGoal!.goalAccomplishmentDate!)".replacingOccurrences(of: "-", with: " ", options: .literal, range: nil)
        
        goalAccomplishmentDate.text = String("\(getDefaultCurrency().currencySign) \(goalToAchieve) by \(goalAccomplishmentDatee)")
        
        progressBar.setProgress(progress, animated: true)
    }
    
    
}


//MARK:- ⬆️ SetUp Popup
extension GoalExpandVC {
    
    
    // Setup alert Popup
    @objc func showUpdatePopUp(_ sender: Any) {
        
        // make screen unresponsive
        self.view.isUserInteractionEnabled = false
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dissmissUpdatePopUp))
        deletAlertContainerView.addGestureRecognizer(tap)
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.dissmissUpdatePopUp))
        swipeGesture.direction = [.down]
        deletAlertContainerView.addGestureRecognizer(swipeGesture)
        updatePopUpView.addGestureRecognizer(swipeGesture)
        
        deletAlertContainerView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        deletAlertContainerView.frame = self.view.frame
        window?.addSubview(deletAlertContainerView)
            
        
        // Set up PopUp View
        switch currentDevice {
        case .pad:
            deletAlertContainerView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            deletAlertContainerView.frame = CGRect(x: 0, y: 0, width: 3000, height: 3000)
            window?.addSubview(deletAlertContainerView)
            let xx = (self.view.frame.width - 414)/2
            updatePopUpView.frame = CGRect(x: xx,
                                          y: 2000,
                                          width: 414,
                                          height: deleteAlertpopUpViewHeight)
            updatePopUpView.clipsToBounds = true
            updatePopUpView.layer.cornerRadius = 30
            window?.addSubview(updatePopUpView)
        case .phone:
            deletAlertContainerView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            deletAlertContainerView.frame = self.view.frame
            window?.addSubview(deletAlertContainerView)
            
            updatePopUpView.frame = CGRect(x: 0,
                                          y: screenSize.height,
                                          width: screenSize.width,
                                          height: deleteAlertpopUpViewHeight)
            updatePopUpView.clipsToBounds = true
            updatePopUpView.layer.cornerRadius = 30
            updatePopUpView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
            window?.addSubview(updatePopUpView)
        default:
            break
        }
            
        // PopUp View animation on opening
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 1.0,
                       options: .curveEaseInOut,
                       animations: {
                        switch currentDevice {
                        case .pad:
                            self.deletAlertContainerView.alpha = 0.8
                            let xx = (self.view.frame.width - 414)/2
                            let yy = (self.view.frame.height - self.deleteAlertpopUpViewHeight)/2
                            self.deletAlertContainerView.isUserInteractionEnabled = false
                            self.updatePopUpView.frame = CGRect(x: xx, y: yy, width: 414, height: self.deleteAlertpopUpViewHeight)
                        case .phone:
                            switch currentIphone() {
                            case .iPhoneX:
                                self.deletAlertContainerView.alpha = 0.8
                                self.deletAlertContainerView.isUserInteractionEnabled = false
                                self.updatePopUpView.frame = CGRect(x: 0, y: screenHeight - self.deleteAlertpopUpViewHeight, width: screenWidth, height: self.deleteAlertpopUpViewHeight)
                            case .iPhone8:
                                self.updatePopUpView.layer.cornerRadius = 20
                                self.deletAlertContainerView.alpha = 0.8
                                self.deletAlertContainerView.isUserInteractionEnabled = false
                                self.updatePopUpView.frame = CGRect(x: 0, y: screenHeight - self.deleteAlertpopUpViewHeight, width: screenWidth, height: self.deleteAlertpopUpViewHeight)
                            }
                        default:
                            break
                        }
                        }, completion: nil)
        
    }
    
    
    @objc func dissmissUpdatePopUp() {
        
        if !isUpdated {
            setUpUi()
        }
        
        // make screen unresponsive
        self.view.isUserInteractionEnabled = true
        
        // Container View animation on closing
        UIView.animate(withDuration: 1,
                             delay: 0,
                             usingSpringWithDamping: 1.0,
                             initialSpringVelocity: 1.0,
                             options: .curveEaseInOut,
                             animations: {
                                self.deletAlertContainerView.alpha = 0
                             }, completion: nil)
            
        // PopUp View animation on closing
        UIView.animate(withDuration: 1,
                             delay: 0,
                             usingSpringWithDamping: 1.0,
                             initialSpringVelocity: 1.0,
                             options: .curveEaseInOut,
                             animations: {
                                
                                switch currentDevice {
                                case .pad:
                                    self.deletAlertContainerView.alpha = 0
                                    let xx = (self.view.frame.width - 414)/2
                                    self.updatePopUpView.frame = CGRect(x: xx,
                                                                         y: 2000,
                                                                         width: 414,
                                                                         height: 0)
                                case .phone:
                                    self.deletAlertContainerView.alpha = 0
                                    self.updatePopUpView.frame = CGRect(x: 0,
                                                                         y: screenHeight,
                                                                         width: screenWidth,
                                                                         height: 0)
                                default:
                                    break
                                }
                             }, completion: nil)
    }
}
