//
//  EmojiDataModel.swift
//  Gosio
//
//  Created by ANKIT YADAV on 13/03/21.
//

import Foundation

struct EmojiModel {
    
    var title : String
    var emojis : [String]
    
}

struct emojiCategoryManager {
  
    static let smileandpeople = "Smily & people"
    static let animalsandnature = "Animals & nature"
    static let foodanddrink = "Food & drink"
    static let objects = "Objects"
    static let flags = "Flags"
    static let symbols = "Symbols"
    static let travelandplaces = "Travel & places"
    static let activity = "Activity"
    
}

class EmojiLibrary {
    
    class func fetchEmoji() -> [EmojiModel] {
        var categories = [EmojiModel]()
        var emojiData = EmojiLibrary.getEmoji()
        
        for (categoryTtile, dict) in emojiData {
            if let dict = dict as? [String: Any] {
                let categoryName = dict["title"] as? String
                if let emojis = dict["emojis"] as? [String] {
                    let newCategory = EmojiModel(title: categoryName!, emojis: emojis)
                    
                    categories.append(newCategory)
                }
            }
        }
        
        return categories
    }
    
    class func getEmoji() -> [String : Any] {
        
        return [emojiCategoryManager.smileandpeople :
                    ["title" : emojiCategoryManager.smileandpeople,
                     "emojis" : EmojiLibrary.generateEmoji(category: emojiCategoryManager.smileandpeople)],
        
                emojiCategoryManager.animalsandnature :
                            ["title" : emojiCategoryManager.animalsandnature,
                             "emojis" : EmojiLibrary.generateEmoji(category: emojiCategoryManager.animalsandnature)],
                
                emojiCategoryManager.foodanddrink :
                            ["title" : emojiCategoryManager.foodanddrink,
                             "emojis" : EmojiLibrary.generateEmoji(category: emojiCategoryManager.foodanddrink)],
                
                emojiCategoryManager.objects :
                            ["title" : emojiCategoryManager.objects,
                             "emojis" : EmojiLibrary.generateEmoji(category: emojiCategoryManager.objects)],
                
                emojiCategoryManager.flags :
                            ["title" : emojiCategoryManager.flags,
                             "emojis" : EmojiLibrary.generateEmoji(category: emojiCategoryManager.flags)],
                
                emojiCategoryManager.symbols :
                            ["title" : emojiCategoryManager.symbols,
                             "emojis" : EmojiLibrary.generateEmoji(category: emojiCategoryManager.symbols)],
                
                emojiCategoryManager.travelandplaces :
                            ["title" : emojiCategoryManager.travelandplaces,
                             "emojis" : EmojiLibrary.generateEmoji(category: emojiCategoryManager.travelandplaces)],
                
                emojiCategoryManager.activity :
                            ["title" : emojiCategoryManager.activity,
                             "emojis" : EmojiLibrary.generateEmoji(category: emojiCategoryManager.activity)]
                
        
        ]
        
    }
    
    private class func generateEmoji(category: String) ->[String] {
        
        
        var emojis = [String]()
        
        switch category {
        case emojiCategoryManager.smileandpeople:
            emojis = smilyAndPeople
        case emojiCategoryManager.animalsandnature:
            emojis = animalsAndNature
        case emojiCategoryManager.foodanddrink:
            emojis = foodAndDrink
        case emojiCategoryManager.objects:
            emojis = objects
        case emojiCategoryManager.flags:
            emojis = flags
        case emojiCategoryManager.symbols:
            emojis = symbols
        case emojiCategoryManager.travelandplaces:
            emojis = travelAndPlaces
        case emojiCategoryManager.activity:
            emojis = activity
        default:
            emojis = allEmojis
        }
        return emojis
        
        
    }
    
}
