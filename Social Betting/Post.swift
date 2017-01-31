//
//  Post.swift
//  Social Betting
//
//  Created by William Z Wang on 1/9/17.
//  Copyright © 2017 Ashish Keshan. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

struct Post {
    
    let key: String
    let postID: Int
    let bet: String
    let likes: Int
    var comments: Array<String> = Array()
    let witnesses: Int                      // Show who witnesses are, COME BACK TO THIS LATER
    let better: String
    let betted: String
    let upVotes: Int
    let downVotes: Int
    let timePosted: String
    let ref: FIRDatabaseReference?
    
    init(postid: Int, bet: String, likes: Int, comments: Array<String>, witnesses: Int, better: String,
         betted: String, upvotes: Int, downvotes: Int, timePosted: String, key: String = "") {
        self.key = key
        self.postID = postid
        self.bet = bet
        self.likes = likes
        self.comments = comments
        self.witnesses = witnesses                      // Show who witnesses are, COME BACK TO THIS LATER
        self.better = better
        self.betted = betted
        self.upVotes = upvotes
        self.downVotes = downvotes
        self.timePosted = timePosted
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        postID = snapshotValue["postID"] as! Int
        bet = snapshotValue["bet"] as! String
        betted = snapshotValue["betted"] as! String
        better = snapshotValue["better"] as! String
        upVotes = snapshotValue["upVotes"] as! Int
        downVotes = snapshotValue["downVotes"] as! Int
        
        // Convert date to a string if necessary. If not, then keep it
        var numberThingString: String = ""
        
        if let result_number = snapshotValue["timePosted"] as? NSNumber
        {
            numberThingString = "\(result_number)"
            print("INSIDE IF STATEMENT")
            print(numberThingString)
        }
        
        else {
            numberThingString = snapshotValue["timePosted"] as! String
        }
        
        
//        print("TYPE OF NUMBERTHING")
//        print(numberThingString)
//        print(type(of: numberThingString))
        timePosted = numberThingString
//
//        print("IN INIT FUNCTION, PRINTING NUMBER THING STRING")
//        print(numberThingString)
//        print(type(of:timePosted))
        likes = snapshotValue["likes"] as! Int
        witnesses = snapshotValue["witnesses"] as! Int
        ref = nil
    }
    
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
