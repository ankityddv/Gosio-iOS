//
//  InAppPurchasesVC.swift
//  Gosio
//
//  Created by ANKIT YADAV on 07/03/21.
//

import Hero
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
    
    
    var isHeroEnabledd: Bool = false
    var proFeaturesArr = ["Add unlimited goals","Multiple app icons","Available for iPhone, iPad and Mac at no extra cost","Support indie developer"]
    
    
    @IBOutlet weak var bottomLegalLabel: UITextView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var dismissBttn: UIButton!
    @IBOutlet weak var gosioProPriceLabel: UILabel!
    @IBOutlet weak var illustrationImageView: UIImageView!
    @IBOutlet weak var gosioProLabel: UILabel!
    @IBOutlet weak var goProBttn: UIButton!
    
    
    @IBAction func dismissBttnDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func purchaseBttnDidTap(_ sender: Any) {
        startloader()
        IAPService.shared.purchase(product: .GosioPro)
    }
    @IBAction func restorePurchaseDidTap(_ sender: Any) {
        startloader()
        IAPService.shared.restorePurchase()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IAPService.shared.getProducts()
        setUpUi()
        setUpHeroAnimations()
        
    }
    
    
}

//MARK:- 🤡 functions()
extension InAppPurchasesVC {
    
    
    func setUpUi() {
        DispatchQueue.main.asyncAfter(deadline: .now()+3){
            
            let productInfoArr = IAPService.shared.updatePrice(product: .GosioPro)
            
            UIView.transition(with: self.gosioProPriceLabel,
                          duration: 0.5,
                          options: .transitionFlipFromTop,
                        animations: { [weak self] in
                            self!.gosioProPriceLabel.text = productInfoArr[0] + " - " + productInfoArr[1] +  productInfoArr[2]
                     }, completion: nil)
            
        }
        
//        bgView.roundCorners([.allCorners], radius: 30)
        
        bottomLegalLabel.attributedText = NSMutableAttributedString()
            .inAppPurchaseBottom("Payment will be charged to your iTunes account at confirmation of purchase. Your subscription will be valid for lifetime. You can manage your subscription by accessing your iTunes & App Store Account Settings after purchase. All personal data is handled under the terms and conditions of Gosio’s privacy policy. More details can be found here: ")
            .inAppPurchaseLinkBottom("Privacy policy", url: URL(string: urlManager.privacyPolicyUrl)!)
            .inAppPurchaseBottom(" , ")
            .inAppPurchaseLinkBottom("Terms of Use", url: URL(string: urlManager.termsOfUseUrl)!)
            .inAppPurchaseBottom(" .")
    }
    
    func setUpHeroAnimations(){
        if isHeroEnabledd {
            illustrationImageView.hero.id = HeroIDs.IAPIllustrationKey
            gosioProLabel.hero.id = HeroIDs.goProLabelKey
            goProBttn.hero.id = HeroIDs.goProBttnKey
            dismissBttn.hero.id = HeroIDs.dismissButtonKey
            bgView.hero.id = HeroIDs.goProAdBgViewKey
            self.hero.isEnabled = true
        }
    }
    
    func openSafari(url: String) {
        if let url = URL(string: url) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true

            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
    
    func priceStringForProduct(item: SKProduct) -> String? {
        let price = item.price
        if price == NSDecimalNumber(decimal: 0.00) {
            return "GET" //or whatever you like really... maybe 'Free'
        } else {
            let numberFormatter = NumberFormatter()
            let locale = item.priceLocale
            numberFormatter.numberStyle = .currency
            numberFormatter.locale = locale
            return numberFormatter.string(from: price)
        }
    }
    
    
}


// MARK: - 📀 Table view data source
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


//MARK:- 🔋 featuresCell
class GosioProFeaturesCell: UITableViewCell {
    
    
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
}
