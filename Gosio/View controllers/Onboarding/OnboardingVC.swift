//
//  ViewController.swift
//  Gosio
//
//  Created by ANKIT YADAV on 27/02/21.
//

import UIKit
import liquid_swipe

class ColoredController: UIViewController {
    
    var viewColor: UIColor = .white {
        didSet {
            viewIfLoaded?.backgroundColor = viewColor
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = viewColor
    }
}

class OnboardingVC: LiquidSwipeContainerController, LiquidSwipeContainerDataSource {
    
    // Add identifiers of VCs which are to be presented.
    var viewControllers: [UIViewController] = {
        let firstPageVC = UIStoryboard(name: storyboardManager.mainKey, bundle: nil).instantiateViewController(withIdentifier: VCIdentifierManager.page1Key)
        let secondPageVC = UIStoryboard(name: storyboardManager.mainKey, bundle: nil).instantiateViewController(withIdentifier: VCIdentifierManager.page2Key)
        var controllers: [UIViewController] = [firstPageVC, secondPageVC]
        return controllers
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datasource = self
    }
    
    func numberOfControllersInLiquidSwipeContainer(_ liquidSwipeContainer: LiquidSwipeContainerController) -> Int{
        return viewControllers.count
    }
        
    func liquidSwipeContainer(_ liquidSwipeContainer: LiquidSwipeContainerController, viewControllerAtIndex index: Int) -> UIViewController {
        return viewControllers[index]
    }
        
    override var prefersStatusBarHidden: Bool{
        return true
    }


}

