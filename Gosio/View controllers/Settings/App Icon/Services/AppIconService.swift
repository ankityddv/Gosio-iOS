//
//  AppIconService.swift
//  Gosio
//
//  Created by ANKIT YADAV on 02/03/21.
//

import UIKit

class AppIconService {
    
    let application = UIApplication.shared
    
    enum AppIcon: String {
        case primaryAppIcon
        case blue
    }
    
    func changeAppIcon(to appIcon: AppIcon) {
        let appIconValue: String? = appIcon == .primaryAppIcon ? nil : appIcon.rawValue
        application.setAlternateIconName(appIconValue)
    }

}
