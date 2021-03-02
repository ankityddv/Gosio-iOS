//
//  LastOnboardingVC.swift
//  Gosio
//
//  Created by ANKIT YADAV on 02/03/21.
//

import UIKit

class LastOnboardingVC: UIViewController {

    @IBAction func continueBttnTapped(_ sender: Any) {
        userDefaults?.set(0, forKey: "onboardingState")
        let vc = storyboard?.instantiateViewController(withIdentifier: VCIdentifierManager.loginKey) as! LoginVC
        self.present(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}
