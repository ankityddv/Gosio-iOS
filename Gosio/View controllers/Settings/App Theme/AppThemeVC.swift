//
//  AppThemeVC.swift
//  Gosio
//
//  Created by ANKIT YADAV on 02/03/21.
//

import UIKit

class AppThemeVC: UITableViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    var themeOptions = ["System","Light","Dark"]

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.attributedText =  NSMutableAttributedString()
            .bold("Select\n")
            .boldBlueHighlight(" Theme ")
        subtitleLabel.text = "Dark mode is only for your phone not your soul"

    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return themeOptions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:appThemeTVCell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifierManager.appThemeCell) as! appThemeTVCell
        cell.titleLabel.text = themeOptions[indexPath.row]
        
        let checkView = UIImageView()
        checkView.frame = CGRect(x: 150, y: 20, width: 20, height: 20)
        checkView.image = UIImage(named: imageNameManager.checkMark)
        
        let noneView = UIImageView()
        noneView.frame = CGRect(x: 150, y: 20, width: 20, height: 20)
        noneView.image = UIImage(named: imageNameManager.noneMark)
        
        let index = userDefaults?.integer(forKey: userDefaultsKeyManager.themeKey)
        let selectedArr = [index]
        cell.accessoryView = selectedArr.contains(indexPath.row) ? checkView : noneView
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 150, y: 20, width: 20, height: 20)
        imageView.image = UIImage(named: imageNameManager.checkMark)
        
        switch indexPath.row {
        case 0:
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .unspecified
            }
            
            for section in 0..<self.tableView.numberOfSections{
                for row in 0..<self.tableView.numberOfRows(inSection: section){
                    let cell = self.tableView.cellForRow(at: IndexPath(row: row, section: section))
                    
                    let noneView = UIImageView()
                    noneView.frame = CGRect(x: 150, y: 20, width: 20, height: 20)
                    noneView.image = UIImage(named: imageNameManager.noneMark)
                    
                    cell?.accessoryView = noneView
                }
            }
            
            tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.accessoryView = imageView
            
            let alert = presentAlertWithOneButton(AlertTitle: "You have changed the theme to \"System\".", Message: "", ActionBttnTitle: "OK")
            self.present(alert, animated: true, completion: nil)
            
            userDefaults?.set(0, forKey: userDefaultsKeyManager.themeKey)
        case 1:
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .light
            }
            for section in 0..<self.tableView.numberOfSections{
                for row in 0..<self.tableView.numberOfRows(inSection: section){
                    let cell = self.tableView.cellForRow(at: IndexPath(row: row, section: section))
                    
                    let noneView = UIImageView()
                    noneView.frame = CGRect(x: 150, y: 20, width: 20, height: 20)
                    noneView.image = UIImage(named: imageNameManager.noneMark)
                    
                    cell?.accessoryView = noneView
                }
            }
            
            tableView.cellForRow(at: IndexPath(row: 1, section: 0))?.accessoryView = imageView
            
            let alert = presentAlertWithOneButton(AlertTitle: "You have changed the theme to \"Light\".", Message: "", ActionBttnTitle: "OK")
            self.present(alert, animated: true, completion: nil)
            
            userDefaults?.set(1, forKey: userDefaultsKeyManager.themeKey)
        case 2:
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .dark
            }
            for section in 0..<self.tableView.numberOfSections{
                for row in 0..<self.tableView.numberOfRows(inSection: section){
                    let cell = self.tableView.cellForRow(at: IndexPath(row: row, section: section))
                    
                    let noneView = UIImageView()
                    noneView.frame = CGRect(x: 150, y: 20, width: 20, height: 20)
                    noneView.image = UIImage(named: imageNameManager.noneMark)
                    
                    cell?.accessoryView = noneView
                }
            }
            
            tableView.cellForRow(at: IndexPath(row: 2, section: 0))?.accessoryView = imageView
            
            let alert = presentAlertWithOneButton(AlertTitle: "You have changed the theme to \"Dark\".", Message: "", ActionBttnTitle: "OK")
            self.present(alert, animated: true, completion: nil)
            
            userDefaults?.set(2, forKey: userDefaultsKeyManager.themeKey)
        default:
            break
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        mediumImpactHeptic()
    }
    

}


class appThemeTVCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
}
