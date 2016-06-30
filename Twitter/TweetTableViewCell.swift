//
//  TweetTableViewCell.swift
//  Twitter
//
//  Created by Nancy Yao on 6/27/16.
//  Copyright © 2016 Nancy Yao. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    @IBOutlet weak var tweetUsernameLabel: UILabel!
    @IBOutlet weak var tweetTimeLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetNameLabel: UILabel!
    @IBOutlet weak var tweetImageView: UIImageView!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    var currentTweet: Tweet!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    //BUTTONS
    @IBAction func onLikeButton(sender: UIButton) {
        if currentTweet.favorited == false { //not yet favorited
            print("favoriting")
            likeButton.selected = true
            likeLabel.text = String(currentTweet.favoritesCount + 1)
            TwitterClient.sharedInstance.favorite(currentTweet, success: { (tweet: Tweet) in
                print("favorite successful")
            }) { (error: NSError) in
                print("error: \(error.localizedDescription)")
            }
        } else {
            print("unfavoriting")
            likeButton.selected = false
            likeLabel.text = String(currentTweet.favoritesCount - 1)
            currentTweet.favorited = false
            TwitterClient.sharedInstance.unfavorite(currentTweet, success: { (tweet: Tweet) in
                print("unfavorite successful")
                }, failure: { (error: NSError) in
                    print("error: \(error.localizedDescription)")
            })
            
        }
    }
    @IBAction func onRetweetButton(sender: AnyObject) {
        if currentTweet.retweeted == false { //not yet retweeted
            retweetButton.selected = true
            retweetLabel.text = String(currentTweet.retweetCount + 1)
            TwitterClient.sharedInstance.retweet(currentTweet, success: { (tweet: Tweet) in
                print("retweet successful")
            }) { (error: NSError) in
                print("error: \(error.localizedDescription)")
            }
        } else { //already retweeted
            retweetButton.selected = false
            retweetLabel.text = String(currentTweet.retweetCount - 1)
            //TwitterClient.sharedInstance.unretweet(currentTweet.tweetID)
        }
    }
    
    
}
