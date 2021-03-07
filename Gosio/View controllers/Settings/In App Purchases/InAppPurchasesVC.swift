//
//  InAppPurchasesVC.swift
//  Gosio
//
//  Created by ANKIT YADAV on 07/03/21.
//

import UIKit
import StoreKit
import SafariServices


protocol controlAlert {
    func presentRestored()
}

class InAppPurchasesVC: UIViewController,controlAlert {
    
    func presentRestored() {
        let alert = presentAlertWithOneButton(AlertTitle: "Restored", Message: "Quit and restart", ActionBttnTitle: "Yay")
        present(alert, animated: true, completion: nil)
    }
    
    var proFeaturesArr = ["Add unlimited goals","Multiple app icons","Available for iPhone, iPad and Mac at no extra cost","Support indie developers"]
    
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var dismissBttn: UIButton!
    
    
    @IBAction func dismissBttnDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func restorePurchaseDidTap(_ sender: Any) {
        IAPService.shared.restorePurchase()
    }
    
    @IBAction func privacyPolicyDidTap(_ sender: Any) {
        openSafari(url: urlManager.privacyPolicyUrl)
    }
    
    @IBAction func termsOfUseDidTap(_ sender: Any) {
        openSafari(url: urlManager.termsOfUseUrl)
    }
    
    @IBAction func purchaseBttnDidTap(_ sender: Any) {
        print("Comon")
        IAPService.shared.purchase(product: .GosioPro)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IAPService.shared.getProducts()
        bgView.roundCorners([.allCorners], radius: 30)
    }
    
    
}


extension InAppPurchasesVC: UITableViewDataSource,UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return proFeaturesArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GosioProFeaturesCell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifierManager.gosioProCell) as! GosioProFeaturesCell
        cell.titleLabel.text = proFeaturesArr[indexPath.row]
        return cell
    }
    
    
}


extension InAppPurchasesVC {
    
    func openSafari(url: String) {
        if let url = URL(string: url) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true

            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
    
}

class GosioProFeaturesCell: UITableViewCell {
    
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
}
