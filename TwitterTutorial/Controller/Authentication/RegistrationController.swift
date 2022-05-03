//
//  RegistrationController.swift
//  TwitterTutorial
//
//  Created by Nikolas Gianoglou Coelho on 29/03/22.
//

import Foundation
import UIKit
import Firebase
import SwiftUI

class RegistrationController: UIViewController{
  //MARK: - Properties
  private let imagePicker = UIImagePickerController()
  private var profileImage: UIImage?
  
  private let plusPhotoButtom: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: "plus_photo"), for: .normal)
    button.tintColor = .white
    button.addTarget(self, action: #selector(handleAppProfilePhoto), for: .touchUpInside)
    return button
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
  
  private lazy var fullnameContainerView: UIView = {
    let image = #imageLiteral(resourceName: "ic_mail_outline_white_2x-1")
    let view = Utilities().inputContainerView(withImage: image, textField: fullnameTextfield)
    return view
  }()
  
  private lazy var usernameContainerView: UIView = {
    let image = #imageLiteral(resourceName: "ic_lock_outline_white_2x")
    let view = Utilities().inputContainerView(withImage: image, textField: usernameTextfield)
    return view
  }()
  
  private let emailTextfield: UITextField = {
    return Utilities().textField(withPlaceHolder: "Email")
  }()
  
  private let passwordTextfield: UITextField = {
    let tf =  Utilities().textField(withPlaceHolder: "Password")
    tf.autocorrectionType = .no
    tf.isSecureTextEntry = true
    return tf
  }()
  
  private let fullnameTextfield: UITextField = {
    return Utilities().textField(withPlaceHolder: "Full Name")
  }()
  
  private let usernameTextfield: UITextField = {
    let tf =  Utilities().textField(withPlaceHolder: "UserName")
    //tf.isSecureTextEntry = true
    return tf
  }()
  
  private let alreadyHaveAccountButton: UIButton = {
    let button = Utilities().attributedButton("Already have an account?", " Log in")
    button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
    return button
  }()
  
  private let registrationButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Sign Up", for: .normal)
    button.backgroundColor = .white
    button.heightAnchor.constraint(equalToConstant: 50).isActive = true
    button.layer.cornerRadius = 5
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
    button.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
    return button
  }()
  //MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
  
  
  //MARK: - Selectors
  @objc func handleAppProfilePhoto(){
    present(imagePicker, animated: true, completion: nil)
  }
  
  @objc func handleShowLogin(){
    navigationController?.popViewController(animated: true)
  }
  
  @objc func handleRegistration(){
    guard let profileImage = profileImage else {
      print("DEBUG: Please select a profile image...")
      return
    }
    guard let email = emailTextfield.text else {return}
    guard let password = emailTextfield.text else {return}
    guard let fullname = fullnameTextfield.text else {return}
    guard let username = usernameTextfield.text?.lowercased() else {return}
    
    let credentials = AuthCredentials(email: email, password: password, fullName: fullname, username: username, profileImage: profileImage)
    
    AuthService.shared.registerUser(credentials: credentials) { (error, ref) in
      guard let window = UIApplication.shared.keyWindow?.rootViewController as? MainTabController else { return }
      //guard let tab = UIApplication.shared.keyWindow?.rootViewController as? MainTabController else { return } Jeito antigo
      window.authenticateUserAndConfigureUI()
    }
    
}
    

  //MARK: - Helpers
  
  func configureUI(){
    view.backgroundColor = .twitterBlue
    
    imagePicker.delegate = self
    imagePicker.allowsEditing = true
    
    view.addSubview(plusPhotoButtom)
    plusPhotoButtom.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
    plusPhotoButtom.setDimensions(width: 128, height: 128)
    
    let stack = UIStackView(arrangedSubviews: [emailContainerView,passwordContainerView, fullnameContainerView, usernameContainerView, registrationButton])
    stack.axis = .vertical
    stack.spacing = 20
    stack.distribution = .fillEqually
    
    view.addSubview(stack)
    stack.anchor(top: plusPhotoButtom.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 32, paddingRight: 32)
    
    view.addSubview(alreadyHaveAccountButton)
    alreadyHaveAccountButton.anchor(left: view.leftAnchor,
                                 bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                 right: view.rightAnchor,
                                 paddingLeft: 40,
                                 paddingBottom: 16,
                                 paddingRight: 40)
  }
  
}

//MARK: - UIImagePIckerDelegate

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let profileImage = info[.editedImage] as? UIImage else {return}
    self.profileImage = profileImage
    plusPhotoButtom.layer.cornerRadius = 128 / 2
    plusPhotoButtom.layer.masksToBounds = true
    plusPhotoButtom.imageView?.contentMode = .scaleAspectFill
    plusPhotoButtom.imageView?.clipsToBounds  = true
    plusPhotoButtom.layer.borderColor = UIColor.white.cgColor
    plusPhotoButtom.layer.borderWidth = 3
    
    self.plusPhotoButtom.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
    
    dismiss(animated: true, completion: nil)
  }
}
