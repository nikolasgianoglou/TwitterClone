//
//  FeedController.swift
//  TwitterTutorial
//
//  Created by Nikolas Gianoglou Coelho on 28/03/22.
//

import Foundation

import UIKit
import SDWebImage

private let reuseIdentifier = "TweetCell"

class FeedController: UICollectionViewController{
  //MARK: - Properties
  
  var user: User? {
    didSet{
      configureLeftBarButton()
    }
  }
  
  private var tweets = [Tweet]() {
    didSet {
      collectionView.reloadData()
    }
  }
  
  //MARK: - Lifecycle

    override func viewDidLoad() {
      super.viewDidLoad()
      configureUI()
      fetchTweets()
    }
    
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    navigationController?.navigationBar.barStyle = .default
    navigationController?.navigationBar.isHidden = false
  }
  
  //MARK: - API
  func fetchTweets(){
    TweetService.shared.fetchTweets { tweets in
      self.tweets = tweets
    }
  }

    //MARK: - Helpers
  
  func configureUI(){
    view.backgroundColor = .white
    
    collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    
    let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
    imageView.contentMode = .scaleAspectFit
    imageView.setDimensions(width: 44, height: 44)
    navigationItem.titleView = imageView
  }
  
  func configureLeftBarButton(){
    guard let user = user else { return }
    let profileImageView = UIImageView()
    profileImageView.setDimensions(width: 32, height: 32)
    profileImageView.layer.cornerRadius = 32/2
    profileImageView.layer.masksToBounds = true //arredonda a imagem
    
    profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
  }
}

//MARK: - UICollectionViewDelegate/DataSource

extension FeedController{
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return tweets.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
    cell.delegate = self
    cell.tweet = tweets[indexPath.row]
    return cell
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let controller = TweetController(tweet: tweets[indexPath.row])
    navigationController?.pushViewController(controller, animated: true)
  }
  
}
//MARK: - UICollectionViewDelegateFlowLayout

extension FeedController: UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.frame.width, height: 110)
  }
}

//MARK: - TweetCellDelegate
extension FeedController: TweetCellDelegate{
  func handleProfileImageTapped(_ cell: TweetCell) {
    guard let user = cell.tweet?.user else { return }
    let controller = ProfileController(user: user)
    navigationController?.pushViewController(controller, animated: true)
  }

}
