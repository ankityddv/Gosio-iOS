//
//  LoginVC.swift
//  Gosio
//
//  Created by ANKIT YADAV on 28/02/21.
//

import UIKit
import AuthenticationServices
import Hero

protocol LoginViewControllerDelegate {
    func didFinishAuth()
}

class LoginVC: UIViewController {

    var delegate: LoginViewControllerDelegate?
    
    
    @IBOutlet weak var appleButtonView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var privacyPolicyLabel: UILabel!
    
    @IBAction func privacyPolicyDidTap(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: VCIdentifierManager.privacyPolicyKey) as! PrivacyPolicyVC
        self.present(vc, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUi()
    }
    

}


//MARK:- Handle Sign In
extension LoginVC: ASAuthorizationControllerDelegate {
    
    private func registerNewAccount(credential: ASAuthorizationAppleIDCredential) {
        print("Registering new account with user: \(credential.user)")
        delegate?.didFinishAuth()
        let vc = storyboard?.instantiateViewController(withIdentifier: VCIdentifierManager.dashboardKey) as! DashboardVC
        appleButtonView.hero.id = HeroIDs.buttonKey
        self.present(vc, animated: true, completion: nil)
        userDefaults?.set(0, forKey: "onboardingState")
    }
    
    private func signInWithExistingAccount(credential: ASAuthorizationAppleIDCredential) {
        print("Signing in with existing account with user: \(credential.user)")
        delegate?.didFinishAuth()
        let vc = storyboard?.instantiateViewController(withIdentifier: VCIdentifierManager.dashboardKey) as! DashboardVC
        appleButtonView.hero.id = HeroIDs.buttonKey
        self.present(vc, animated: true, completion: nil)
        userDefaults?.set(0, forKey: "onboardingState")
    }
    
    private func signInWithUserAndPassword(credential: ASAuthorizationAppleIDCredential) {
        print("Signing in using an existing icloud Keychain credential with user:: \(credential.user)")
        delegate?.didFinishAuth()
        let vc = storyboard?.instantiateViewController(withIdentifier: VCIdentifierManager.dashboardKey) as! DashboardVC
        appleButtonView.hero.id = HeroIDs.buttonKey
        self.present(vc, animated: true, completion: nil)
        userDefaults?.set(0, forKey: "onboardingState")
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential {
        case let appleIdCredentials as ASAuthorizationAppleIDCredential:
            let userId = appleIdCredentials.user
            let userFirstName = appleIdCredentials.fullName?.givenName
            let userEmail = appleIdCredentials.email
            
            userDefaults?.set(userId, forKey: SignInWithAppleManager.userIdentifierKey)
            userDefaults?.set(userFirstName, forKey: SignInWithAppleManager.userFirstNameKey)
            userDefaults?.set(userEmail, forKey: SignInWithAppleManager.userEmailKey)

            if let _ = appleIdCredentials.email, let _ = appleIdCredentials.fullName {
                registerNewAccount(credential: appleIdCredentials)
            } else {
                signInWithExistingAccount(credential: appleIdCredentials)
            }
            break
            
        case _ as ASPasswordCredential:
//            let userId = passwordCredential.user
//            userDefaults?.set(userId, forKey: SignInWithAppleManager.userIdentifierKey)
//            signInWithUserAndPassword(credential: passwordCredential)
            break
        default:
            break
        }
        
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Something bad happened")
    }
    
    
}


extension LoginVC: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
    
}


//MARK:- funtions()
extension LoginVC {
    
    func setupUi() {
        let appleButton = ASAuthorizationAppleIDButton()
        appleButton.translatesAutoresizingMaskIntoConstraints = false
        appleButton.addTarget(self, action: #selector(didTapAppleButton), for: .touchUpInside)
        appleButton.frame = CGRect(x: 0, y: 0, width: 354, height: 45)
        
        appleButtonView.addSubview(appleButton)
        NSLayoutConstraint.activate([
            appleButton.centerYAnchor.constraint(equalTo: appleButtonView.centerYAnchor),
            appleButton.leadingAnchor.constraint(equalTo: appleButtonView.leadingAnchor, constant: 30),
            appleButton.trailingAnchor.constraint(equalTo: appleButtonView.trailingAnchor, constant: -30),
            appleButton.heightAnchor.constraint(equalTo: appleButtonView.heightAnchor, multiplier: 1)
        ])
        
        self.isModalInPresentation = true
        
        titleLabel.attributedText =  NSMutableAttributedString()
            .bold("Achieving your goals is ")
            .boldBlueHighlight("easier")
            .bold(" than you think!")
        
        subtitleLabel.attributedText = NSMutableAttributedString()
            .subtitleNormal("Sign up will only take ")
            .subtitleNormalBlueHighlight("10 seconds")
        
        privacyPolicyLabel.attributedText = NSMutableAttributedString()
            .inAppPurchaseBottom("By registering you confirm that you accept our\n")
            .inAppPurchaseLinkBottom("Privacy policy", url: URL(string: urlManager.privacyPolicyUrl)!)
            .inAppPurchaseBottom(" and ")
            .inAppPurchaseLinkBottom("Terms of Use", url: URL(string: urlManager.termsOfUseUrl)!)
            .inAppPurchaseBottom(" .")
    }
    
    @objc
    func didTapAppleButton() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName,.email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        
        controller.delegate = self
        controller.presentationContextProvider = self
        
        controller.performRequests()
    }
    
}
