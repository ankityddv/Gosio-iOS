//
//  DataModelsAndFunctions.swift
//  Gosio
//
//  Created by ANKIT YADAV on 12/03/21.
//

import UIKit


enum iPhoneModel {
case iPhoneX
case iPhone8
}

func currentIphone() -> iPhoneModel{
    if keyWindow!.safeAreaInsets.bottom > 0{
        return .iPhoneX
    }else{
        return .iPhone8
    }
}
