//
//  BetFeedCellTableViewCell.swift
//  Social Betting
//
//  Created by William Z Wang on 1/1/17.
//  Copyright © 2017 Ashish Keshan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

protocol BetFeedTableViewCellDelegate : class {
    func likeButtonDidTouch(cell: BetFeedCellTableViewCell) -> Void
    func showAlert(cell: BetFeedCellTableViewCell) -> Void
}

class BetFeedCellTableViewCell: UITableViewCell {
    
    public var id: Int = 0
    public var row: Int = 0
    
    @IBOutlet var name1: UILabel!
    @IBOutlet var name2: UILabel!
    @IBOutlet var hearts: UILabel!
    @IBOutlet var witnesses: UILabel!
    @IBOutlet weak var like: UIButton!
    @IBOutlet var comment: UIButton!
    @IBOutlet var trophy: UIImageView!
    @IBOutlet var sadFace: UIImageView!
    @IBOutlet weak var heartImage: UIImageView!
    @IBOutlet weak var betLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var upVotes: UILabel!
    @IBOutlet weak var downVotes: UILabel!
    @IBOutlet weak var postTime: UILabel!
    
    var didVoteBetted: Bool = false
    var didVoteBetter: Bool = false
    var alreadyVoted: Bool = false
    
    let postFef = FIRDatabase.database().reference(withPath: "posts")
    
//    var cellDelegate: AlertProtocol?
    var delegate: BetFeedTableViewCellDelegate?

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
        self.postTime.text = currPost.timePosted
        
        print("IN CONFIGURE FUNCTION")
        print(type(of:currPost.timePosted))
        
    }
    
    @IBAction func likeButtonDidTouch(_ sender: Any) {
        print("CHECKING LIKE BUTTON DELEGATE")
        self.delegate?.likeButtonDidTouch(cell: self)
    }
    
    @IBAction func commentButtonDidTouch(_ sender: Any) {
    }
    
    @IBAction func voteButtonDidTouch(_ sender: Any) {
        self.delegate?.showAlert(cell: self)
    }
    
    
}
