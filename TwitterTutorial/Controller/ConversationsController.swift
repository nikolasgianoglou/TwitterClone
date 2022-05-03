//
//  ConversationsController.swift
//  TwitterTutorial
//
//  Created by Nikolas Gianoglou Coelho on 28/03/22.
//

import Foundation

import UIKit

class ConversationsController: UITabBarController {
  
  //MARK: - Properties
  
  //MARK: - Lifecycle

    override func viewDidLoad() {
      super.viewDidLoad()
      configureUI()
    }
    

    //MARK: - Helpers
  
  func configureUI(){
    view.backgroundColor = .white
    navigationItem.title = "Messages"
  }

}
