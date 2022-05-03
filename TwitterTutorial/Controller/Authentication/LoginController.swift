//
//  LoginController.swift
//  TwitterTutorial
//
//  Created by Nikolas Gianoglou Coelho on 29/03/22.
//

import Foundation
import UIKit

class LoginController: UIViewController{
  //MARK: - Properties
  private let logoImageView: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFit
    iv.clipsToBounds = true
    iv.image = UIImage(named: "TwitterLogo")
    return iv
  }()
  
  private lazy var emailContainerView: UIView = {
    let image = #imageLiteral(resourceName: "ic_mail_outline_white_2x-1")
    let view = Utilities().inputContainerView(withImage: image, textField: emailTextfield)
    return view
  }()
  
  private lazy var passwordContainerView: UIView = {
    let image = #imageLiteral(resourceName: "ic_lock_outline_white_2x")
    let view = Utilities().inputContainerView(withImage: image, textField: passwordTextfield)
    return view
  }()
  
  private let emailTextfield: UITextField = {
    return Utilities().textField(withPlaceHolder: "Email")
  }()
  
  private let passwordTextfield: UITextField = {
    let tf =  Utilities().textField(withPlaceHolder: "Password")
    tf.isSecureTextEntry = true
    return tf
  }()
  
  private let loginButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Log in", for: .normal)
    button.backgroundColor = .white
    button.heightAnchor.constraint(equalToConstant: 50).isActive = true
    button.layer.cornerRadius = 5
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
    button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
    return button
  }()
  
  private let dontHaveAccountButton: UIButton = {
    let button = Utilities().attributedButton("Don't have an account?", " Sign Up")
    button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
    return button
  }()
  //MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
  
  
  //MARK: - Selectors
  
  @objc func handleShowSignUp(){
    let controller = RegistrationController()
    navigationController?.pushViewController(controller, animated: true)
  }
  
  @objc func handleLogin(){
    guard let email = emailTextfield.text else { return }
    guard let password  = passwordTextfield.text else { return }
    
    AuthService.shared.logUserIn(email: email, password: password) { (result, error) in
      if let error = error{
        print("DEBUG: Error logging in \(error.localizedDescription)")
        return
      }
      
      self.dismiss(animated: true, completion: nil)
      
    }
  }
  
  
  
  //MARK: - Helpers
  
  func configureUI(){
    view.backgroundColor = .twitterBlue
    navigationController?.navigationBar.barStyle = .black
    navigationController?.navigationBar.isHidden = true
    
    view.addSubview(logoImageView)
    logoImageView.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
    logoImageView.setDimensions(width: 150, height: 150)
    
    let stack = UIStackView(arrangedSubviews: [emailContainerView,passwordContainerView, loginButton])
    stack.axis = .vertical
    stack.spacing = 20
    stack.distribution = .fillEqually
    
    view.addSubview(stack)
    stack.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 16, paddingRight: 16)
    
    view.addSubview(dontHaveAccountButton)
    dontHaveAccountButton.anchor(left: view.leftAnchor,
                                 bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                 right: view.rightAnchor,
                                 paddingLeft: 40,
                                 paddingBottom: 16,
                                 paddingRight: 40)
  }
  
}


import SwiftUI
import UIViewCanvas


struct MyPreview2: PreviewProvider {
    static var previews: some View {
        ViewControllerCanvas(for: LoginController())
.previewInterfaceOrientation(.portrait)
    }
}


extension UIApplication {
    
    var keyWindow: UIWindow? {
        // Get connected scenes
        return UIApplication.shared.connectedScenes
            // Keep only active scenes, onscreen and visible to the user
            .filter { $0.activationState == .foregroundActive }
            // Keep only the first `UIWindowScene`
            .first(where: { $0 is UIWindowScene })
            // Get its associated windows
            .flatMap({ $0 as? UIWindowScene })?.windows
            // Finally, keep only the key window
            .first(where: \.isKeyWindow)
    }
    
}
