//
//  BetFeedTableViewController.swift
//  Social Betting
//
//  Created by William Z Wang on 12/31/16.
//  Copyright © 2016 Ashish Keshan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class BetFeedTableViewController: UIViewController, UITableViewDataSource, AlertProtocol {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var sideMenuButton: UIBarButtonItem!
    
    let ref = FIRDatabase.database().reference(withPath: "posts")
    var count: Int = 0
    var textFieldOne: UITextField!
    var textFieldTwo: UITextField!
    var bet: String = ""
    var likes: Int = 0
    var witnesses: Int = 0                    // Show who witnesses are, COME BACK TO THIS LATER
    var better: String = ""
    var betted: String = ""
    var upvotes: Int = 0
    var downvotes: Int = 0
    var timePosted: Int = 0
    var posts: [Post] = []
    
    var isFirstOpening: Bool = true
    
    let postFef = FIRDatabase.database().reference(withPath: "posts");
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            sideMenuButton?.target = self.revealViewController()
            sideMenuButton?.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        ref.observe(.value) { (snap: FIRDataSnapshot) in
            self.posts.removeAll()
//            print(snap.childrenCount) // I got the expected number of items
            let enumerator = snap.children
            while let rest = enumerator.nextObject() as? FIRDataSnapshot {
                let currPost = Post(snapshot: rest )
                self.posts.append(currPost)
//                print(currPost.betted)
                self.tableView.reloadData()
            }
        }
        
    }
    
    @IBAction func addButtonDidTouch(_ sender: Any) {
        
        self.count = posts.count
        
        print("COUNT IS:")
        print(count)
        
        let stringCount = String(self.count)
        
        let alert = UIAlertController(title: "Make A Bet",
                                      message: "Fill in the fields",
                                      preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: addTextField1)
        alert.addTextField(configurationHandler: addTextField2)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { _ in
            // 1
            let text = self.textFieldOne.text
        
            let textTwo = self.textFieldTwo.text

            let postComments = ["hella dank", "shit breh dis gg", "u rekt dawg"]
            
            // Specify date components
            // get the current date and time
            let currentDateTime = Date()
            
            // initialize the date formatter and set the style
            let formatter = DateFormatter()
            formatter.timeStyle = .medium
            formatter.dateStyle = .long
            
            // get the date time String from the date object
            formatter.string(from: currentDateTime) // October 8, 2016 at 10:48:53 PM
                                        
            // "10/8/16, 10:52 PM"
            formatter.timeStyle = .short
            formatter.dateStyle = .short
            print("CURRENT DATE TIME")
            print(formatter.string(from: currentDateTime))
            
            let currTime = formatter.string(from: currentDateTime)
                                        
//            print("THE DATE TIME IS: ")
            print(currTime)
            print(type(of: currTime)) // Is String here
            let post = Post(postid: self.count,
                            bet: text!,
                            likes: 0,
                            comments: postComments,
                            witnesses: 0,                     // Show who witnesses are, COME BACK TO THIS LATER
                            better: "William",
                            betted: textTwo!,
                            upvotes: 0,
                            downvotes: 0,
                            timePosted: currTime,
                            key: "this is a key")
            
            // 3
            print("String count is:")
            print(stringCount)
            let postRef = self.ref.child(stringCount)
            
            // 4
            postRef.setValue(post.toAnyObject())
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func addTextField1(textField: UITextField!)
    {
        textField.placeholder = "Enter bet"
        textFieldOne = textField
    }
    
    func addTextField2(textField: UITextField!)
    {
        textField.placeholder = "Who are you betting with?"
        textFieldTwo = textField
    }
    
    func showAlert(cell: BetFeedCellTableViewCell){
        
        let id = String(cell.id)
        let singlePostRef = postFef.child(id)
        let bettedVotesRef = singlePostRef.child("upVotes")
        let betterVotesRef = singlePostRef.child("downVotes")
        
        let alert = UIAlertController(title: "Who do you vote for?", message: "Choose one", preferredStyle: .alert)
        
        let bettedRef = singlePostRef.child("betted")
        let betterRef = singlePostRef.child("better")
        
        var betted: String = ""
        var better: String = ""
        
        var upVotesBettedValue: Int = 0
        var downVotesBetterValue: Int = 0
        
        // Asynchronous, begin Dispatch Group
        let myGroup = DispatchGroup()
        
        myGroup.enter()
        bettedRef.observeSingleEvent(of: .value, with: {(snap) in
            betted = snap.value as! String
        })
        
        bettedVotesRef.observeSingleEvent(of: .value) { (snap: FIRDataSnapshot) in
            upVotesBettedValue = snap.value as! Int
        }
        
        betterVotesRef.observeSingleEvent(of: .value) { (snap: FIRDataSnapshot) in
            downVotesBetterValue = snap.value as! Int
        }
        
        
        betterRef.observeSingleEvent(of: .value , with: {(snap) in
            better = snap.value as! String
            // Functions done, move on to next thing. Put in Async block to tell program that async is done
            myGroup.leave()
        })
    
        myGroup.notify(queue: DispatchQueue.main, execute: {
            print("BETTED IS:")
            print(betted)
            
            print("BETTER IS:")
            print(better)
            
            betted = "Betted: " + betted
            better = "Better: " + better
            
            let bettedWillWinAction = UIAlertAction(title: betted,
                                                    style: .default) { _ in
                bettedVotesRef.observeSingleEvent(of: .value) { (snap: FIRDataSnapshot) in
                    if(snap.exists()) {
                        print("EXISTS")
                        print(snap.value)
                        
                        upVotesBettedValue = snap.value as! Int
                        
                        // If already voted for the person being betted and tapped again, then - 1 from it.
                        if(cell.didVoteBetted && !cell.didVoteBetter) {
                            singlePostRef.updateChildValues(["upVotes":(snap.value as! Int) - 1])
                            print("NEW VALUE IS:")
                            print(snap.value)
                            cell.didVoteBetted = false
                            
                        }
                            
                        // If voted for the BETTER and not the current betted, then add 1 to this betted and
                        // subtract 1 from the better
                        else if(cell.didVoteBetter && !cell.didVoteBetted) {
                            singlePostRef.updateChildValues(["upVotes":(snap.value as! Int) + 1])
                            singlePostRef.updateChildValues(["downVotes":(downVotesBetterValue as! Int) - 1])
                            cell.didVoteBetted = true
                            cell.didVoteBetter = false
                        }
                        
                        else if(!cell.didVoteBetter && !cell.didVoteBetted) {
                            singlePostRef.updateChildValues(["upVotes":(snap.value as! Int) + 1])
                            print("NEW VALUE IS:")
                            print(snap.value)
                            cell.didVoteBetted = true
                        }
                    }
                }
            }
            
            let betterWillWinAction = UIAlertAction(title: better,
                                                    style: .default) { _ in
                betterVotesRef.observeSingleEvent(of: .value) { (snap: FIRDataSnapshot) in
                    if(snap.exists()) {
                        print("EXISTS")
                        print(snap.value)
                        
                        // If already voted for the BETTER and tapped again, then - 1 from it.
                        if(cell.didVoteBetter && !cell.didVoteBetted) {
                            singlePostRef.updateChildValues(["downVotes":(snap.value as! Int) - 1])
                            cell.didVoteBetter = false
                        }
                            
                        // If voted for the BETTED and not the current better, then add 1 to this betted and subtract 1 from the better
                        else if(cell.didVoteBetted && !cell.didVoteBetter) {
                            singlePostRef.updateChildValues(["downVotes":(snap.value as! Int) + 1])
                            singlePostRef.updateChildValues(["upVotes":(upVotesBettedValue as! Int) - 1])
                            cell.didVoteBetted = false
                            cell.didVoteBetter = true
                        }
                        
                        else if(!cell.didVoteBetter && !cell.didVoteBetted) {
                            singlePostRef.updateChildValues(["downVotes":(snap.value as! Int) + 1])
                            print("NEW VALUE IS:")
                            print(snap.value)
                            cell.didVoteBetter = true
                        }
                    }
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel",
                                             style: .default)
            
            alert.addAction(betterWillWinAction)
            alert.addAction(bettedWillWinAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
            
//            completion(result: fill)
        })
}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
//
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BetFeedCellTableViewCell", for: indexPath) as! BetFeedCellTableViewCell

        cell.cellDelegate = self
        
        let configurePost = posts[indexPath.row]
        
        // Configure the cell...
        
        cell.configureCell(currPost: configurePost);
        cell.id = configurePost.postID
        
        if(isFirstOpening) {
            let postToGet = "post" + String(configurePost.postID)
            
            if let userSelectedColorData  = UserDefaults.standard.object(forKey: postToGet) as? NSData {
                if let userSelectedColor = NSKeyedUnarchiver.unarchiveObject(with: userSelectedColorData as Data) as? UIColor {
                    
                    cell.likeButton.setTitleColor(userSelectedColor, for: UIControlState.normal)
                }
            }
        }
        
//        let stringID = String(cell.id)
        
//        cell.voteButton.tag = indexPath.row
//        cell.voteButton.addTarget(self, action: Selector("showAlert:"), for:UIControlEvents.touchUpInside)
        
        isFirstOpening = false

        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    //Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
             //Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
             //Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
     */
}

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfYear], from: date, to: self).weekOfYear ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}
 

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
