 //
 //  Tweet.swift
 //  Twitter
 //
 //  Created by Nancy Yao on 6/27/16.
 //  Copyright © 2016 Nancy Yao. All rights reserved.
 //
 
 import UIKit
 
 class Tweet: NSObject {
    var text: NSString?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var tweetUser: User?
    
    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        let timestampString = dictionary["created_at"] as? String
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        if let timestampString = timestampString {
            timestamp = formatter.dateFromString(timestampString)
        }
        tweetUser = User(dictionary: dictionary["user"] as! NSDictionary)
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            print(tweet.tweetUser)
            tweets.append(tweet)
        }
        return tweets
    }
 }
