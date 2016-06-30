//
//  DetailViewController.swift
//  Twitter
//
//  Created by Nancy Yao on 6/28/16.
//  Copyright © 2016 Nancy Yao. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var detailTweet: Tweet!
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailNameLabel: UILabel!
    @IBOutlet weak var detailUsernameLabel: UILabel!
    @IBOutlet weak var detailTimeLabel: UILabel!
    @IBOutlet weak var detailRetweetLabel: UILabel!
    @IBOutlet weak var detailLikeLabel: UILabel!
    @IBOutlet weak var detailTextLabel: UILabel!
    
    @IBOutlet weak var detailReplyButton: UIButton!
    @IBOutlet weak var detailRetweetButton: UIButton!
    @IBOutlet weak var detailLikeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = detailTweet.tweetUser {
            detailUsernameLabel.text = "@\(user.screenname!)"
            detailNameLabel.text = user.name as? String
            
            detailImageView.layer.borderWidth = 0
            detailImageView.layer.cornerRadius = detailImageView.frame.height/10
            detailImageView.clipsToBounds = true
            detailImageView.setImageWithURL(user.profileUrl!)
        }
        detailRetweetLabel.text = String(detailTweet.retweetCount)
        detailLikeLabel.text = String(detailTweet.favoritesCount)
        detailTextLabel.text = detailTweet.text as? String
        
        if let timestamp = detailTweet.timestamp {
            let currentTime = NSDate()
            let timeInSeconds = currentTime.timeIntervalSinceDate(timestamp)
            if timeInSeconds < 60 {
                detailTimeLabel.text = String(format: "%.0f", timeInSeconds) + "s"
            }
            else if timeInSeconds < 3600 {
                let timeInMinutes = round(timeInSeconds / 60)
                detailTimeLabel.text = String(format: "%.0f", timeInMinutes) + "m"
            }
            else if timeInSeconds < 86400 {
                let timeInHours = round(timeInSeconds / 3600)
                detailTimeLabel.text = String(format: "%.0f", timeInHours) + "h"
            }
            else {
                let timeInDays = round(timeInSeconds / 86400)
                detailTimeLabel.text = String(format: "%.0f", timeInDays) + "d"
            }
        }
        
        if detailTweet.retweeted == true {
            detailRetweetButton.selected = true
        } else {
            detailRetweetButton.selected = false
        }
        if detailTweet.favorited == true {
            detailLikeButton.selected = true
        } else {
            detailLikeButton.selected = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onDetailReplyButton(sender: AnyObject) {
        print("hit detail reply")
    }
    @IBAction func onDetailRetweetButton(sender: AnyObject) {
        if detailTweet.retweeted == false { //not yet retweeted
            detailRetweetButton.selected = true
            detailRetweetLabel.text = String(detailTweet.retweetCount + 1)
            TwitterClient.sharedInstance.retweet(detailTweet, success: { (tweet: Tweet) in
                print("retweet successful")
                
            }) { (error: NSError) in
                print("error: \(error.localizedDescription)")
            }
        } else {
            detailRetweetButton.selected = false
            detailRetweetLabel.text = String(detailTweet.retweetCount - 1)
            //TwitterClient.sharedInstance.unretweet()
        }
    }
    
    @IBAction func onDetailLikeButton(sender: AnyObject) {
        if detailTweet.favorited == false { //not yet favorited
            detailLikeButton.selected = true
            detailLikeLabel.text = String(detailTweet.favoritesCount + 1)
            TwitterClient.sharedInstance.favorite(detailTweet, success: { (tweet: Tweet) in
                print("favorite successful")
            }) { (error: NSError) in
                print("error: \(error.localizedDescription)")
            }
        } else {
            detailLikeButton.selected = false
            detailLikeLabel.text = String(detailTweet.favoritesCount - 1)
            TwitterClient.sharedInstance.unfavorite(detailTweet, success: { (tweet: Tweet) in
                print("unfavorite successful")
                }, failure: { (error: NSError) in
                    print("error: \(error.localizedDescription)")
            })
        }
    }
    @IBAction func onImageButton(sender: UIButton) {
        self.performSegueWithIdentifier("userSegue", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let userVC = segue.destinationViewController as? UserViewController {
            userVC.user = detailTweet.tweetUser! as User
        }
        if let replyVC = segue.destinationViewController as? ReplyViewController {
            let replyTweet = detailTweet
            let replyUser = replyTweet.tweetUser!
            replyVC.screenname = replyUser.screenname as! String
            replyVC.replyId = replyTweet.tweetID as Int!
        }
    }
    
}
