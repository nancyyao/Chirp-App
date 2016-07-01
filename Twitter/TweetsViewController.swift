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
    var count = 20
    var loadingMoreView:InfiniteScrollActivityView?
    
    var customView: UIView!
    var twitterLogo: UIImageView!
    var isAnimating = false
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        
        loadData()
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
        
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        loadCustomRefreshContents(refreshControl)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //LOAD DATA
    func loadData() {
        count = 20
        let parameters: NSDictionary = [
            "count": count
        ]
        TwitterClient.sharedInstance.homeTimeline(parameters, success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
        }) { (error: NSError) in
            print("error: \(error.localizedDescription)")
        }
    }
    
    //REFRESH
    func refreshControlAction(refreshControl: UIRefreshControl) {
        count = 20
        loadData()
        refreshControl.endRefreshing()
    }
    func loadCustomRefreshContents(refreshControl: UIRefreshControl) {
        let refreshView = NSBundle.mainBundle().loadNibNamed("TweetsRefresh", owner: self, options: nil)
        customView = refreshView[0] as! UIView
        customView.frame = refreshControl.bounds
        twitterLogo = customView.viewWithTag(1) as! UIImageView
        refreshControl.addSubview(customView)
        
    }
    func animateRefresh(refreshControl: UIRefreshControl) {
        print("animating")
        isAnimating = true
        var count = 1.0
        UIView.animateWithDuration(0.6, animations: {
            self.twitterLogo.transform = CGAffineTransformMakeRotation(CGFloat(count * M_PI))
            self.twitterLogo.transform = CGAffineTransformMakeScale(1.2, 1.2)
            }, completion: { (finished) -> Void in
                UIView.animateWithDuration(0.6, animations: {
                    count = count + 1
                    self.twitterLogo.transform = CGAffineTransformIdentity
                    if refreshControl.refreshing {
                        self.animateRefresh(refreshControl)
                    }
                    else {
                        self.isAnimating = false
                    }
                })
            })
    }
    
    //INFINITE SCROLL
    class InfiniteScrollActivityView: UIView {
        var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
        static let defaultHeight:CGFloat = 60.0
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setupActivityIndicator()
        }
        
        override init(frame aRect: CGRect) {
            super.init(frame: aRect)
            setupActivityIndicator()
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            activityIndicatorView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)
        }
        
        func setupActivityIndicator() {
            activityIndicatorView.activityIndicatorViewStyle = .Gray
            activityIndicatorView.hidesWhenStopped = true
            self.addSubview(activityIndicatorView)
        }
        
        func stopAnimating() {
            self.activityIndicatorView.stopAnimating()
            self.hidden = true
        }
        
        func startAnimating() {
            self.hidden = false
            self.activityIndicatorView.startAnimating()
        }
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                // Code to load more results
                loadMoreData()
            }
            
            if scrollView.contentOffset.y < 0 {
                print("offset negative")
                if !isAnimating {
                    print("not currently animating, running animate")
                    animateRefresh(refreshControl)
                }
            }
            
        }
    }
    func loadMoreData() {
        print("loading more data")
        count = count + 5
        print(count)
        let dictionary: NSDictionary = [
            "count": count as Int
        ]
        TwitterClient.sharedInstance.homeTimeline(dictionary, success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
            self.isMoreDataLoading = false
        }) { (error: NSError) in
            print("error: \(error.localizedDescription)")
        }
        
        self.loadingMoreView!.stopAnimating()
        self.tableView.reloadData()
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
            
            cell.tweetImageView.layer.borderWidth = 0
            cell.tweetImageView.layer.cornerRadius = cell.tweetImageView.frame.height/10
            cell.tweetImageView.clipsToBounds = true
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