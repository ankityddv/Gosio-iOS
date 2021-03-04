//
//  GoalExpandVC.swift
//  Gosio
//
//  Created by ANKIT YADAV on 03/03/21.
//

import UIKit
import Hero
import CoreData

class GoalExpandVC: UIViewController {
    
    var indexPathRow = Int()

    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var emoji: UILabel!
    @IBOutlet weak var goalTotalAmount: UILabel!
    @IBOutlet weak var goalAccomplishmentDate: UILabel!
    @IBOutlet weak var goalStatus: UIImageView!
    
    @IBOutlet weak var instructionsLabel: UILabel!
    
    
    
    @IBAction func dismissButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUi()
        setUpHeroAnimations()
        
    }
    
    func setUpUi(){
        let selectedGoal: Goal!
        selectedGoal = goal[indexPathRow]
        
        let goalToAchieve = Int(truncating: selectedGoal.goalTotalAmount!) - Int(truncating: selectedGoal.goalAchievedAmount)
        
        emoji.text = selectedGoal.emoji
        goalTotalAmount.text = "\(currencyCodeString!) \(selectedGoal.goalTotalAmount!)"
        goalAccomplishmentDate.text = String("\(currencyCodeString!) \(goalToAchieve) by \(selectedGoal.goalAccomplishmentDate!)")
        goalStatus.image = UIImage(named: "\(selectedGoal.goalStatus ?? "")Expand")
        
        
        instructionsLabel.attributedText = NSMutableAttributedString()
            .subtitleNormal("Features like goal amount increment, \nediting and deletion are currently \n")
            .subtitleNormalBlueHighlight(" under development.\n")
            .subtitleNormal("\n")
            .subtitleNormal("We request you to ")
            .subtitleNormalBlueHighlight("test")
            .subtitleNormal(" if: \n")
            .subtitleNormal("1. You can ")
            .subtitleNormalBlueHighlight("signin")
            .subtitleNormal(" properly? \n")
            .subtitleNormal("2. You can ")
            .subtitleNormalBlueHighlight("add new goals.\n")
            .subtitleNormal("3. You can set default currency, \napp icon, app theme.\n")
            .subtitleNormal("4. You can add new goal by ")
            .subtitleNormalBlueHighlight("asking Siri\n")
            .subtitleNormal("to do that for you?\n")
            .subtitleNormal("\n")
            .subtitleNormal("Follow us on Twitter/Instagram ")
            .subtitleNormalBlueHighlight("@GosioApp")
            .subtitleNormal(" for regular updates on what's cooking, you can always slide into our DM's to report any issue :)")
        
    }
    
    func setUpHeroAnimations(){
        goalTotalAmount.hero.id = HeroIDs.totalGoalAmountKey
        dismissButton.hero.id = HeroIDs.dismissButtonKey
        emoji.hero.id = HeroIDs.emojiInDashboardKey
        goalAccomplishmentDate.hero.id = HeroIDs.goalAccomplishmentDateKey
        self.hero.isEnabled = true
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
