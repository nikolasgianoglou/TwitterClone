//
//  ProfileFilterCell.swift
//  TwitterTutorial
//
//  Created by Nikolas Gianoglou Coelho on 15/04/22.
//

import UIKit

class ProfileFilterCell: UICollectionViewCell {
  //MARK: - Properties
  
  var option: ProfileFilterOptions!{
    didSet{titleLabel.text = option.description}
  }
  
  var titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = .lightGray
    label.font = UIFont.systemFont(ofSize: 14)
    label.text = "Test"
    return label
  }()
  
  override var isSelected: Bool{
    didSet{
      titleLabel.font = isSelected ? UIFont.boldSystemFont(ofSize: 16) : UIFont.systemFont(ofSize: 14)
      titleLabel.textColor = isSelected ? .twitterBlue : .lightGray
    }
  }
  
  //MARK: - Lifecycle

  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .white
    addSubview(titleLabel)
    titleLabel.center(inView: self)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
