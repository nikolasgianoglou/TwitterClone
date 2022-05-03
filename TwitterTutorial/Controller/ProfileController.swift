//
//  ProfileController.swift
//  TwitterTutorial
//
//  Created by Nikolas Gianoglou Coelho on 12/04/22.
//

import UIKit

private let reuseIdentifier = "Cell"
private let headerIdentifier = "ProfileHeader"

class ProfileController: UICollectionViewController {
//MARK: - Properties
  private var user: User
  
  private var tweets = [Tweet]() {
    didSet {
      collectionView.reloadData()
    }
  }
  
//MARK: - Lifecycle
  init(user: User){
    self.user = user
    super.init(collectionViewLayout: UICollectionViewFlowLayout())
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
    override func viewDidLoad() {
      super.viewDidLoad()
      configureCollectionView()
      fetchTweets()
      checkIfUserIsFollowed()
      fetchUserStatus()
    }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    navigationController?.navigationBar.barStyle = .black
    navigationController?.navigationBar.isHidden = true
  }

//MARK: - Helpers

  func configureCollectionView(){
    collectionView.backgroundColor = .white
    collectionView.contentInsetAdjustmentBehavior = .never //This is for collectionView goes all the way to the top
    collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    collectionView.register(ProfileHeader.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: headerIdentifier)
  }

  //MARK: - API

    func fetchTweets(){
      TweetService.shared.fetchTweets(forUser: user) { tweets in
        self.tweets = tweets
      }
    }
  
  func checkIfUserIsFollowed(){
    UserService.shared.checkIfUserIsFollowed(uid: user.uid) { isFollowed in
      self.user.isFollowed = isFollowed
      self.collectionView.reloadData()
    }
  }
  
  func fetchUserStatus(){
    UserService.shared.fetchUserStatus(uid: user.uid) {stats in
      self.user.stats = stats
      self.collectionView.reloadData()
    }
  }
}




//MARK: - UICollectionViewDataSource

extension ProfileController{
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return tweets.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
    cell.tweet = tweets[indexPath.row]
    return cell
  }
}

//MARK: - UICollectionViewDelegate
///realated with the header
extension ProfileController{
  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
    header.user = user
    header.delegate = self
    return header
  }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ProfileController: UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return CGSize(width: view.frame.width, height: 350)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.frame.width, height: 110)
  }
}
//MARK: - ProfileControllerDelegate
extension ProfileController: ProfileHeaderDelegate{
  func handleEditProfileFollow(_ header: ProfileHeader) {
    if user.isCurrentUser{
      return
    }
    
    if user.isFollowed{
      UserService.shared.unfollowUser(uid: user.uid) { (ref, err) in
        self.user.isFollowed = false
        self.collectionView.reloadData()
        
      }
    }else{
      UserService.shared.followUser(uid: user.uid) { (ref, err) in
        self.user.isFollowed = true
        header.editProfileFollowButton.setTitle("Following", for: .normal)
        self.collectionView.reloadData()
      }
    }
  }
  
  func handleDismissal() {
    navigationController?.popViewController(animated: true)
  }
  
  
}
