//
//  MentionsViewController.swift
//  Twitter
//
//  Created by Nancy Yao on 7/1/16.
//  Copyright © 2016 Nancy Yao. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class MentionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TTTAttributedLabelDelegate {
    @IBOutlet weak var tableView: UITableView!
    var mentions: [Tweet]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        
        loadMentions()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // REFRESH
    func refreshControlAction(refreshControl: UIRefreshControl) {
        loadMentions()
        refreshControl.endRefreshing()
    }
    
    //LOAD DATA
    func loadMentions() {
        TwitterClient.sharedInstance.mentions({ (mentions: [Tweet]) in
            print("mentions loaded")
            self.mentions = mentions
            self.tableView.reloadData()
        }) { (error: NSError) in
            print("error: \(error.localizedDescription)")
        }
    }
    
    // TABLE VIEW
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let mentions = mentions {
            return mentions.count
        } else { return 0 }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MentionCell") as! MentionsTableViewCell
        let mention = mentions[indexPath.row]
        if let user = mention.tweetUser {
            cell.mentionUsernameLabel.text = "@\(user.screenname!)"
            cell.mentionNameLabel.text = user.name as? String
            
            cell.mentionImageView.layer.borderWidth = 0
            cell.mentionImageView.layer.cornerRadius = cell.mentionImageView.frame.height/10
            cell.mentionImageView.clipsToBounds = true
            if let imageUrl = user.profileUrl {
                cell.mentionImageView.setImageWithURL(imageUrl)
            }
        }
        let linkColor = UIColor.blueColor()
        let linkActiveColor = UIColor.redColor()
        cell.mentionTextLabel.delegate = self
        cell.mentionTextLabel.linkAttributes = [kCTForegroundColorAttributeName : linkColor,kCTUnderlineStyleAttributeName : NSNumber(bool: true)]
        cell.mentionTextLabel.activeLinkAttributes = [kCTForegroundColorAttributeName : linkActiveColor]
        cell.mentionTextLabel.enabledTextCheckingTypes = NSTextCheckingType.Link.rawValue
        
        cell.mentionTextLabel.text = mention.text as? String
        cell.mentionRetweetLabel.text = String(mention.retweetCount)
        cell.mentionLikeLabel.text = String(mention.favoritesCount)

        if let timestamp = mention.timestamp {
            let currentTime = NSDate()
            let timeInSeconds = currentTime.timeIntervalSinceDate(timestamp)
            if timeInSeconds < 60 {
                cell.mentionTimeLabel.text = String(format: "%.0f", timeInSeconds) + "s"
            }
            else if timeInSeconds < 3600 {
                let timeInMinutes = round(timeInSeconds / 60)
                cell.mentionTimeLabel.text = String(format: "%.0f", timeInMinutes) + "m"
            }
            else if timeInSeconds < 86400 {
                let timeInHours = round(timeInSeconds / 3600)
                cell.mentionTimeLabel.text = String(format: "%.0f", timeInHours) + "h"
            }
            else {
                let timeInDays = round(timeInSeconds / 86400)
                cell.mentionTimeLabel.text = String(format: "%.0f", timeInDays) + "d"
            }
        }
        return cell
    }
    
    //LINKS
    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        print("pressed link")
        UIApplication.sharedApplication().openURL(url)
    }
}
