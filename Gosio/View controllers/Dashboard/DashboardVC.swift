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
    
    @IBOutlet weak var tableVieww: FadingTableView!
    @IBOutlet weak var addNewGoalBttn: UIButton!
    
    @IBAction func showMenu(_ sender: Any) {
        let slideVC = MenuView()
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        self.present(slideVC, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                print("Send to LoginVC")
            case .signedIn:
                self.userFirstName = (userDefaults?.string(forKey: SignInWithAppleManager.userFirstNameKey)!)!
                self.userEmail = (userDefaults?.string(forKey: SignInWithAppleManager.userEmailKey)!)!
                print("SignedIN")
            case .signedOut:
                print("Signed Out")
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
        cell.goalAmount.text = String("$ \(Int(goalArr[indexPath.row].goalAchievedAmount)) / \(Int(goalArr[indexPath.row].goalTotalAmount)) ")
        cell.goalStatusIndicator.image = UIImage(named: goalArr[indexPath.row].goalStatus)
        cell.progressBar.setProgress(goalArr[indexPath.row].progressBar, animated: true)
        cell.goalPercentage.text = String("\(goalArr[indexPath.row].goalPercentage) %")
        return cell
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
