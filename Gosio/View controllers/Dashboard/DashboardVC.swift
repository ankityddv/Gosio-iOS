//
//  DashboardVC.swift
//  Gosio
//
//  Created by ANKIT YADAV on 28/02/21.
//

import Hero
import UIKit
import StoreKit
import CoreData

class DashboardVC: UIViewController, LoginViewControllerDelegate {
    
    func didFinishAuth() {
        label.text = "User identified: \(String(describing: userDefaults?.string(forKey: SignInWithAppleManager.userIdentifierKey)!))"
    }
    
    let label = UILabel()
    var userFirstName = ""
    var userEmail = ""
    
    var firstLoad = true
    
    func fetchData() {
        if (firstLoad) {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context:NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Goal")
            
            do{
                let results:NSArray = try context.fetch(request) as NSArray
                for result in results {
                    let myGoal = result as! Goal
                    goal.append(myGoal)
                }
            } catch {
                print("Fetch failed")
            }
        }
    }
    
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var totalGoalAmount: UILabel!
    @IBOutlet weak var tableVieww: FadingTableView!
    @IBOutlet weak var addNewGoalBttn: UIButton!
    @IBOutlet weak var menuBttn: UIButton!
    
    
    @IBAction func showMenu(_ sender: Any) {
        
        /*
        let favorite = UIAction(title: "Show me stats",
                                image: UIImage(systemName: "number")) { [self] _ in
          // Perform action
            showMenuPopUp()
        }
        let settings = UIAction(title: "Settings",
          image: UIImage(systemName: "gearshape")) { _ in
          // Perform action
            let vc = self.storyboard?.instantiateViewController(withIdentifier: VCIdentifierManager.settingsKey) as! SettingsVC
            let navigationController = UINavigationController(rootViewController: vc)
            navigationController.modalPresentationStyle = .automatic
            self.present(navigationController, animated: true, completion: nil)
        }

        menuBttn.showsMenuAsPrimaryAction = true
        menuBttn.menu = UIMenu(title: "", children: [favorite,settings])
         */
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: VCIdentifierManager.settingsKey) as! SettingsVC
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .automatic
        self.present(navigationController, animated: true, completion: nil)
    }
    
    
    @objc
    func showMenuPopUp(){
        let slideVC = MenuView()
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        self.present(slideVC, animated: true, completion: nil)
    }
    
    @IBAction func addNewGoalDidTap(_ sender: Any) {
        addNewGoal()
    }
    
    @objc
    func addNewGoal(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: VCIdentifierManager.goalNameKey) as! GoalNameVC
        self.present(vc, animated: true, completion: nil)
        createUSerActivity()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestReview()
        fetchData()
        updateTotalAmount()
        initialiseAppTheme()
        initialiseCurrency()
        self.navigationController?.isNavigationBarHidden = true
        
        emojiLabel.hero.id = HeroIDs.emojiInDashboardKey
        totalGoalAmount.hero.id = HeroIDs.totalGoalAmountKey
        addNewGoalBttn.hero.id = HeroIDs.buttonKey
        menuBttn.hero.id = HeroIDs.dismissButtonKey
        self.hero.isEnabled = true
        
//        let userFirstNameSTr = (userDefaults?.string(forKey: SignInWithAppleManager.userFirstNameKey)!)!
//        let userEmailSTr = (userDefaults?.string(forKey: SignInWithAppleManager.userEmailKey)!)!
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        vaildateOnboarding()
    }

}


//MARK:- delegate for popUp
extension DashboardVC: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}


//MARK:- functions()
extension DashboardVC {
    
    func vaildateOnboarding(){
        switch checkOnboardingState() {
        case .sendToDashboard:
            print("sendToDashboard")
            vaidateAuth()
            break
        case .sendToOnboarding:
            print("sendToOnboarding")
            let vc = storyboard?.instantiateViewController(withIdentifier: VCIdentifierManager.onboardingKey) as! OnboardingVC
            self.present(vc, animated: false, completion: nil)
            break
        }
    }
    
    func vaidateAuth() {
        SignInWithAppleManager.checkUserAuth{ (authState) in
            switch authState {
            case .undefined:
                let vc = self.storyboard?.instantiateViewController(identifier: VCIdentifierManager.loginKey) as! LoginVC
                vc.delegate = self
                self.present(vc, animated: false, completion: nil)
                print("Send to Login")
            case .signedIn:
//                self.userFirstName = (userDefaults?.string(forKey: SignInWithAppleManager.userFirstNameKey)!)!
//                self.userEmail = (userDefaults?.string(forKey: SignInWithAppleManager.userEmailKey)!)!
                print("SignedIN")
            case .signedOut:
                print("Signed Out")
            }
        }
    }
    
