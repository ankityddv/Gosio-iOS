//
//  CustomFunctions.swift
//  Gosio
//
//  Created by ANKIT YADAV on 12/03/21.
//

import UIKit

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

func presentAlertWithOneButton(AlertTitle: String, Message: String, ActionBttnTitle: String) -> UIAlertController{
    
    let alertController = UIAlertController(title: AlertTitle, message: Message, preferredStyle: .alert)
    let defaultAction = UIAlertAction(title: ActionBttnTitle, style: .cancel, handler: nil)
    
    alertController.view.tintColor = UIColor(named: "AccentColor")
    
    alertController.addAction(defaultAction)
    return alertController
}
