//
//  CoreDataServices.swift
//  Gosio
//
//  Created by ANKIT YADAV on 05/03/21.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext

struct coreDataIdentifierManager {
    
    static let goalKey = "Goal"
    
}
