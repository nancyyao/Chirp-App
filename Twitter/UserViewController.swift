//
//  UserViewController.swift
//  Twitter
//
//  Created by Nancy Yao on 6/28/16.
//  Copyright © 2016 Nancy Yao. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var userTweets: [Tweet]?
    var user: User!
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userHeaderImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userUsernameLabel: UILabel!
    @IBOutlet weak var userTaglineLabel: UILabel!

    @IBOutlet weak var userTweetsLabel: UILabel!
    @IBOutlet weak var userFollowingLabel: UILabel!
    @IBOutlet weak var userFollowersLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension

        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        
        userNameLabel.text = user.name as? String
        userUsernameLabel.text = "@\(user.screenname!)"
        userImageView.setImageWithURL(user.profileUrl!)
        userTweetsLabel.text = numberFormatter.stringFromNumber(user.tweetsCount)
        userFollowingLabel.text = numberFormatter.stringFromNumber(user.following)
        userFollowersLabel.text = numberFormatter.stringFromNumber(user.followers)
        userTaglineLabel.text = user.tagline as? String
        if let bannerUrl = user.bannerImageUrl {
            userHeaderImageView.setImageWithURL(bannerUrl)
        }
        
        loadUserTimeline()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //LOAD DATA
    func loadUserTimeline() {
        TwitterClient.sharedInstance.userTimeline(user.screenname! as String, success: { (tweets: [Tweet]) in
            self.userTweets = tweets
            self.tableView.reloadData()
            print("loaded user timeline")
        }) { (error: NSError) in
                print("error: \(error.localizedDescription)")
        }
    }
    
    //REFRESH
    func refreshControlAction(refreshControl: UIRefreshControl) {
        loadUserTimeline()
        refreshControl.endRefreshing()
    }
    
    //TABLEVIEW
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let userTweets = userTweets {
            return userTweets.count
        } else {
            return 0
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell") as! UserTableViewCell
        let userTweet = userTweets![indexPath.row]

        cell.userTimelineNameLabel.text = userNameLabel.text
        cell.userTimelineUsernameLabel.text = userUsernameLabel.text
        cell.userTimelineImageView.image = userImageView.image
        
        cell.userTimelineTextLabel.text = userTweet.text as? String
        cell.userTimelineRetweetLabel.text = String(userTweet.retweetCount)
        cell.userTimelineLikeLabel.text = String(userTweet.favoritesCount)
        
        if userTweet.retweeted == true {
            cell.userTimelineRetweetButton.selected = true
        } else {
            cell.userTimelineRetweetButton.selected = false
        }
        if userTweet.favorited == true {
            cell.userTimelineLikeButton.selected = true
        } else {
            cell.userTimelineLikeButton.selected = false
        }
        
        if let timestamp = userTweet.timestamp {
            let currentTime = NSDate()
            let timeInSeconds = currentTime.timeIntervalSinceDate(timestamp)
            if timeInSeconds < 60 {
                cell.userTimelineTimeLabel.text = String(format: "%.0f", timeInSeconds) + "s"
            }
            else if timeInSeconds < 3600 {
                let timeInMinutes = round(timeInSeconds / 60)
                cell.userTimelineTimeLabel.text = String(format: "%.0f", timeInMinutes) + "m"
            }
            else if timeInSeconds < 86400 {
                let timeInHours = round(timeInSeconds / 3600)
                cell.userTimelineTimeLabel.text = String(format: "%.0f", timeInHours) + "h"
            }
            else {
                let timeInDays = round(timeInSeconds / 86400)
                cell.userTimelineTimeLabel.text = String(format: "%.0f", timeInDays) + "d"
            }
        }
        return cell
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let replyVC = segue.destinationViewController as? ReplyViewController {
            let button = sender as! UIButton
            let view = button.superview!
            let buttonCell = view.superview as! UITableViewCell
            let indexPath = tableView.indexPathForCell(buttonCell)
            
            let replyTweet = userTweets![indexPath!.row] as Tweet
            let replyUser = replyTweet.tweetUser!
            replyVC.screenname = replyUser.screenname as! String
            replyVC.replyId = replyTweet.tweetID as Int!
        }
    }

}
