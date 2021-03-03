//
//  TermsOfUseVC.swift
//  Gosio
//
//  Created by ANKIT YADAV on 02/03/21.
//

import UIKit

class TermsOfUseVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.attributedText =  NSMutableAttributedString()
            .bold("Terms\n")
            .boldBlueHighlight(" of use ")
    }
    


}
