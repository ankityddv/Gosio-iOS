//
//  ChooseEmojiVC.swift
//  Gosio
//
//  Created by ANKIT YADAV on 13/03/21.
//

import UIKit


class ChooseEmojiVC: UIViewController {

    
    var emojiArr: [String] = []
    
    
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

            emojiArr = array
        }
    }
    
    
}


//MARK:- 📀 Collection view data source
extension ChooseEmojiVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return allEmojis.count
    
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: emojiCell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojiCell", for: indexPath) as! emojiCell
        
        let emojis = allEmojis[indexPath.row]
        
        cell.emojiLabel.text = emojis
        return cell
        
    }
    
    
    
}


//MARK:- 🔋 emojiCell
class emojiCell: UICollectionViewCell {
    
    
    @IBOutlet weak var emojiLabel: UILabel!
    
    
}
