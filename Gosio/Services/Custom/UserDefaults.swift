//
//  UserDefaults.swift
//  Gosio
//
//  Created by ANKIT YADAV on 28/02/21.
//

import UIKit
import Foundation

let userDefaults = UserDefaults(suiteName: "group.tdc.Gosio")

var currencyCodeString = userDefaults?.object(forKey: userDefaultsKeyManager.currencySignKey) as? String

var appIconInt = userDefaults?.object(forKey: userDefaultsKeyManager.appIconKey) as? Int

var reviewInteger = userDefaults?.object(forKey: userDefaultsKeyManager.requestReviewKey) as? Int

var currentSubscription = userDefaults?.object(forKey: userDefaultsKeyManager.inAppPurchaseKey) as? String

