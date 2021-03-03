//
//  DashboardVC.swift
//  Gosio
//
//  Created by ANKIT YADAV on 28/02/21.
//

import Hero
import UIKit

class DashboardVC: UIViewController, LoginViewControllerDelegate {
    
    func didFinishAuth() {
        label.text = "User identified: \(String(describing: userDefaults?.string(forKey: SignInWithAppleManager.userIdentifierKey)!))"
    }
    
    let label = UILabel()
    var userFirstName = ""
    var userEmail = ""
    
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
        reloadSum()
        initialiseAppTheme()
        initialiseCurrency()
        self.navigationController?.isNavigationBarHidden = true
        addNewGoalBttn.hero.id = HeroIDs.buttonKey
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
    
    func reloadSum(){
        
        let sum = goalArr.map({$0.goalTotalAmount}).reduce(0, +)
        
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
    
}


//MARK:- Table View
extension DashboardVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goalArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: goalsCell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifierManager.dashboardCell, for: indexPath) as! goalsCell
        cell.goalEmoji.text = goalArr[indexPath.row].emoji
        cell.goalName.text = goalArr[indexPath.row].goalName
        
        switch userDefaults?.object(forKey: userDefaultsKeyManager.currencyCodeKey) as? String {
        case nil:
            cell.goalAmount.text = String("$ \(Int(goalArr[indexPath.row].goalAchievedAmount)) / \(Int(goalArr[indexPath.row].goalTotalAmount)) ")
        default:
            cell.goalAmount.text = String("\(currencyCodeString!) \(Int(goalArr[indexPath.row].goalAchievedAmount)) / \(Int(goalArr[indexPath.row].goalTotalAmount)) ")
        break
        }
        
        cell.goalStatusIndicator.image = UIImage(named: goalArr[indexPath.row].goalStatus)
        cell.progressBar.setProgress(goalArr[indexPath.row].progressBar, animated: true)
        cell.goalPercentage.text = String("\(goalArr[indexPath.row].goalPercentage) %")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: VCIdentifierManager.goalDetailKey) as! GoalExpandVC
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