    func createUSerActivity(){
        let activity = NSUserActivity(activityType: UserActivityType.addNewGoal)
        activity.title = "Add new goal"
        activity.isEligibleForSearch = true
        activity.isEligibleForPrediction = true
        
        self.userActivity = activity
        self.userActivity?.becomeCurrent()
    }
    
    func initialiseCurrency() {
        initialiseAppIcon()
        switch (userDefaults?.object(forKey: userDefaultsKeyManager.currencyCodeKey) as? String)  {
        case nil:
            userDefaults?.set("USD", forKey: userDefaultsKeyManager.currencyCodeKey)
            userDefaults?.set("$", forKey: userDefaultsKeyManager.currencySignKey)
        default:
            break
        }
    }
    
    func initialiseAppIcon() {
        switch (userDefaults?.object(forKey: userDefaultsKeyManager.appIconKey) as? Int)  {
        case nil:
            userDefaults?.set(0, forKey: userDefaultsKeyManager.appIconKey)
        default:
            break
        }
    }
    
    func updateTotalAmount(){
        
        let sum = goal.map({$0.goalAchievedAmount! as! Int}).reduce(0, +)
        
        switch userDefaults?.object(forKey: userDefaultsKeyManager.currencySignKey) as? String {
        case nil:
            totalGoalAmount.text = "$ \(Int(sum))"
        default:
            totalGoalAmount.text = "\(currencyCodeString!) \(Int(sum))"
        }
        
    }
    
    func initialiseAppTheme() {
        // Read userdefaults
        
        switch (userDefaults?.object(forKey: userDefaultsKeyManager.themeKey) as? Int) {
        case nil:
            break
        default:
            let integer = userDefaults?.object(forKey: userDefaultsKeyManager.themeKey) as? Int
            
            if (userDefaults?.object(forKey: userDefaultsKeyManager.themeKey) as? Int) != nil {
                // send to home
                if integer! == 0 {
                    UIApplication.shared.windows.forEach { window in
                        window.overrideUserInterfaceStyle = .unspecified
                    }
                } else if integer! == 1{
                    UIApplication.shared.windows.forEach { window in
                        window.overrideUserInterfaceStyle = .light
                    }
                } else if integer! == 2{
                    UIApplication.shared.windows.forEach { window in
                        window.overrideUserInterfaceStyle = .dark
                    }
                }
            }
        }
    }
    
    func requestReview(){
        
        switch userDefaults?.object(forKey: userDefaultsKeyManager.requestReviewKey) as? Int {
        case nil:
            reviewInteger = 0
            userDefaults?.set(reviewInteger!, forKey: userDefaultsKeyManager.requestReviewKey)
        default:
            switch reviewInteger! % 8 {
            case 0:
                SKStoreReviewController.requestReview()
            default:
                break
            }
            reviewInteger! += 1
            userDefaults?.set(reviewInteger!, forKey: userDefaultsKeyManager.requestReviewKey)
        }
        
    }
    
}


//MARK:- Table View
extension DashboardVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return goalArr.count
        return goal.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: goalsCell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifierManager.dashboardCell, for: indexPath) as! goalsCell
        
        let thisGoal: Goal!
        thisGoal = goal[indexPath.row]
        
        cell.goalEmoji.text = thisGoal.emoji
        cell.goalName.text = thisGoal.goalName
        
        switch userDefaults?.object(forKey: userDefaultsKeyManager.currencyCodeKey) as? String {
            case nil:
                cell.goalAmount.text = String("$ \(thisGoal.goalAchievedAmount!) / \(thisGoal.goalTotalAmount!) ")
            default:
                cell.goalAmount.text = String("\(currencyCodeString!) \(thisGoal.goalAchievedAmount!) / \(thisGoal.goalTotalAmount!) ")
            break
        }
        
        cell.goalStatusIndicator.image = UIImage(named: thisGoal.goalStatus)
        cell.progressBar.setProgress(thisGoal.progressBar! as! Float, animated: true)
        cell.goalPercentage.text = String("\(thisGoal.goalPercentage!) %")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: VCIdentifierManager.goalDetailKey) as! GoalExpandVC
        vc.indexPathRow = indexPath.row
        self.present(vc, animated: true, completion: nil)
        
        print("did tap")
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


//MARK:- goalsCell
class goalsCell: UITableViewCell {
    
    @IBOutlet weak var goalEmoji: UILabel!
    @IBOutlet weak var goalName: UILabel!
    @IBOutlet weak var goalAmount: UILabel!
    @IBOutlet weak var goalStatusIndicator: UIImageView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var goalPercentage: UILabel!
    
}
