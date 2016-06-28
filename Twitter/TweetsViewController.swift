//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Nancy Yao on 6/27/16.
//  Copyright © 2016 Nancy Yao. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet]!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
            
        }) { (error: NSError) in
            print("error: \(error.localizedDescription)")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogOut(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            return tweets.count
        } else {
            return 0
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetTableViewCell", forIndexPath: indexPath) as! TweetTableViewCell
        let tweet = tweets[indexPath.row]
        if let user = tweet.tweetUser {
            if let screenname = user.screenname as? String {
                cell.tweetUsernameLabel.text = "@\(screenname)"
            }
            cell.tweetNameLabel.text = user.name as? String
            if let imageUrl = user.profileUrl {
                if let data = NSData(contentsOfURL: imageUrl) {
                    cell.tweetImageView.image = UIImage(data: data)
                }
            }
        }
        cell.tweetTextLabel.text = tweet.text as? String
        if let timestamp = tweet.timestamp {
            let currentTime = NSDate()
            let timeElapsed = currentTime.timeIntervalSinceDate(timestamp)
            //            cell.tweetTimeLabel.text =
            print(timeElapsed)
        }
        return cell
    }
    
    
    
    
    
    
}