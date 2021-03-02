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


