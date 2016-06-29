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
            if let screenname = user.screenname as? String {
                detailUsernameLabel.text = "@\(screenname)"
            }
            detailNameLabel.text = user.name as? String
            if let imageUrl = user.profileUrl {
                if let data = NSData(contentsOfURL: imageUrl) {
                    detailImageView.image = UIImage(data: data)
                }
            }
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
    }
    @IBAction func onDetailRetweetButton(sender: AnyObject) {
        let detailRetweets = detailTweet.retweetCount + 1
        detailRetweetLabel.text = String(detailRetweets)
        detailRetweetButton.selected = true
        TwitterClient.sharedInstance.retweet(detailTweet.tweetID!, success: { (tweet: Tweet) in
            print("retweet successful")
            
        }) { (error: NSError) in
            print("error: \(error.localizedDescription)")
        }
    }
    @IBAction func onDetailLikeButton(sender: AnyObject) {
        let detailLikes = detailTweet.favoritesCount + 1
        detailLikeLabel.text = String(detailLikes)
        detailLikeButton.selected = true
        TwitterClient.sharedInstance.favorite(detailTweet.tweetID!, success: { (tweet: Tweet) in
            print("favorite successful")
        }) { (error: NSError) in
            print("error: \(error.localizedDescription)")
        }
    }

}
