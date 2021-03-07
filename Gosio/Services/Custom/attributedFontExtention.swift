//
//  attributedFontExtention.swift
//  Gosio
//
//  Created by ANKIT YADAV on 02/03/21.
//

import Foundation
import UIKit

extension NSMutableAttributedString {
    
    var fontSize: CGFloat { return 32 }
    var boldFont: UIFont { return UIFont(name: "AirbnbCerealApp-Bold", size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize) }
    var normalFont: UIFont { return UIFont(name: "AirbnbCerealApp-Book", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)}
    
    var subtitleBoldFont: UIFont { return UIFont(name: "AirbnbCerealApp-Bold", size: fontSize) ?? UIFont.boldSystemFont(ofSize: 17) }
    var subtitleNormalFont: UIFont { return UIFont(name: "AirbnbCerealApp-Book", size: fontSize) ?? UIFont.systemFont(ofSize: 17)}
    var inAppPurchasesBottomFont: UIFont { return UIFont(name: "AirbnbCerealApp-Book", size: 10) ?? UIFont.systemFont(ofSize: 10)}
    
    func bold(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : boldFont,
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func boldBlue(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : boldFont,
            .foregroundColor : UIColor(named: "AccentColor") as Any
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func normal(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : normalFont,
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    /* Other styling methods */
    func boldBlueHighlight(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor(named: "AccentColor") as Any
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    /* */
    
    func subtitleBold(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : subtitleBoldFont,
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func subtitleBoldBlue(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : subtitleBoldFont,
            .foregroundColor : UIColor(named: "AccentColor") as Any
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func subtitleNormal(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : subtitleNormalFont,
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    /* Other styling methods */
    func subtitleNormalBlueHighlight(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  subtitleNormalFont,
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor(named: "AccentColor") as Any
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    
    /* */
    func blackHighlight(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.black
            
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func underlined(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .underlineStyle : NSUnderlineStyle.single.rawValue
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func inAppPurchaseBottom(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : inAppPurchasesBottomFont,
            .foregroundColor : UIColor(named: "SubtitleTextColor") as Any
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func inAppPurchaseLinkBottom(_ value:String, url: URL) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : inAppPurchasesBottomFont,
            .foregroundColor : UIColor(named: "SubtitleTextColor") as Any,
            .link: url,
            .underlineStyle : NSUnderlineStyle.single.rawValue
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    
    
}

extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
