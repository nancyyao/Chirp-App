//
//  UserHeader.swift
//  Twitter
//
//  Created by Nancy Yao on 6/30/16.
//  Copyright © 2016 Nancy Yao. All rights reserved.
//

import UIKit

class UserHeader: UITableViewHeaderFooterView {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userUsernameLabel: UILabel!
    @IBOutlet weak var userTaglineLabel: UILabel!
    @IBOutlet weak var userTweetsLabel: UILabel!
    @IBOutlet weak var userFollowingLabel: UILabel!
    @IBOutlet weak var userFollowersLabel: UILabel!
    @IBOutlet weak var userBackgroundImageView: UIView!
    @IBOutlet weak var userHeaderImageView: UIImageView!

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    @IBAction func onLogOut(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
    }

}
