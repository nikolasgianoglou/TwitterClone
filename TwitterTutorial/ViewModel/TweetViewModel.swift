//
//  TweetViewModel.swift
//  TwitterTutorial
//
//  Created by Nikolas Gianoglou Coelho on 12/04/22.
//

import UIKit

struct TweetViewModel{
  let tweet: Tweet
  let user: User
  
  var profileImageUrl: URL? {
    return user.profileImageUrl
  }
  
  var timestamp: String{
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
    formatter.maximumUnitCount = 1
    formatter.unitsStyle = .abbreviated
    let now = Date()
    return formatter.string(from: tweet.timestamp, to: now) ?? "0s"
  }
  
  var userNameText: String{
    return "@\(user.username)"
  }
  
  var userInfoText: NSAttributedString{
    let title = NSMutableAttributedString(string: user.fullname,
                                          attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
    
    title.append(NSAttributedString(string: " @\(user.username)", attributes: [.font: UIFont.boldSystemFont(ofSize: 14),
                                                                               .foregroundColor: UIColor.lightGray]))
    
    title.append(NSAttributedString(string: " ・ \(timestamp)", attributes: [.font: UIFont.boldSystemFont(ofSize: 14),
                                                                               .foregroundColor: UIColor.lightGray]))
    return title
  }
  
  init(tweet: Tweet){
    self.tweet = tweet
    self.user = tweet.user
  }
  
  
  
}
