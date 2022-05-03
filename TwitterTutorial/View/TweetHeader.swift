//
//  TweetHeader.swift
//  TwitterTutorial
//
//  Created by Nikolas Gianoglou Coelho on 30/04/22.
//

import UIKit
//this is the view for the header of TweetController

class TweetHeader: UICollectionReusableView{
  //MARK: - Properties
  
  //MARK: - Lifecycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = .systemPurple
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
