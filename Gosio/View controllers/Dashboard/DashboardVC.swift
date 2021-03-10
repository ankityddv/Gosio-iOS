//
//  DashboardVC.swift
//  Gosio
//
//  Created by ANKIT YADAV on 28/02/21.
//

import Hero
import UIKit
import SPAlert
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
    
    
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var totalGoalAmount: UILabel!
    @IBOutlet weak var tableVieww: FadingTableView!
    @IBOutlet weak var addNewGoalBttn: UIButton!
    @IBOutlet weak var menuBttn: UIButton!
    @IBOutlet weak var totalAmountSavedStaticLabel: UILabel!
    
    
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
        
    //        let vc = self.storyboard?.instantiateViewController(withIdentifier: VCIdentifierManager.settingsKey) as! SettingsVC
    //        let navigationController = UINavigationController(rootViewController: vc)
    //        navigationController.modalPresentationStyle = .automatic
    //        self.present(navigationController, animated: true, completion: nil)
    }
    @objc func showMenuPopUp(){
        let slideVC = MenuView()
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        self.present(slideVC, animated: true, completion: nil)
    }
    @IBAction func addNewGoalDidTap(_ sender: Any) {
        addNewGoal()
    }
    @objc func addNewGoal(){
        
        switch validateSubscription() {
        case .pro:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: VCIdentifierManager.goalNameKey) as! GoalNameVC
            self.present(vc, animated: true, completion: nil)
            createUSerActivity()
        case .free:
            if nonDeletedGoals().count >=  2 {
                let vc = storyboard?.instantiateViewController(withIdentifier: VCIdentifierManager.inAppPurchasesKey) as! InAppPurchasesVC
                vc.isHeroEnabledd = false
                self.present(vc, animated: true, completion: nil)
            } else {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: VCIdentifierManager.goalNameKey) as! GoalNameVC
                self.present(vc, animated: true, completion: nil)
                createUSerActivity()
            }
        case .unidentified:
            if nonDeletedGoals().count >=  2 {
                let vc = storyboard?.instantiateViewController(withIdentifier: VCIdentifierManager.inAppPurchasesKey) as! InAppPurchasesVC
                vc.isHeroEnabledd = false
                self.present(vc, animated: true, completion: nil)
            } else {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: VCIdentifierManager.goalNameKey) as! GoalNameVC
                self.present(vc, animated: true, completion: nil)
                createUSerActivity()
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateIAPStatus(status: true)
        getIAPStatus()
        requestReview()
        fetchData()
        initialiseAppTheme()
        initialiseCurrency()
        vaildateInAppPurchases()
        self.navigationController?.isNavigationBarHidden = true
        setUpHeroAnimations()
    }
    override func viewDidAppear(_ animated: Bool) {
        vaildateOnboarding()
    }
    override func viewWillAppear(_ animated: Bool) {
        updateTotalAmount()
        tableVieww.reloadData()
    }
    
    

}


//MARK:- Table View
extension DashboardVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nonDeletedGoals().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: goalsCell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifierManager.dashboardCell, for: indexPath) as! goalsCell
        
        let thisGoal: Goal!
        thisGoal = nonDeletedGoals()[indexPath.row]
        
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
        
        let selectedGoal : Goal!
        selectedGoal = nonDeletedGoals()[indexPath.row]
        vc.selectedGoal = selectedGoal
        
        self.present(vc, animated: true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let actionSheetController: UIAlertController = UIAlertController(title: "Edit goal", message: nil, preferredStyle: .actionSheet)

            let deleteAction: UIAlertAction = UIAlertAction(title: "Delete goal", style: .destructive) { [self] action -> Void in
                
                let selectedGoal : Goal!
                selectedGoal = nonDeletedGoals()[indexPath.row]
                
                deleteGoal(selectedGoal: selectedGoal)
                
                SPAlert.present(title: "Deleted", preset: .done, haptic: .success)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                    tableView.deleteRows(at: [indexPath], with: .top)
                }
                
            }

            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }

            actionSheetController.addAction(deleteAction)
            actionSheetController.addAction(cancelAction)

            actionSheetController.view.tintColor = UIColor(named: "AccentColor")
            
            present(actionSheetController, animated: true, completion: nil)   // doesn't work for iPad

//            actionSheetController.popoverPresentationController?.sourceView = yourSourceViewName // works for both iPhone & iPad

