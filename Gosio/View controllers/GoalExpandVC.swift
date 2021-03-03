//
//  GoalExpandVC.swift
//  Gosio
//
//  Created by ANKIT YADAV on 03/03/21.
//

import UIKit
import CoreData

class GoalExpandVC: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    var score = Int()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        scoreLabel.text = "\(score)"
        print("Score: \(score)")
    }

    @IBAction func increase(_ sender: Any) {
        score+=1
    }
    
    @IBAction func save(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Entity", in: context)
        let newEntity = NSManagedObject(entity: entity!, insertInto: context)
        
        newEntity.setValue(score, forKey: "number")
        
        do {
            try context.save()
            print("Saved")
        } catch {
            print("Fucked it while saving!")
        }
    }
    
    func getData(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                score = data.value(forKey: "number") as! Int
            }
            print("Fetched")
        } catch {
            print("Fucked it while fetching!")
        }
        
    }
    
}
