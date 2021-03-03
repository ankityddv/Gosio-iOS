//
//  PrivacyPolicyVC.swift
//  Gosio
//
//  Created by ANKIT YADAV on 02/03/21.
//

import UIKit

class PrivacyPolicyVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.attributedText =  NSMutableAttributedString()
            .bold("Privacy\n")
            .boldBlueHighlight(" Policy ")
    }
    
}
