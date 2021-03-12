//
//  UserDefaults.swift
//  Gosio
//
//  Created by ANKIT YADAV on 28/02/21.
//

import UIKit
import Foundation

let userDefaults = UserDefaults(suiteName: "group.tdc.Gosio")

var appIconInt = userDefaults?.object(forKey: userDefaultsKeyManager.appIconKey) as? Int

var reviewInteger = userDefaults?.object(forKey: userDefaultsKeyManager.requestReviewKey) as? Int


