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
    
    @IBAction func showMenu(_ sender: Any) {
        let slideVC = MenuView()
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        self.present(slideVC, animated: true, completion: nil)
    }
    
    let label = UILabel()
    var userFirstName = ""
    var userEmail = ""
    
    @IBOutlet weak var tableVieww: FadingTableView!
    @IBOutlet weak var addNewGoalBttn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        addNewGoalBttn.hero.id = HeroIDs.buttonKey
        
//        let userFirstNameSTr = (userDefaults?.string(forKey: SignInWithAppleManager.userFirstNameKey)!)!
//        let userEmailSTr = (userDefaults?.string(forKey: SignInWithAppleManager.userEmailKey)!)!
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        vaildateOnboarding()
    }

}

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
            self.present(vc, animated: true, completion: nil)
            break
//            userDefaults?.set(0, forKey: "onboardingState")
        }
    }
    
    func vaidateAuth() {
        SignInWithAppleManager.checkUserAuth{ (authState) in
            switch authState {
            case .undefined:
                let vc = self.storyboard?.instantiateViewController(identifier: VCIdentifierManager.loginKey) as! LoginVC
                vc.delegate = self
                self.present(vc, animated: true, completion: nil)
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
    
    func validateTheme(){
        UIApplication.shared.windows.forEach { window in
            window.overrideUserInterfaceStyle = .dark
        }
    }
    
}

extension DashboardVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: goalsCell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifierManager.dashboardCell, for: indexPath) as! goalsCell
        
        return cell
    }
    
    
}

class goalsCell: UITableViewCell {
    
}
