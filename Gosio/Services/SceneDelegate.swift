//
//  SceneDelegate.swift
//  Gosio
//
//  Created by ANKIT YADAV on 27/02/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        window?.windowScene?.sizeRestrictions?.minimumSize = CGSize(width: 1200, height: 800)
//        window?.windowScene?.sizeRestrictions?.maximumSize = CGSize(width: 1200, height: 800)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        
    }

    func sceneWillResignActive(_ scene: UIScene) {
       
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        if let _ = userActivity.interaction?.intent as? AddGoalIntent {

            if let windowScene = scene as? UIWindowScene {
                    
                self.window = UIWindow(windowScene: windowScene)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: VCIdentifierManager.dashboardKey) as! DashboardVC
                let navigationController = UINavigationController(rootViewController: initialViewController)
                navigationController.navigationBar.prefersLargeTitles = true
                self.window!.rootViewController = navigationController
                self.window!.makeKeyAndVisible()
                initialViewController.addNewGoal()
                    
            }
        } else if userActivity.activityType ==  UserActivityType.addNewGoal {
            
            if let windowScene = scene as? UIWindowScene {
                    
                self.window = UIWindow(windowScene: windowScene)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: VCIdentifierManager.dashboardKey) as! DashboardVC
                let navigationController = UINavigationController(rootViewController: initialViewController)
                navigationController.navigationBar.prefersLargeTitles = true
                self.window!.rootViewController = navigationController
                self.window!.makeKeyAndVisible()
                initialViewController.addNewGoal()
                    
            }
            
        }
    }


}

