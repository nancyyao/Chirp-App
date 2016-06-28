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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    @IBAction func onLikeButton(sender: AnyObject) {
        likeButton.selected = true
        TwitterClient.sharedInstance.favorite(currentTweet.tweetID!, success: { (tweet: Tweet) in
            print("favorite successful")
        }) { (error: NSError) in
                print("error: \(error.localizedDescription)")
        }
    }
    @IBAction func onRetweetButton(sender: AnyObject) {
        retweetButton.selected = true
        TwitterClient.sharedInstance.retweet(currentTweet.tweetID!, success: { (tweet: Tweet) in
            print("retweet successful")
        }) { (error: NSError) in
                print("error: \(error.localizedDescription)")
        }
    }
    
    @IBAction func onReplyButton(sender: AnyObject) {
    }

}
