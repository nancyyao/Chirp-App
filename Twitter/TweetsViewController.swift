//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Nancy Yao on 6/27/16.
//  Copyright © 2016 Nancy Yao. All rights reserved.
//

import UIKit
import SVPullToRefresh

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet]!
    var isMoreDataLoading = false
    //    var loadingMoreView:InfiniteScrollActivityView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        
        loadData()
        
        /*
         // Set up Infinite Scroll loading indicator
         let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
         loadingMoreView = InfiniteScrollActivityView(frame: frame)
         loadingMoreView!.hidden = true
         tableView.addSubview(loadingMoreView!)
         
         var insets = tableView.contentInset;
         insets.bottom += InfiniteScrollActivityView.defaultHeight;
         tableView.contentInset = insets
         */
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
    }
    override func viewDidAppear(animated: Bool) {
        loadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //LOAD DATA
    func loadData() {
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
        }) { (error: NSError) in
            print("error: \(error.localizedDescription)")
        }
    }
    
    //INFINITE SCROLL
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isMoreDataLoading = true
                
                tableView.addInfiniteScrollingWithActionHandler({
                    self.isMoreDataLoading = false
                    
                    self.loadMoreData()
                    
                    self.tableView.infiniteScrollingView.stopAnimating()
                })
            }
        }
    }
    func loadMoreData() {
        print("loading more data")
        self.isMoreDataLoading = false
        
        loadData()
        
        self.tableView.reloadData()
    }
    
    //REFRESH
    func refreshControlAction(refreshControl: UIRefreshControl) {
        loadData()
        refreshControl.endRefreshing()
    }
    
    //LOG OUT
    @IBAction func onLogOut(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
    }
    
    //TABLE VIEW
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
            cell.tweetUsernameLabel.text = "@\(user.screenname!)"
            cell.tweetNameLabel.text = user.name as? String
            if let imageUrl = user.profileUrl {
                cell.tweetImageView.setImageWithURL(imageUrl)
            }
        }
        
        cell.currentTweet = tweet
        cell.tweetTextLabel.text = tweet.text as? String
        cell.retweetLabel.text = String(tweet.retweetCount)
        cell.likeLabel.text = String(tweet.favoritesCount)
        cell.replyButton.tag = indexPath.row
        
        if tweet.retweeted == true {
            cell.retweetButton.selected = true
        } else {
            cell.retweetButton.selected = false
        }
        if tweet.favorited == true {
            cell.likeButton.selected = true
        } else {
            cell.likeButton.selected = false
        }
        
        if let timestamp = tweet.timestamp {
            let currentTime = NSDate()
            let timeInSeconds = currentTime.timeIntervalSinceDate(timestamp)
            if timeInSeconds < 60 {
                cell.tweetTimeLabel.text = String(format: "%.0f", timeInSeconds) + "s"
            }
            else if timeInSeconds < 3600 {
                let timeInMinutes = round(timeInSeconds / 60)
                cell.tweetTimeLabel.text = String(format: "%.0f", timeInMinutes) + "m"
            }
            else if timeInSeconds < 86400 {
                let timeInHours = round(timeInSeconds / 3600)
                cell.tweetTimeLabel.text = String(format: "%.0f", timeInHours) + "h"
            }
            else {
                let timeInDays = round(timeInSeconds / 86400)
                cell.tweetTimeLabel.text = String(format: "%.0f", timeInDays) + "d"
            }
        }
        return cell
    }
    
    //PASS DATA
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let detailVC = segue.destinationViewController as? DetailViewController {
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
            detailVC.detailTweet = tweets[indexPath!.row] as Tweet
        }
        if let replyVC = segue.destinationViewController as? ReplyViewController {
            let button = sender as! UIButton
            let view = button.superview!
            let buttonCell = view.superview as! UITableViewCell
            let indexPath = tableView.indexPathForCell(buttonCell)
            
            let replyTweet = tweets[indexPath!.row] as Tweet
            let replyUser = replyTweet.tweetUser! 
            replyVC.screenname = replyUser.screenname as! String
            replyVC.replyId = replyTweet.tweetID as Int!
        }
    }
}