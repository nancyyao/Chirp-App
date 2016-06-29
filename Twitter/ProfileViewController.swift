//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Nancy Yao on 6/28/16.
//  Copyright © 2016 Nancy Yao. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var profileHeaderImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileUsernameLabel: UILabel!
    @IBOutlet weak var profileTaglineLabel: UILabel!
    
    @IBOutlet weak var profileTweetsLabel: UILabel!
    @IBOutlet weak var profileFollowingLabel: UILabel!
    @IBOutlet weak var profileFollowersLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = User.currentUser! as User
        
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
