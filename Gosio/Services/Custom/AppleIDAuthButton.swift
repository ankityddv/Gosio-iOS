//
//  AppleIDAuthButton.swift
//  Gosio
//
//  Created by ANKIT YADAV on 11/03/21.
//

import UIKit
import AuthenticationServices

@IBDesignable
class AppleIDAuthButton: UIButton {
    
    private var authorizationButton: ASAuthorizationAppleIDButton!
    
    @IBInspectable
    var cornerRadius: CGFloat = 6.0
    @IBInspectable
    var authButtonStyle: Int = ASAuthorizationAppleIDButton.Style.black.rawValue
    
    override public init(frame: CGRect) {
       super.init(frame: frame)
    }
       
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override public func draw(_ rect: CGRect) {
        super.draw(rect)

        // Create ASAuthorizationAppleIDButton
        authorizationButton = ASAuthorizationAppleIDButton(authorizationButtonType: .default, authorizationButtonStyle: .black)
        authorizationButton.cornerRadius = cornerRadius
        let style = ASAuthorizationAppleIDButton.Style.init(rawValue: authButtonStyle) ?? .black
        authorizationButton = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn,
                                                           authorizationButtonStyle: style)
        
        authorizationButton.addTarget(self, action: #selector(didTapAppleButton), for: .touchUpInside)

        // Show authorizationButton
        addSubview(authorizationButton)

        // Use auto layout to make authorizationButton follow the MyAuthorizationAppleIDButton's dimension
        authorizationButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            authorizationButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0),
            authorizationButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0),
            authorizationButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0.0),
            authorizationButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0),
        ])
    }
    
    @objc
    func didTapAppleButton(_sender: Any) {
        sendActions(for: .touchUpInside)
        print("DidTap")
    }
    
    
}

extension AppleIDAuthButton {
    
    
    @available(iOS 13.0, *)
    public enum Style: Int {
        case white
        case whiteOutline
        case black
    }
    
    
}
