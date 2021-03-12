//
//  CurrencyVC.swift
//  Gosio
//
//  Created by ANKIT YADAV on 02/03/21.
//

import UIKit


class CurrencyVC: UITableViewController {
    
    
    var searchedCurrency = [CurrencyModel]()
    var searching = false
    let searchController = UISearchController(searchResultsController: nil)

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appendData()
        setUpUi()
    
    }
    

    // MARK: - 📀 Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if searching {
            return searchedCurrency.count
        } else {
            return CurrencyArr.count
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CurrencyTVCell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifierManager.currencyCell) as! CurrencyTVCell
        
        let checkView = UIImageView()
        checkView.frame = CGRect(x: 150, y: 20, width: 20, height: 20)
        checkView.image = UIImage(named: imageNameManager.checkMark)
        
        let noneView = UIImageView()
        noneView.frame = CGRect(x: 150, y: 20, width: 20, height: 20)
        noneView.image = UIImage(named: imageNameManager.noneMark)
        
        if searching {
            
            let name = searchedCurrency[indexPath.row].currencyName
            let sign = searchedCurrency[indexPath.row].currencySign
            cell.currencyName.text = "\(name) (\(sign))"
            
            if searchedCurrency.contains(where: { $0.currencyCode == getDefaultCurrency().currencyCode }) {
                let index = searchedCurrency.firstIndex(where: { $0.currencyCode == getDefaultCurrency().currencyCode })
                let selectedArr = [Int("\(index!)")]
                cell.accessoryView = selectedArr.contains(indexPath.row) ? checkView : noneView
            } else {
                cell.accessoryView = noneView
            }
            
            
        } else {
            
            let name = CurrencyArr[indexPath.row].currencyName
            let sign = CurrencyArr[indexPath.row].currencySign
            cell.currencyName.text = "\(name) (\(sign))"
            
            let index = CurrencyArr.firstIndex(where: { $0.currencyCode == getDefaultCurrency().currencyCode })
            let selectedArr = [Int("\(index!)")]
            cell.accessoryView = selectedArr.contains(indexPath.row) ? checkView : noneView
            
        }
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let checkView = UIImageView()
        checkView.frame = CGRect(x: 150, y: 20, width: 20, height: 20)
        checkView.image = UIImage(named: imageNameManager.checkMark)
        
        for section in 0..<self.tableView.numberOfSections{
            for row in 0..<self.tableView.numberOfRows(inSection: section){
                let cell = self.tableView.cellForRow(at: IndexPath(row: row, section: section))
                
                let noneView = UIImageView()
                noneView.frame = CGRect(x: 150, y: 20, width: 20, height: 20)
                noneView.image = UIImage(named: imageNameManager.noneMark)
                
                cell?.accessoryView = noneView
            }
        }
        
        tableView.cellForRow(at: indexPath)?.accessoryView = checkView
        
        if searching {
            
            updateDefaultCurrency(name: "\(searchedCurrency[indexPath.row].currencyName)", countryCode: "\(searchedCurrency[indexPath.row].currencyCode)", sign: "\(searchedCurrency[indexPath.row].currencySign)")
            
            let alert = presentAlertWithOneButton(AlertTitle: "You have changed the default currency to \((searchedCurrency[indexPath.row].currencyCode)).", Message: "", ActionBttnTitle: "OK")
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            updateDefaultCurrency(name: "\(CurrencyArr[indexPath.row].currencyName)", countryCode: "\(CurrencyArr[indexPath.row].currencyCode)", sign: "\(CurrencyArr[indexPath.row].currencySign)")
            
            let alert = presentAlertWithOneButton(AlertTitle: "You have changed the default currency to \((CurrencyArr[indexPath.row].currencyCode)).", Message: "", ActionBttnTitle: "OK")
            self.present(alert, animated: true, completion: nil)
            
        }
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        lightImpactHeptic()
        
    }
    
    
}


//MARK:-  🤡 functions()
extension CurrencyVC {
    
    
    func setUpUi() {
        titleLabel.attributedText =  NSMutableAttributedString()
            .bold("Select\n")
            .boldBlueHighlight(" Currency ")
        subtitleLabel.text = "Obviously this is important"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search currency"
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true
        searchController.searchBar.delegate = self
    }
    
    func appendData(){
        for (name,code,sign) in zip(currencyName,currencyCode,currencySign) {
            CurrencyArr.append(CurrencyModel(currencyName: name, currencyCode: code, currencySign: sign))
        }
    }
    
    
}


//MARK:-  🕵🏻‍♂️ Search Bar
extension CurrencyVC: UISearchBarDelegate {
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
            let cancelButton = searchController.searchBar.value(forKey: "cancelButton") as! UIButton
            cancelButton.setTitle("Cancel", for: .normal)
    //            cancelButton.titleLabel!.font = UIFont(name: "AirbnbCerealApp-Book", size: 16.2)
        }
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchedCurrency = CurrencyArr.filter({$0.currencyName.lowercased().prefix(searchText.count) == searchText.lowercased()})
        
        searching = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchController.searchBar.text = ""
        tableView.reloadData()
    }
    
    
}


//MARK:- 🔋 currencyCell
class CurrencyTVCell: UITableViewCell {
    @IBOutlet weak var currencyName: UILabel!
}
