//
//  AppIconVC.swift
//  Gosio
//
//  Created by ANKIT YADAV on 02/03/21.
//

import UIKit

class AppIconVC: UITableViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    let appIconService = AppIconService()
    let appIconArray = ["Default","White"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.attributedText =  NSMutableAttributedString()
            .bold("Select\n")
            .boldBlueHighlight(" App Icon ")
        subtitleLabel.text = "Multiple app icons are cool and we know that"
        
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appIconArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:appIconCell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifierManager.appIconCell) as! appIconCell
        
        cell.iconName.text = appIconArray[indexPath.row]
        cell.iconImage.image = UIImage(named: appIconArray[indexPath.row])
        
        let checkView = UIImageView()
        checkView.frame = CGRect(x: 150, y: 20, width: 20, height: 20)
        checkView.image = UIImage(named: imageNameManager.checkMark)

        let noneView = UIImageView()
        noneView.frame = CGRect(x: 150, y: 20, width: 20, height: 20)
        noneView.image = UIImage(named: imageNameManager.noneMark)

        let index = userDefaults?.integer(forKey: userDefaultsKeyManager.appIconKey)
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
            appIconService.changeAppIcon(to: .primaryAppIcon)
            
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
            
            userDefaults?.set(0, forKey: userDefaultsKeyManager.appIconKey)
            
        case 1:
            appIconService.changeAppIcon(to: .White)
            
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
            
            userDefaults?.set(1, forKey: userDefaultsKeyManager.appIconKey)
        default:
            break
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        mediumImpactHeptic()
    }

    
}

class appIconCell: UITableViewCell {
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var iconName: UILabel!
    
}
