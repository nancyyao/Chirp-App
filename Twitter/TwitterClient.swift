//
//  TwitterClient.swift
//  Twitter
//
//  Created by Nancy Yao on 6/27/16.
//  Copyright © 2016 Nancy Yao. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com"), consumerKey: "hH9fy1stHinwLMczKmoRogPYF", consumerSecret: "cy7CkU4b5rJZKurZ1332PdxlHu0jsOuv5QHxrcCEsOJjEy0Cmq")
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    func login(success: () -> (), failure: (NSError) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance.deauthorize()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterApp://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("I got a token!")
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(url)
        }) { (error: NSError!) -> Void in
            print("error: \(error.localizedDescription)")
            self.loginFailure?(error)
        }
    } 
    func logout() {
        User.currentUser = nil
        deauthorize()
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
    func handleOpenUrl(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in
            //fetch current account to store
            self.currentAccount({ (user: User) -> () in
                User.currentUser = user
                self.loginSuccess?()
                }, failure: { (error: NSError) -> () in
                    self.loginFailure?(error)
            })
        }) { (error: NSError!) -> Void in
            self.loginFailure?(error)
        }
        
    }
    func homeTimeline(dictionary: NSDictionary, success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        self.printRateStatuses()
        
        GET("1.1/statuses/home_timeline.json", parameters: dictionary, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
            success(tweets)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    func mentions(success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        GET("1.1/statuses/mentions_timeline.json", parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            let dictionaries = response as! [NSDictionary]
            let mentions = Tweet.tweetsWithArray(dictionaries)
            success(mentions)
        }) { (task: NSURLSessionDataTask?, error: NSError) in
                print("error: \(error.localizedDescription)")
        }
    }
    
    func userTimeline(screenname: String, success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        let userDictionary: NSDictionary = [
            "screen_name": screenname
        ]
        GET("1.1/statuses/user_timeline.json", parameters: userDictionary, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
            success(tweets)
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            print("error: \(error.localizedDescription)")
        }
    }
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> ()) {
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            success(user)
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    func retweet(tweet: Tweet, success: (Tweet) -> (), failure: (NSError) -> ()) {
        POST("1.1/statuses/retweet/\(tweet.tweetID!).json", parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let dictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: dictionary)
            success(tweet)
        }) { (task: NSURLSessionDataTask?, error: NSError) -> Void in
            failure(error)
        }
    }
    func favorite(tweet: Tweet, success: (Tweet) -> (), failure: (NSError) -> ()) {
        let favoriteDictionary: NSDictionary = [
            "id": tweet.tweetID!
        ]
        POST("1.1/favorites/create.json", parameters: favoriteDictionary, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let dictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: dictionary)
            success(tweet)
        }) { (task: NSURLSessionDataTask?, error: NSError) -> Void in
            print("error: \(error.localizedDescription)")
        }
    }
    func unfavorite(tweet: Tweet, success: (Tweet) -> (), failure: (NSError) -> ()) {
        let unfavoriteDictionary: NSDictionary = [
            "id": tweet.tweetID!
        ]
        POST("1.1/favorites/destroy.json", parameters: unfavoriteDictionary, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            let dictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: dictionary)
            success(tweet)
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            print("error: \(error.localizedDescription)")
        }
    }
    
    func compose(dictionary: NSDictionary, success: (Tweet) -> (), failure: (NSError) -> ()) {
        POST("1.1/statuses/update.json", parameters: dictionary, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            let dictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: dictionary)
            success(tweet)
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            print("error: \(error.localizedDescription)")
        }
    }
    /*
     func unretweet(tweet: Tweet) {
     var originalTweetId: Int!
     var retweetId: String!
     if tweet.retweeted == false {
     print("can't unretweet a tweet that has not been retweeted")
     return
     } else {
     if tweet.retweetedStatus == nil { //this is the original tweet
     originalTweetId = tweet.tweetID
     } else { //this tweet itself is a retweet
     originalTweetId = tweet.retweetedStatus?.tweetID
     }
     }
     
     let dictionary: NSDictionary = [
     "id" : originalTweetId,
     "include_my_retweet" : true
     ]
     
     GET("1.1/statuses/show.json", parameters: dictionary, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
     print("tweet shown")
     let fullTweet = response as! Tweet
     retweetId = fullTweet.currentUserRetweet!["id_str"] as! String
     }) { (task: NSURLSessionDataTask?, error: NSError) in
     print("error: \(error.localizedDescription)")
     }
     
     POST("1.1/statuses/destroy/" + retweetId + ".json", parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
     print("retweet deleted")
     }) { (task: NSURLSessionDataTask?, error: NSError) in
     print("error: \(error.localizedDescription)")
     }
     
     }
     */
    
    func getRateStatuses(handler: ((response: NSDictionary?, error: NSError?) -> Void)) {
        GET("1.1/application/rate_limit_status.json?resources=statuses", parameters:nil,
            success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                if let dict = response as? NSDictionary {
                    handler(response:dict, error:nil)
                }
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                handler(response:nil, error:error)
        })
    }
    
    private static let ratePrintLabels = [
        "/statuses/home_timeline":"home timeline",
        "/statuses/retweets/:id":"retweet",
        "/statuses/user_timeline":"user timeline"]
    
    func printRateStatuses() {
        self.getRateStatuses { (response, error) in
            if let error = error {
                print("received error getting rate limits")
            }else{
                if let response = response {
                    for (key,value) in TwitterClient.ratePrintLabels {
                        if let resourcesDict = response["resources"] as? NSDictionary {
                            if let statusDict = resourcesDict["statuses"] as? NSDictionary {
                                if let keyDict = statusDict[key] as? NSDictionary {
                                    let limit = keyDict["limit"] as! Int
                                    let remaining = keyDict["remaining"] as! Int
                                    let epoch = keyDict["reset"] as! Int
                                    let resetDate = NSDate(timeIntervalSince1970: Double(epoch))
                                    print("\(value) rate: limit=\(limit), remaining=\(remaining); expires in \(TwitterClient.formatIntervalElapsed(resetDate.timeIntervalSinceNow))")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private static var elapsedTimeFormatter: NSDateComponentsFormatter = {
        let formatter = NSDateComponentsFormatter()
        formatter.unitsStyle = NSDateComponentsFormatterUnitsStyle.Abbreviated
        formatter.collapsesLargestUnit = true
        formatter.maximumUnitCount = 1
        return formatter
    }()
    
    static func formatTimeElapsed(sinceDate: NSDate) -> String {
        let interval = NSDate().timeIntervalSinceDate(sinceDate)
        return elapsedTimeFormatter.stringFromTimeInterval(interval)!
    }
    
    static func formatIntervalElapsed(interval: NSTimeInterval) -> String {
        return elapsedTimeFormatter.stringFromTimeInterval(interval)!
    }
}
