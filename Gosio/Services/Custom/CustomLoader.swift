//
//  CustomLoader.swift
//  Gosio
//
//  Created by ANKIT YADAV on 11/03/21.
//

import UIKit

class CustomLoader: UIView {
    
    static let instance = CustomLoader()
    
    var viewColor: UIColor = .black
    var setAlpha: CGFloat = 0.9
    var gifName: String = ""
    
    lazy var transparentView: UIView = {
        let transparentView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        transparentView.backgroundColor = viewColor.withAlphaComponent(0)
        UIView.animate(withDuration: 0.3,
                         delay: 0, usingSpringWithDamping: 1.0,
                         initialSpringVelocity: 1.0,
                         options: .curveEaseInOut, animations: {
                            transparentView.backgroundColor = self.viewColor.withAlphaComponent(self.setAlpha)
        }, completion: nil)
        
        transparentView.isUserInteractionEnabled = true
        return transparentView
        
    }()
    
    lazy var gifImage: UIImageView = {
        var gifImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
        gifImage.loadGif(name: self.gifName)
        gifImage.contentMode = .scaleAspectFit
        gifImage.center = transparentView.center
        gifImage.isUserInteractionEnabled = false
        return gifImage
    }()
    
    func showLoaderView() {
        self.addSubview(self.transparentView)
        self.transparentView.addSubview(self.gifImage)
        self.transparentView.bringSubviewToFront(self.gifImage)
        let window = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
          window?.addSubview(transparentView)
        
    }
    
    func hideLoaderView() {
        self.transparentView.removeFromSuperview()
    }
    
   
}


func startloader(){
    CustomLoader.instance.gifName = "loader"
    CustomLoader.instance.showLoaderView()
}
func stoploader(){
    CustomLoader.instance.hideLoaderView()
}
