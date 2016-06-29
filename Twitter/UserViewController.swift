//
//  UserViewController.swift
//  Twitter
//
//  Created by Nancy Yao on 6/28/16.
//  Copyright © 2016 Nancy Yao. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userHeaderImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userUsernameLabel: UILabel!
    @IBOutlet weak var userTaglineLabel: UILabel!

    @IBOutlet weak var userTweetsLabel: UILabel!
    @IBOutlet weak var userFollowingLabel: UILabel!
    @IBOutlet weak var userFollowersLabel: UILabel!
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
