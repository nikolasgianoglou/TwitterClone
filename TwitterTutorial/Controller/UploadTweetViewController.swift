//
//  UploadTweetViewController.swift
//  TwitterTutorial
//
//  Created by Nikolas Gianoglou Coelho on 11/04/22.
//

import UIKit

class UploadTweetViewController: UIViewController {

  
  //MARK: - Properties
  private let user: User
  
  
  private lazy var actionButton: UIButton = {
    let button = UIButton(type: .system)
    button.backgroundColor = .twitterBlue
    button.setTitle("Tweet", for: .normal)
    button.titleLabel?.textAlignment = .center
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
    button.setTitleColor(.white, for: .normal)
    
    button.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
    button.layer.cornerRadius = 32/2
    button.addTarget(self, action: #selector(handleUploadTweet), for: .touchUpInside)
    return button
  }()
  
  private let profileImageView: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFit
    iv.clipsToBounds = true
    iv.setDimensions(width: 48, height: 48)
    iv.layer.cornerRadius = 48/2
    iv.backgroundColor = .twitterBlue
    return iv
  }()
  
  private let captionTextView = CaptionTextview()
  
  //MARK: - Lifecycle
  
  init(user: User){
    self.user = user
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
    override func viewDidLoad() {
      super.viewDidLoad()
      configureUI()
    }
  //MARK: - Selectors
  
  @objc func handleCancel(){
    dismiss(animated: true, completion: nil)
  }
  
  @objc func handleUploadTweet(){
    guard let caption = captionTextView.text else { return }
    TweetService.shared.uploadTweet(caption: caption) { (error, ref) in
      if let error = error{
        print("DEBUG: Failed to upload tweet with \(error.localizedDescription)")
        return
      }
      
      self.dismiss(animated: true, completion: nil)
    }
  }
  
  //MARK: - API
  
  //MARK: - Helpers


  func configureUI(){
    view.backgroundColor = .white
    configureNavigationBar()
    
    let stack = UIStackView(arrangedSubviews: [profileImageView,captionTextView])
    stack.axis = .horizontal
    stack.spacing = 12
    
    view.addSubview(stack)
    stack.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
      stack.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
      stack.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16)
    ])
    
    profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)
    
  }
  
  func configureNavigationBar(){
    navigationController?.navigationBar.barTintColor = .white
    //navigationController?.navigationBar.isTranslucent = false
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
  }
}
