//
//  User.swift
//  Social Betting
//
//  Created by Ashish Keshan on 1/9/17.
//  Copyright © 2017 Ashish Keshan. All rights reserved.
//

import Foundation
import Firebase

struct User {
    //let key: String
    //let profileImageUrl: String
    //let bet: String
    //let likes: String
    let friendsList: [String]
    let userID: String
    
    
    init(friendsList: [String], userID: String) {
        self.friendsList = friendsList
        self.userID = userID
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
            "friendsList:": friendsList,
            "userID:": userID
        ]
    }
}
