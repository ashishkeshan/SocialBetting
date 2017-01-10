//
//  Post.swift
//  Social Betting
//
//  Created by William Z Wang on 1/9/17.
//  Copyright © 2017 Ashish Keshan. All rights reserved.
//

import Foundation
import Firebase

struct Post {
    
    let key: String
    let postID: Int
    let bet: String
    let likes: String
    let comments: Array<Float> = Array()
    let witnesses: Int                      // Show who witnesses are, COME BACK TO THIS LATER
    let better: String
    let betted: String
    let upVotes: Int
    let downVotes: Int
    let timePosted: Int
    let ref: FIRDatabaseReference?
    
    init(postid: Int, bet: String, likes: String, comments: Array<String>, witnesses: Int, better: String,
         betted: String, upvotes: Int, downvotes: Int, timePosted: Int, key: String = "") {
        self.key = key
        self.postID = postid
        self.bet = bet
        self.likes = likes
        self.comments = comments as! Array<Float>
        self.witnesses = witnesses                      // Show who witnesses are, COME BACK TO THIS LATER
        self.better = better
        self.betted = betted
        self.upVotes = upvotes
        self.downVotes = downvotes
        self.timePosted = timePosted
        self.ref = nil
    }
    
//    init(snapshot: FIRDataSnapshot) {
//        key = snapshot.key
//        let snapshotValue = snapshot.value as! [String: AnyObject]
//        postID = snapshotValue["postID"] as! Int
//        addedByUser = snapshotValue["addedByUser"] as! String
//        completed = snapshotValue["completed"] as! Bool
//        ref = snapshot.ref
//    }
    
    func toAnyObject() -> Any {
        return [
            "postID": postID,
            "bet": bet,
            "likes": likes,
            "comments": comments,
            "witnesses": witnesses,
            "better": better,
            "betted": betted,
            "upVotes": upVotes,
            "downVotes": downVotes,
            "timePosted": timePosted
        ]
    }
    
}
