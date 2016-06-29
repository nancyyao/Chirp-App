//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Nancy Yao on 6/28/16.
//  Copyright © 2016 Nancy Yao. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var profileHeaderImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileUsernameLabel: UILabel!
    @IBOutlet weak var profileTaglineLabel: UILabel!
    
    @IBOutlet weak var profileTweetsLabel: UILabel!
    @IBOutlet weak var profileFollowingLabel: UILabel!
    @IBOutlet weak var profileFollowersLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    var profileTweets: [Tweet]!
    let user = User.currentUser! as User
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        
        profileNameLabel.text = user.name as? String
        profileUsernameLabel.text = "@\(user.screenname!)"
        profileImageView.setImageWithURL(user.profileUrl!)
        profileTweetsLabel.text = numberFormatter.stringFromNumber(user.tweetsCount)
        profileFollowingLabel.text = numberFormatter.stringFromNumber(user.following)
        profileFollowersLabel.text = numberFormatter.stringFromNumber(user.followers)
        profileTaglineLabel.text = user.tagline as? String
        if let bannerUrl = user.bannerImageUrl {
           profileHeaderImageView.setImageWithURL(bannerUrl)
        }
        
        loadProfileTimeline()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
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
        profileNameLabel.text = user.name as? String
        profileUsernameLabel.text = "@\(user.screenname!)"
        profileImageView.setImageWithURL(user.profileUrl!)

        cell.profileTimelineImageView.image = profileImageView.image
        cell.profileTimelineNameLabel.text = profileNameLabel.text
        cell.profileTimelineUsernameLabel.text = profileUsernameLabel.text
        
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
