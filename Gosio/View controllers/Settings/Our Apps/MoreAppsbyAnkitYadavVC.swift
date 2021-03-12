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
        return cell
    }
    @objc func buttonInCellDidTap(sender: UIButton) {
        let buttonTag = sender.tag
        if buttonTag == 0 {
            print("Dinero")
            if let url = URL(string: urlManager.dineroUrl) {
                UIApplication.shared.open(url)
            }
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
