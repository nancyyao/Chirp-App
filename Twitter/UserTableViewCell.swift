//
//  UserTableViewCell.swift
//  Twitter
//
//  Created by Nancy Yao on 6/29/16.
//  Copyright © 2016 Nancy Yao. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class UserTableViewCell: UITableViewCell {
    @IBOutlet weak var userTimelineImageView: UIImageView!
    @IBOutlet weak var userTimelineNameLabel: UILabel!
    @IBOutlet weak var userTimelineUsernameLabel: UILabel!
    @IBOutlet weak var userTimelineTextLabel: TTTAttributedLabel!
    @IBOutlet weak var userTimelineTimeLabel: UILabel!
    @IBOutlet weak var userTimelineRetweetLabel: UILabel!
    @IBOutlet weak var userTimelineLikeLabel: UILabel!
    @IBOutlet weak var userTimelineReplyButton: UIButton!
    @IBOutlet weak var userTimelineRetweetButton: UIButton!
    @IBOutlet weak var userTimelineLikeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @IBAction func onTimelineReplyButton(sender: AnyObject) {
    }
    @IBAction func onTimelineRetweetButton(sender: AnyObject) {
    }
    @IBAction func onTimelineLikeButton(sender: AnyObject) {
    }

}
