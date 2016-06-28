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
    var tweetID: Int?
    var retweeted: Bool?
    var favorited: Bool?
    
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
        tweetID = dictionary["id"] as? Int
        retweeted = dictionary["retweeted"] as? Bool
        favorited = dictionary["favorited"] as? Bool
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }
 }
