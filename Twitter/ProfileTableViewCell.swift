//
//  ProfileTableViewCell.swift
//  Twitter
//
//  Created by Nancy Yao on 6/29/16.
//  Copyright © 2016 Nancy Yao. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    @IBOutlet weak var profileTimelineImageView: UIImageView!
    @IBOutlet weak var profileTimelineNameLabel: UILabel!
    @IBOutlet weak var profileTimelineUsernameLabel: UILabel!

    @IBOutlet weak var profileTimelineTextLabel: UILabel!
    @IBOutlet weak var profileTimelineTimeLabel: UILabel!
    @IBOutlet weak var profileTimelineRetweetLabel: UILabel!
    @IBOutlet weak var profileTimelineLikeLabel: UILabel!
    
    @IBOutlet weak var profileTimelineLikeButton: UIButton!
    @IBOutlet weak var profileTimelineReplyButton: UIButton!
    @IBOutlet weak var profileTimelineRetweetButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onProfileLikeButton(sender: UIButton) {
    }
    @IBAction func onProfileReplyButton(sender: UIButton) {
    }
    @IBAction func onProfileRetweetButton(sender: UIButton) {
    }
    
    
    
}