//            present(actionSheetController, animated: true) {
//                print("option menu presented")
//            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {

        let config = UIContextMenuConfiguration(identifier: indexPath as NSCopying, previewProvider: nil) { [self] _ in
            
            let delete = UIAction(title: "Delete goal",image: UIImage(systemName: "trash"), attributes: .destructive) { [self] _ in

                let actionSheetController: UIAlertController = UIAlertController(title: "Edit goal", message: nil, preferredStyle: .actionSheet)

                let deleteAction: UIAlertAction = UIAlertAction(title: "Delete goal", style: .destructive) { [self] action -> Void in
                    
                    let selectedGoal : Goal!
                    selectedGoal = nonDeletedGoals()[indexPath.row]
                    
                    deleteGoal(selectedGoal: selectedGoal)
                    
                    SPAlert.present(title: "Deleted", preset: .done, haptic: .success)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                        tableView.deleteRows(at: [indexPath], with: .top)
                    }
                    
                }

                let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }

                actionSheetController.addAction(deleteAction)
                actionSheetController.addAction(cancelAction)

                actionSheetController.view.tintColor = UIColor(named: "AccentColor")
                
                present(actionSheetController, animated: true, completion: nil)

            }

            let menu = UIMenu(title: "", image: nil, identifier: nil, options: [], children: [delete])

            return menu

        }
        return config
        
    }
    
    @available(iOS 13.0, *)
    func tableView(_ tableView: UITableView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        
        return makeTargetedPreview(for: configuration)
    
    }

    @available(iOS 13.0, *)
    func tableView(_ tableView: UITableView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        
        return makeTargetedPreview(for: configuration)
        
    }

    @available(iOS 13.0, *)
    private func makeTargetedPreview(for configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        
        guard let indexPath = configuration.identifier as? IndexPath else { return nil }
        guard let cell = tableVieww.cellForRow(at: indexPath) as? goalsCell else {return nil}
        
        let parameters = UIPreviewParameters()
        parameters.backgroundColor = .clear
        parameters.visiblePath = UIBezierPath(roundedRect: cell.roundedBgView.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 30, height: 30))
        
        return UITargetedPreview(view: cell.roundedBgView, parameters: parameters)
        
    }
    
}


//MARK:- functions()
extension DashboardVC {
    
    
    func setUpHeroAnimations(){
        
        emojiLabel.hero.id = HeroIDs.emojiInDashboardKey
        totalGoalAmount.hero.id = HeroIDs.totalGoalAmountKey
        addNewGoalBttn.hero.id = HeroIDs.buttonKey
        menuBttn.hero.id = HeroIDs.dismissButtonKey
        totalAmountSavedStaticLabel.hero.id = HeroIDs.goalAccomplishmentDateKey
        self.hero.isEnabled = true
        
    }
    
    func vaildateOnboarding(){
        
        switch checkOnboardingState() {
        case .sendToDashboard:
//            print("sentToDashboard")
            vaidateAuth()
            break
        case .sendToOnboarding:
//            print("sentToOnboarding")
            let vc = storyboard?.instantiateViewController(withIdentifier: VCIdentifierManager.loginKey) as! LoginVC
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
                print("SignedIN")
            case .signedOut:
                print("Signed Out")
            }
        }
        
    }
    
    func vaildateInAppPurchases(){
        
        switch userDefaults?.object(forKey: userDefaultsKeyManager.inAppPurchaseKey) as? String {
        case nil:
//            print("Free and data saved")
            userDefaults?.set("none", forKey: userDefaultsKeyManager.inAppPurchaseKey)
        default:
            switch validateSubscription() {
            case .pro:
                print("Pro")
            case .free:
                print("Free")
            case .unidentified:
                print("Unidentified")
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
        
        let sum = nonDeletedGoals().map({$0.goalAchievedAmount! as! Float}).reduce(0, +)
        
        switch userDefaults?.object(forKey: userDefaultsKeyManager.currencySignKey) as? String {
        case nil:
            totalGoalAmount.text = "$ \(Int(sum))"
        default:
            totalGoalAmount.text = "\(currencyCodeString!) \(Int(sum))"
        }
        
    }
    
    func initialiseAppTheme() {
        
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
    
    func fetchData() {
        
        if (firstLoad) {
            
            firstLoad = false
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: coreDataIdentifierManager.goalKey)
            
            do {
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
    
    func nonDeletedGoals() -> [Goal] {
        var noDeleteGoalList = [Goal]()
        for goal in goal {
            if(goal.deletedDate == nil) {
                noDeleteGoalList.append(goal)
            }
        }
        return noDeleteGoalList
    }
    
    
}


//MARK:- delegate for popUp
extension DashboardVC: UIViewControllerTransitioningDelegate {
    
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
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
    @IBOutlet weak var roundedBgView: UIView!
    
    //MARK:- Events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animate(isHighlighted: true)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animate(isHighlighted: false)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animate(isHighlighted: false)
    }

    //MARK:- Private functions
    private func animate(isHighlighted: Bool, completion: ((Bool) -> Void)?=nil) {
        let animationOptions: UIView.AnimationOptions = [.allowUserInteraction]
        if isHighlighted {
            UIView.animate(withDuration: 0.5,
                            delay: 0,
                            usingSpringWithDamping: 1,
                            initialSpringVelocity: 0,
                            options: animationOptions, animations: {
                            self.transform = .init(scaleX: 0.96, y: 0.96)
            }, completion: completion)
        } else {
            UIView.animate(withDuration: 0.5,
                            delay: 0,
                            usingSpringWithDamping: 1,
                            initialSpringVelocity: 0,
                            options: animationOptions, animations: {
                            self.transform = .identity
            }, completion: completion)
        }
    }
    
    
}
