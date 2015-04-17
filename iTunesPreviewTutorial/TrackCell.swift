//
//  TrackCell.swift
//  iTunesPreviewTutorial
//
//  Created by Jameson Quave on 4/17/15.
//  Copyright (c) 2015 JQ Software LLC. All rights reserved.
//

import UIKit

class TrackCell: UITableViewCell {
    @IBOutlet weak var playIcon: UILabel!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
