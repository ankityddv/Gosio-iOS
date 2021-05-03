//
//  MoreAppsbyAnkitYadavVC.swift
//  Gosio
//
//  Created by ANKIT YADAV on 06/03/21.
//

import UIKit


class MoreAppsbyAnkitYadavVC: UITableViewController {

    
    var appNameArr = ["Dinero"]
    var appSubtitleNameArr = ["Subscription manager & tracker"]
    var appIconArr = ["dinero"]
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUi()
    }
    
    
    // MARK: - 📀 Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appNameArr.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:OurAppsCell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifierManager.ourAppsCell) as! OurAppsCell
        cell.appName.text = appNameArr[indexPath.row]
        cell.appSubtitle.text = appSubtitleNameArr[indexPath.row]
        cell.appImage.image = UIImage(named: appIconArr[indexPath.row])
        cell.getAppButton.addTarget(self, action: #selector(buttonInCellDidTap(sender:)), for: .touchUpInside)
        cell.getAppButton.tag = indexPath.row
        
        ///check if app is installed or not
        if (UIApplication.shared.canOpenURL(URL(string: "Dinero://app")!)) {
            cell.getAppButton.layer.backgroundColor = UIColor.darkGray.cgColor
            cell.getAppButton.setTitle("Open", for: .normal)
        }
        return cell
    }
    @objc func buttonInCellDidTap(sender: UIButton) {
        let buttonTag = sender.tag
        if buttonTag == 0 {
            openMyApp("Dinero")
        }
    }
}

//MARK:- 🤡 functions()
extension MoreAppsbyAnkitYadavVC {
    
    
    func setUpUi(){
        titleLabel.attributedText =  NSMutableAttributedString()
            .bold("More Apps\n")
            .bold("by ")
            .boldBlueHighlight("Ankit Yadav")
        subtitleLabel.text = "Self promotion is also important :)"
    }
    func openMyApp(_ appName: String) {
        
        let appScheme = "\(appName)://app"
        let appUrl = URL(string: appScheme)

        if UIApplication.shared.canOpenURL(appUrl! as URL) {
            UIApplication.shared.open(appUrl!)
//            print("App found")
        } else {
//            print("App not installed")
            if let url = URL(string: "https://apps.apple.com/us/app/gosio/id1555987291") {
                UIApplication.shared.open(url)
            }
        }
    }
    
}


//MARK:- 🔋 moreappsCell
class OurAppsCell: UITableViewCell {
    
    
    @IBOutlet weak var appImage: UIImageView!
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var appSubtitle: UILabel!
    @IBOutlet weak var getAppButton: UIButton!
    
    
    //MARK:- Events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animate(isHighlighted: true)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animate(isHighlighted: false)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animate(isHighlighted: false)
    }

    //MARK:- Private functions
    private func animate(isHighlighted: Bool, completion: ((Bool) -> Void)?=nil) {
        let animationOptions: UIView.AnimationOptions = [.allowUserInteraction]
        if isHighlighted {
            UIView.animate(withDuration: 0.5,
                            delay: 0,
                            usingSpringWithDamping: 1,
                            initialSpringVelocity: 0,
                            options: animationOptions, animations: {
                            self.transform = .init(scaleX: 0.96, y: 0.96)
            }, completion: completion)
        } else {
            UIView.animate(withDuration: 0.5,
                            delay: 0,
                            usingSpringWithDamping: 1,
                            initialSpringVelocity: 0,
                            options: animationOptions, animations: {
                            self.transform = .identity
            }, completion: completion)
        }
    }
}
