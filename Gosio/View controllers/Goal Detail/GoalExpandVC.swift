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
    
    
    // Pro popUp
    @IBOutlet weak var goProIllustration: UIImageView!
    @IBOutlet weak var goProLabel: UILabel!
    @IBOutlet weak var goProBttn: UIButton!
    @IBOutlet weak var goProBgView: AnimatedView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUi()
        setUpHeroAnimations()
        setUpBalloon()
        oldAchievedAmount = selectedGoal!.goalAchievedAmount as! Float
    }

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
                            print("up")
                        } else if (achievedAmount == oldAchievedAmount ) {
                            goal.goalStatus = GoalStatus.pause
                            print("pause")
                        } else if (achievedAmount < oldAchievedAmount ) {
                            goal.goalStatus = GoalStatus.down
                            print("down")
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
                print("Fetch Failed")
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
        // create the alert
        let alert = UIAlertController(title: "Are you sure?", message: "Procrastination isn't healthy, think once again, you can still achieve it 💪🏻 ", preferredStyle: UIAlertController.Style.alert)

        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Give up", style: UIAlertAction.Style.destructive, handler: { action in
            
            deleteGoal(selectedGoal: self.selectedGoal!)
            
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
//        alert.addAction(UIAlertAction(title: "Launch the Missile", style: UIAlertAction.Style.destructive, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }


}


//MARK:- functions()
extension GoalExpandVC {
    
    func setUpUi() {
        
        let goalToAchieve = Int(truncating: selectedGoal!.goalTotalAmount!) - Int(truncating: selectedGoal!.goalAchievedAmount)
        
        emoji.text = selectedGoal!.emoji
        goalTotalAmount.text = "\(currencyCodeString!) \(selectedGoal!.goalTotalAmount!)"
        goalAccomplishmentDate.text = String("\(currencyCodeString!) \(goalToAchieve) by \(selectedGoal!.goalAccomplishmentDate!)")
        goalStatus.image = UIImage(named: "\(selectedGoal!.goalStatus ?? "")Expand")
        progressBar.setProgress(selectedGoal!.progressBar! as! Float, animated: true)
        deleteBttn.layer.borderColor = UIColor(named: "SecondaryBgColor")?.cgColor
        slideAssistView.roundCorners(.allCorners, radius: 10)
        
        
//        instructions.attributedText = NSMutableAttributedString()
//            .subtitleNormal("Features like goal amount increment, \nediting and deletion are currently \n")
//            .subtitleNormalBlueHighlight(" under development.\n")
//            .subtitleNormal("\n")
//            .subtitleNormal("We request you to ")
//            .subtitleNormalBlueHighlight("test")
//            .subtitleNormal(" if: \n")
//            .subtitleNormal("1. You can ")
//            .subtitleNormalBlueHighlight("signin")
//            .subtitleNormal(" properly? \n")
//            .subtitleNormal("2. You can ")
//            .subtitleNormalBlueHighlight("add new goals.\n")
//            .subtitleNormal("3. You can set default currency, \napp icon, app theme.\n")
//            .subtitleNormal("4. You can add new goal by ")
//            .subtitleNormalBlueHighlight("asking Siri\n")
//            .subtitleNormal("to do that for you?\n")
//            .subtitleNormal("\n")
//            .subtitleNormal("Follow us on Twitter/Instagram ")
//            .subtitleNormalBlueHighlight("@GosioApp")
//            .subtitleNormal(" for regular updates on what's cooking, you can always slide into our DM's to report any issue :)")
        
        titleLabelInPopUp.attributedText = NSMutableAttributedString()
            .bold("You've ")
            .boldBlueHighlight("earned")
            .bold(" it, now \nupdate it 💪🏻")
        
        switch validateSubscription() {
        case .pro:
            goProBgView.isHidden = true
        case .free:
            print("Free")
        case .unidentified:
            print("Unidentified")
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
        
        goalAccomplishmentDate.text = String("\(currencyCodeString!) \(goalToAchieve) by \(selectedGoal!.goalAccomplishmentDate!)")
        
        progressBar.setProgress(progress, animated: true)
    }
    
}

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
                                self.updatePopUpView.frame = CGRect(x: 0, y: screenHeight - self.deleteAlertpopUpViewHeight + 45, width: screenWidth, height: self.deleteAlertpopUpViewHeight - 45)
                            }
                        default:
                            break
                        }
                        }, completion: nil)
        
    }
    
    
    @objc func dissmissUpdatePopUp() {
        
        if isUpdated == false {
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

func updateIAPStatus(status: Bool) {
    
     let entity = NSEntityDescription.entity(forEntityName: "InAppPurchase", in: context)
     let newEntity = NSManagedObject(entity: entity!, insertInto: context)
     
     newEntity.setValue(status, forKey: "isPro")
 
     do {
         try context.save()
         print("Saved")
     } catch {
         print("Fucked it while saving!")
     }
    
}

func getIAPStatus() {
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "InAppPurchase")
    request.returnsObjectsAsFaults = false
    var boole : Bool!
    do {
        let result = try context.fetch(request)
        for data in result as! [NSManagedObject] {
            boole = (data.value(forKey: "isPro") as! Bool)
        }
        print("Fetched - \(boole)")
    } catch {
        print("Fucked it while fetching!")
    }
}


/*

func save(_ sender: Any) {
 let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
 let entity = NSEntityDescription.entity(forEntityName: "Entity", in: context)
 let newEntity = NSManagedObject(entity: entity!, insertInto: context)
 
 newEntity.setValue(score, forKey: "number")
 
 do {
     try context.save()
     print("Saved")
 } catch {
     print("Fucked it while saving!")
 }
}

func getData(){
 let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
 let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
 request.returnsObjectsAsFaults = false
 
 do {
     let result = try context.fetch(request)
     for data in result as! [NSManagedObject] {
         score = data.value(forKey: "number") as! Int
     }
     print("Fetched")
 } catch {
     print("Fucked it while fetching!")
 }
 
}

*/
