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

protocol AlertProtocol : class {    // 'class' means only class types can implement it
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
    
    var cellDelegate: AlertProtocol?

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
        
        print("THE ID IS: ")
        print(id)
        
        var likeValue: Int = 0
        
        let stringID = String(id)
        
        let singlePostRef = postFef.child(stringID)
        
        let testRef = singlePostRef.child("likes")
        
        
//        let concurrentQueue =
//            DispatchQueue(
//                label: "com.ashishkeshan.Social-Betting", // 1
//                attributes: .concurrent) // 2
//        concurrentQueue.sync() {
        let myGroup = DispatchGroup()
            myGroup.enter()
            testRef.observeSingleEvent(of: .value) { (snap: FIRDataSnapshot) in
                if(snap.exists()) {
                    print("EXISTS")
                    print(snap.value)
    //                likeValue = snap.value as! Int
                    let saveKey = "post" + stringID
                    if(self.likeButton.titleColor(for: UIControlState.normal) != UIColor.red) {
                        singlePostRef.updateChildValues(["likes":(snap.value as! Int) + 1])
                        self.likeButton.setTitleColor(UIColor.red, for: UIControlState.normal)
                        var colorToSetAsDefault : UIColor = UIColor.red
                        var data : NSData = NSKeyedArchiver.archivedData(withRootObject: colorToSetAsDefault) as NSData
                        UserDefaults.standard.set(data, forKey: saveKey)
                        UserDefaults.standard.synchronize()
                        print("SET DEFAULT USER COLOR TO RED")
                    }
                    else {
                        singlePostRef.updateChildValues(["likes":(snap.value as! Int) - 1])
                        self.likeButton.setTitleColor(UIColor.blue, for: UIControlState.normal)
                        var colorToSetAsDefault : UIColor = UIColor.blue
                        var data : NSData = NSKeyedArchiver.archivedData(withRootObject: colorToSetAsDefault) as NSData
                        UserDefaults.standard.set(data, forKey: saveKey)
                        UserDefaults.standard.synchronize()
                        print("SET DEFAULT USER COLOR TO BLUE")
                    }
                }
                myGroup.leave()
            }
            myGroup.notify(queue: DispatchQueue.main, execute: {
                print("LIKE VALUE IS:")
                print(likeValue)
            })
//        }
        
        
        // ---------------------------------- COME BACK TO THIS --------------------------- //
//        var userSelectedColor : NSData? = (UserDefaults.standard.object(forKey: saveKey) as? NSData)
//
//        if (userSelectedColor != nil) {
        
//        }
    
    }
    
    @IBAction func commentButtonDidTouch(_ sender: Any) {
    }
    
    @IBAction func voteButtonDidTouch(_ sender: Any) {
        self.cellDelegate?.showAlert(cell: self)
    }
    
    
}
