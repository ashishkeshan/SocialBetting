//
//  BetFeedCellTableViewCell.swift
//  Social Betting
//
//  Created by William Z Wang on 1/1/17.
//  Copyright © 2017 Ashish Keshan. All rights reserved.
//

import UIKit
import Firebase

class BetFeedCellTableViewCell: UITableViewCell {
    @IBOutlet var name1: UILabel!
    @IBOutlet var name2: UILabel!
    @IBOutlet var hearts: UILabel!
    @IBOutlet var witnesses: UILabel!
    @IBOutlet var like: UIButton!
    @IBOutlet var comment: UIButton!
    @IBOutlet var vote: UIButton!
    @IBOutlet var trophy: UIImageView!
    @IBOutlet var sadFace: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell() {
        self.name1.text = "Ashish K."
        self.name2.text = "William W."
        self.hearts.text = "Hearts 100+"
        self.witnesses.text = "Witnesses"
    }

}
