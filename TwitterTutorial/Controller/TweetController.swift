//
//  TweetController.swift
//  TwitterTutorial
//
//  Created by Nikolas Gianoglou Coelho on 30/04/22.
//

import UIKit

private let reuseIdentifier = "TweetCell"
private let headerIdentifier = "TweetHeader"

class TweetController: UICollectionViewController{
  //MARK: - Properties
  
  private let tweet: Tweet
  

  
  
  //MARK: - Lifecycle
  
  init(tweet: Tweet){
    self.tweet = tweet
    super.init(collectionViewLayout: UICollectionViewFlowLayout())
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureCollectionView()
    
    print("DEBUG: Tweet caption is \(tweet.caption)")
  }
  
  func configureCollectionView(){
    collectionView.backgroundColor = .white
    
    collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    collectionView.register(TweetHeader.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: headerIdentifier)
  }
}

  //MARK: - UICollectionViewDataSource
extension TweetController{
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 3
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
    
    return cell
  }
}

//MARK: - UICollectionViewDelegate
///realated with the header
extension TweetController{
  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! TweetHeader
    header.tweet = tweet
    return header
  }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension TweetController: UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return CGSize(width: view.frame.width, height: 250)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.frame.width, height: 110)
  }
}
