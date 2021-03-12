//
//  IAPCoreData.swift
//  Gosio
//
//  Created by ANKIT YADAV on 12/03/21.
//

import CoreData

// IAP CoreData
enum subscriptionType {
    case free
    case pro
    case unidentified
}

func updateIAPStatus(status: Bool) {
    
    let entity = NSEntityDescription.entity(forEntityName: coreDataIdentifierManager.IAP, in: context)
     let newEntity = NSManagedObject(entity: entity!, insertInto: context)
     
     newEntity.setValue(status, forKey: "isPro")
 
     do {
        try context.save()
     } catch {
//        print("Fucked it while saving!")
     }
    
}

func getIAPStatus() -> subscriptionType {
    
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: coreDataIdentifierManager.IAP)
    request.returnsObjectsAsFaults = false
    var boole : Bool!
    do {
        let result = try context.fetch(request)
        for data in result as! [NSManagedObject] {
            boole = (data.value(forKey: "isPro") as! Bool)
        }
    } catch {
//        print("Fucked it while fetching!")
    }
    
    if boole == true {
        return .pro
    } else if boole == false {
        return .free
    } else {
        return .unidentified
    }
    
}
