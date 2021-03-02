//
//  CheatSheet.swift
//  Gosio
//
//  Created by ANKIT YADAV on 28/02/21.
//

import UIKit
import Foundation


//MARK:- Screen sizes
let window = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first

let screenSize = UIScreen.main.bounds
let screenWidth = screenSize.width
let screenHeight = screenSize.height

//MARK:- Heptic Generators
let generator = UINotificationFeedbackGenerator()
func warningHeptic(){
    generator.notificationOccurred(.warning)
}
func successHeptic() {
    generator.notificationOccurred(.success)
}
func errorHeptic() {
    generator.notificationOccurred(.error)
}
func lightImpactHeptic(){
    let generator = UIImpactFeedbackGenerator(style: .light)
    generator.impactOccurred()
}
func mediumImpactHeptic(){
    let generator = UIImpactFeedbackGenerator(style: .medium)
    generator.impactOccurred()
}
func heavyImpactHeptic(){
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    generator.impactOccurred()
}
func selectionChangedHeptic(){
    let generator = UISelectionFeedbackGenerator()
    generator.selectionChanged()
}

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}


func arrayToData(stringArray: [goalModel]) -> Data? {
  return try? JSONSerialization.data(withJSONObject: stringArray, options: [])
}

func dataToStringArray(data: Data) -> [goalModel]? {
  return (try? JSONSerialization.jsonObject(with: data, options: [])) as? [goalModel]
}


func openApp(userName: String, appName: String){
    let appURL = NSURL(string: "\(appName)://user?screen_name=\(userName)")!
    let webURL = NSURL(string: "https://\(appName).com/\(userName)")!

    let application = UIApplication.shared

    if application.canOpenURL(appURL as URL) {
        application.open(appURL as URL)
    } else {
        application.open(webURL as URL)
    }
}
