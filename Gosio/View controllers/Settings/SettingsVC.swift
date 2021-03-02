//
//  SettingsVC.swift
//  Gosio
//
//  Created by ANKIT YADAV on 02/03/21.
//

import UIKit
import SPAlert
import MessageUI

class SettingsVC: UITableViewController {

    @IBOutlet weak var versionLabel: UILabel!
    
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    let buildVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as! String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        versionLabel.text = "Version \(appVersion ?? "") (\(buildVersion))"
        tableView.separatorColor = UIColor.clear
        setUpNavBar()
    }
    
    func setUpNavBar(){
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "BgColor")
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.1
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.4, height: 0.4)
        self.navigationController?.navigationBar.layer.shadowRadius = 10
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
        switch section {
        case 0:
            return 3
        case 1:
            return 2
        case 2:
            return 3
        case 3:
            return 2
        case 4:
            return 2
        case 5:
            return 1
        default:
            return 0
        }
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
//        switch section {
//        case 0:
//            switch currentSubscription() {
//            case .Lifetime:
//                return 0
//            default:
//                return UITableView.automaticDimension
//            }
//        default:
//            return UITableView.automaticDimension
//        }
        return UITableView.automaticDimension
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                break
            case 1:
                if let bundleIdentifier = Bundle.main.bundleIdentifier, let appSettings = URL(string: UIApplication.openSettingsURLString + bundleIdentifier) {
                    if UIApplication.shared.canOpenURL(appSettings) {
                        UIApplication.shared.open(appSettings)
                    }
                }
            default:
                break
            }
        case 1:
            break
        case 2:
            switch indexPath.row {
            case 0:
                showMailComposer()
                break
            case 1:
                reviewTheApp()
                break
            case 2:
                shareWithFriends()
            default:
                break
            }
        case 3:
            switch indexPath.row {
            case 0:
                openApp(userName: "gosioapp", appName: "twitter")
            case 1:
                openApp(userName: "gosioapp", appName: "instagram")
            default:
                break
            }
        default:
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let myLabel = UILabel()
        myLabel.frame = CGRect(x: 20, y: 8, width: 320, height: 20)
        let titleStr = self.tableView(tableView, titleForHeaderInSection: section)
        myLabel.text = titleStr?.uppercased()
        myLabel.font = UIFont(name: "AirbnbCerealApp-Bold", size: 15) ?? UIFont.systemFont(ofSize: 15)
        myLabel.textColor = UIColor.init(named: "SubtitleTextColor")
        let headerView = UIView()
        headerView.addSubview(myLabel)

        return headerView
    }
}

// MARK:- All Functions
extension SettingsVC {
    
    
    func showMailComposer(){
        guard MFMailComposeViewController.canSendMail() else {
            return
        }
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["yadavankit840@gmail.com"])
        composer.setSubject("Support!")
        composer.setMessageBody("I love this app, but ", isHTML: false)
        present(composer, animated: true)
    }
    
    @objc func shareWithFriends() {
        
        //let message1 = "Download Dinero App to manage your online subscriptions."
        //let image = UIImage(named: "default")
        let myWebsite = NSURL(string: urlManager.appUrl)
        let shareAll = [myWebsite as Any] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    func reviewTheApp(){
        let url = URL(string: urlManager.appUrl)
            
        var components = URLComponents(url: url!, resolvingAgainstBaseURL: false)

        components?.queryItems = [
            URLQueryItem(name: "action", value: "write-review")
        ]
        guard let writeReviewURL = components?.url else {
            return
        }
        UIApplication.shared.open(writeReviewURL)
    }
    
}

extension SettingsVC: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let _ = error {
            controller.dismiss(animated: true)
        }
        switch result {
        case .cancelled:
            print("Cancelled")
        case .failed:
            SPAlert.present(title: "Can't send email at the moment", message: "Please try again", preset: .error, completion: nil)
        case .saved:
            SPAlert.present(title: "Saved to the draft", preset: .done)
        case .sent:
            SPAlert.present(title: "Email Sent", preset: .done)
        @unknown default:
            fatalError()
        }
        controller.dismiss(animated: true)
    }
    
}
