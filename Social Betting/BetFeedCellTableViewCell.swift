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
    @IBOutlet weak var betLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(currPost: Post) {
        
        self.name1.text = currPost.better
        self.name2.text = currPost.betted
        self.betLabel.text = currPost.bet
        self.hearts.text = String(currPost.likes)
        self.witnesses.text = String(currPost.witnesses)
        
    }

}
