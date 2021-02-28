//
//  ViewController.swift
//  Gosio
//
//  Created by ANKIT YADAV on 27/02/21.
//

import UIKit

class OnboardingVC: UIViewController {

    @IBAction func continueBttnDidTap(_ sender: Any) {
        userDefaults?.set(0, forKey: "onboardingState")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


}

