//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Nancy Yao on 6/28/16.
//  Copyright © 2016 Nancy Yao. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TTTAttributedLabelDelegate {
    @IBOutlet weak var profileHeaderImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    var profileTweets: [Tweet]!
    let user = User.currentUser! as User
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        loadProfileTimeline()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        // Set up header
        let nib = UINib(nibName: "UserHeader", bundle: nil)
        tableView.registerNib(nib, forHeaderFooterViewReuseIdentifier: "UserHeader")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //LOAD DATA
    func loadProfileTimeline() {
        TwitterClient.sharedInstance.userTimeline(user.screenname! as String, success: { (tweets: [Tweet]) in
            self.profileTweets = tweets
            self.tableView.reloadData()
            print("loaded profile timeline")
        }) { (error: NSError) in
            print("error: \(error.localizedDescription)")
        }
    }
    
    //REFRESH
    func refreshControlAction(refreshControl: UIRefreshControl) {
        loadProfileTimeline()
        refreshControl.endRefreshing()
    }
    
    //TABLEVIEW
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let profileTweets = profileTweets {
            return profileTweets.count
        } else {
            return 0
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ProfileCell") as! ProfileTableViewCell
        let profileTweet = profileTweets![indexPath.row]

        let linkColor = UIColor.blueColor()
        let linkActiveColor = UIColor.redColor()
        cell.profileTimelineTextLabel.delegate = self
        cell.profileTimelineTextLabel.linkAttributes = [kCTForegroundColorAttributeName : linkColor,kCTUnderlineStyleAttributeName : NSNumber(bool: true)]
        cell.profileTimelineTextLabel.activeLinkAttributes = [kCTForegroundColorAttributeName : linkActiveColor]
        cell.profileTimelineTextLabel.enabledTextCheckingTypes = NSTextCheckingType.Link.rawValue
        
        cell.profileTimelineImageView.layer.borderWidth = 0
        cell.profileTimelineImageView.layer.cornerRadius = cell.profileTimelineImageView.frame.height/10
        cell.profileTimelineImageView.clipsToBounds = true
        cell.profileTimelineImageView.setImageWithURL(user.profileUrl!)
        
        cell.profileTimelineNameLabel.text = user.name as? String
        cell.profileTimelineUsernameLabel.text = "@\(user.screenname!)"
        
        cell.profileTimelineTextLabel.text = profileTweet.text as? String
        cell.profileTimelineRetweetLabel.text = String(profileTweet.retweetCount)
        cell.profileTimelineLikeLabel.text = String(profileTweet.favoritesCount)
        
        if profileTweet.retweeted == true {
            cell.profileTimelineRetweetButton.selected = true
        } else {
            cell.profileTimelineRetweetButton.selected = false
        }
        if profileTweet.favorited == true {
            cell.profileTimelineLikeButton.selected = true
        } else {
            cell.profileTimelineLikeButton.selected = false
        }
        
        if let timestamp = profileTweet.timestamp {
            let currentTime = NSDate()
            let timeInSeconds = currentTime.timeIntervalSinceDate(timestamp)
            if timeInSeconds < 60 {
                cell.profileTimelineTimeLabel.text = String(format: "%.0f", timeInSeconds) + "s"
            }
            else if timeInSeconds < 3600 {
                let timeInMinutes = round(timeInSeconds / 60)
                cell.profileTimelineTimeLabel.text = String(format: "%.0f", timeInMinutes) + "m"
            }
            else if timeInSeconds < 86400 {
                let timeInHours = round(timeInSeconds / 3600)
                cell.profileTimelineTimeLabel.text = String(format: "%.0f", timeInHours) + "h"
            }
            else {
                let timeInDays = round(timeInSeconds / 86400)
                cell.profileTimelineTimeLabel.text = String(format: "%.0f", timeInDays) + "d"
            }
        }
        return cell
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = self.tableView.dequeueReusableHeaderFooterViewWithIdentifier("UserHeader") as! UserHeader
        let header = cell
        
        if let bannerUrl = user.bannerImageUrl {
            cell.userHeaderImageView.setImageWithURL(bannerUrl)
        }
        
        cell.userBackgroundImageView.layer.borderWidth = 0
        cell.userBackgroundImageView.layer.cornerRadius = cell.userBackgroundImageView.frame.height/10
        cell.userBackgroundImageView.clipsToBounds = true
        
        cell.userImageView.layer.borderWidth = 0
        cell.userImageView.layer.cornerRadius = cell.userImageView.frame.height/10
        cell.userImageView.clipsToBounds = true
        cell.userImageView.setImageWithURL(user.profileUrl!)
        
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        
        header.userNameLabel.text = user.name as? String
        header.userUsernameLabel.text = "@\(user.screenname!)"
        header.userImageView.setImageWithURL(user.profileUrl!)
        header.userTweetsLabel.text = numberFormatter.stringFromNumber(user.tweetsCount)
        header.userFollowingLabel.text = numberFormatter.stringFromNumber(user.following)
        header.userFollowersLabel.text = numberFormatter.stringFromNumber(user.followers)
        header.userTaglineLabel.text = user.tagline as? String
        
        return cell
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 300
    }
    
    //LINKS
    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        print("pressed link")
        UIApplication.sharedApplication().openURL(url)
    }
}
