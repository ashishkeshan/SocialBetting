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

class BetFeedCellTableViewCell: UITableViewCell {
    
    public var id: Int = 0
    
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
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var voteButton: UIButton!
    
    
    let postFef = FIRDatabase.database().reference(withPath: "posts");

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
    
    @IBAction func likeButtonDidTouch(_ sender: Any) {
        
        print("THE ID IS: ")
        print(id)
        
        let stringID = String(id)
        
        let singlePostRef = self.postFef.child(stringID)
        
        var likeValue: Int = 0
        
        let testRef = singlePostRef.child("likes")
        
        testRef.observeSingleEvent(of: .value) { (snap: FIRDataSnapshot) in
            if(snap.exists()) {
                print("EXISTS")
                print(snap.value)
//                likeValue = snap.value as! Int
                
                if(self.likeButton.titleColor(for: UIControlState.normal) != UIColor.red) {
                    singlePostRef.updateChildValues(["likes":(snap.value as! Int) + 1])
                    self.likeButton.setTitleColor(UIColor.red, for: UIControlState.normal)
                }
                else {
                    singlePostRef.updateChildValues(["likes":(snap.value as! Int) - 1])
                    self.likeButton.setTitleColor(UIColor.blue, for: UIControlState.normal)
                }
            }
        }
        
        print("LIKE VALUE IS:")
        print(likeValue)
    }
    
    @IBAction func commentButtonDidTouch(_ sender: Any) {
    }
    
    @IBAction func voteButtonDidTouch(_ sender: Any) {
    }
    

}
