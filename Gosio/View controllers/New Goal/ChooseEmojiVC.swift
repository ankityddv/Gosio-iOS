//
//  ChooseEmojiVC.swift
//  Gosio
//
//  Created by ANKIT YADAV on 13/03/21.
//

import UIKit


class ChooseEmojiVC: UIViewController {

    
    var delegate: EmojiDelegate?
    var emojiDataArr: [EmojiModel] = EmojiLibrary.fetchEmoji()
    
    @IBOutlet weak var slideAssist: UIView!
    @IBOutlet weak var collectionVieww: FadingCollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUi()
//        fetchEmojis()
//        print(emojiArr)
    }
    
    
}


//MARK:- 🤡 functions()
extension ChooseEmojiVC {
    
    
    func setUpUi() {
        
        slideAssist.roundCorners(.allCorners, radius: 10)
        
    }
    
    func fetchEmojis(){

        let emojiRanges = [
//            0x1F600...0x1F64F, // Emoticons
//            0x1F300...0x1F5FF, // Misc Symbols and Pictographs
            0x1F680...0x1F6FF // Transport and Map
//            0x2600...0x26FF,   // Misc symbols
//            0x2700...0x27BF,   // Dingbats
//            0xFE00...0xFE0F,   // Variation Selectors
//            0x1F900...0x1F9FF, // Supplemental Symbols and Pictographs
//            0x1F1E6...0x1F1FF // Flags
        ]

        for range in emojiRanges {
            var array: [String] = []
            for i in range {
                if let unicodeScalar = UnicodeScalar(i){
                    array.append(String(describing: unicodeScalar))
                }
            }

//            emojiArr = array
        }
    }
    
    
}


//MARK:- 📀 Collection view data source
extension ChooseEmojiVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return emojiDataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return emojiDataArr[section].emojis.count
    
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: emojiCell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojiCell", for: indexPath) as! emojiCell
        
        let emoji = emojiDataArr[indexPath.section]
        
        cell.emojiLabel.text = emoji.emojis[indexPath.row]
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "EmojiSectionHeaderView", for: indexPath) as! EmojiSectionHeaderView
        let category = emojiDataArr[indexPath.section]
        
        sectionHeaderView.emojiCategory = category
        return sectionHeaderView
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let category = emojiDataArr[indexPath.section]
        let selectedEmoji = category.emojis[indexPath.row]
        
        if let delegate = self.delegate {
            delegate.changeValue(value: selectedEmoji)
        }
        
        dismiss(animated: true, completion: {
        
        })
        
    }
    
    
}


//MARK:- 🔋 emojiCell
class emojiCell: UICollectionViewCell {
    
    
    @IBOutlet weak var emojiLabel: UILabel!
    
    
}


class EmojiSectionHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    var emojiCategory: EmojiModel! {
        didSet {
            categoryLabel.text = emojiCategory.title
        }
    }
    
    
}
