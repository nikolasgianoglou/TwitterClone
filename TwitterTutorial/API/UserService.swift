//
//  UserService.swift
//  TwitterTutorial
//
//  Created by Nikolas Gianoglou Coelho on 10/04/22.
//

import Foundation
import Firebase


typealias DatabaseCompletion = ((Error?, DatabaseReference) -> Void)
struct UserService{
  static let shared = UserService()
  func fetchUser(uid: String, completion: @escaping(User) -> Void){
    //guard let uid = Auth.auth().currentUser?.uid else { return }
    REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
    guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
    guard let username = dictionary["username"] as? String else {return}
    let user = User(uid: uid, dictionary: dictionary)
      completion(user)
    }
  }
  
  func fetchUsers(completion: @escaping([User]) -> Void){
    var users = [User]()
    REF_USERS.observe(.childAdded){snapshot in
      let uid = snapshot.key
      guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
      let user = User(uid: uid, dictionary: dictionary)
      users.append(user)
      //print("DEBUG: - USER is \(user.username)")
      completion(users)
    }
  }
  
  func followUser(uid: String, completion: @escaping(DatabaseCompletion)){
    guard let currentUid = Auth.auth().currentUser?.uid else { return }
    
    REF_USER_FOLLOWING.child(currentUid).updateChildValues([uid: 1]) { (err, ref) in
      REF_USER_FOLLOWERS.child(uid).updateChildValues([currentUid: 1], withCompletionBlock: completion)
    }
  }
  
  func unfollowUser(uid: String, completion: @escaping(DatabaseCompletion)){
    guard let currentUid = Auth.auth().currentUser?.uid else { return }
    REF_USER_FOLLOWING.child(currentUid).child(uid).removeValue { (err, ref) in
      REF_USER_FOLLOWERS.child(uid).child(currentUid).removeValue(completionBlock: completion)
    }
  }
  
  func checkIfUserIsFollowed(uid: String, completion: @escaping(Bool) -> Void){
    guard let currentUid = Auth.auth().currentUser?.uid else { return }
    
    REF_USER_FOLLOWING.child(currentUid).child(uid).observeSingleEvent(of: .value) { snapshot in
      completion(snapshot.exists())
    }
  }
  
  func fetchUserStatus(uid: String, completion: @escaping(UserRelationStats) -> Void){
    REF_USER_FOLLOWERS.child(uid).observeSingleEvent(of: .value) { snapshot in
      let followers = snapshot.children.allObjects.count
      
      REF_USER_FOLLOWING.child(uid).observeSingleEvent(of: .value) { snapshot in
        let following = snapshot.children.allObjects.count
        
        let stats = UserRelationStats(followers: followers, following: following)
        completion(stats)
      }
    }
  }
}
