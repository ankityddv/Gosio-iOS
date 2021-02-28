//
//  DashboardVC.swift
//  Gosio
//
//  Created by ANKIT YADAV on 28/02/21.
//

import UIKit

class DashboardVC: UIViewController, LoginViewControllerDelegate {
    
    func didFinishAuth() {
        label.text = "User identified: \(String(describing: userDefaults?.string(forKey: SignInWithAppleManager.userIdentifierKey)!))"
    }
    

    @IBAction func showMenu(_ sender: Any) {
        let slideVC = OverlayView()
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        self.present(slideVC, animated: true, completion: nil)
    }
    let label = UILabel()
    var userFirstName = ""
    var userEmail = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let userFirstNameSTr = (userDefaults?.string(forKey: SignInWithAppleManager.userFirstNameKey)!)!
//        let userEmailSTr = (userDefaults?.string(forKey: SignInWithAppleManager.userEmailKey)!)!
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        validateTheme()
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
            let OnboardingVC = storyboard?.instantiateViewController(withIdentifier: "OnboardingVC") as! OnboardingVC
            self.present(OnboardingVC, animated: true, completion: nil)
            break
//            userDefaults?.set(0, forKey: "onboardingState")
        }
    }
    
    func vaidateAuth() {
        SignInWithAppleManager.checkUserAuth{ (authState) in
            switch authState {
            case .undefined:
                let LoginVC = self.storyboard?.instantiateViewController(identifier: "LoginVC") as! LoginVC
                LoginVC.delegate = self
                self.present(LoginVC, animated: true, completion: nil)
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
