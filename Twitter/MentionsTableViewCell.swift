//
//  MentionsTableViewCell.swift
//  Twitter
//
//  Created by Nancy Yao on 7/1/16.
//  Copyright © 2016 Nancy Yao. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class MentionsTableViewCell: UITableViewCell {
    @IBOutlet weak var mentionImageView: UIImageView!
    @IBOutlet weak var mentionNameLabel: UILabel!
    @IBOutlet weak var mentionUsernameLabel: UILabel!
    @IBOutlet weak var mentionTimeLabel: UILabel!
    @IBOutlet weak var mentionTextLabel: TTTAttributedLabel!
    @IBOutlet weak var mentionRetweetLabel: UILabel!
    @IBOutlet weak var mentionLikeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
