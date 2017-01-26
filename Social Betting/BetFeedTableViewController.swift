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


class BetFeedTableViewController: UIViewController, UITableViewDataSource {
    
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
//                                        guard let textFieldOne = alert.textFields?.first,
                                            let text = self.textFieldOne.text
                                        
//                                        guard let textFieldTwo = alert.textFields?.,
                                            let textTwo = self.textFieldTwo.text

                                        let postComments = ["hella dank", "shit breh dis gg", "u rekt dawg"]
                                        
                                        let post = Post(postid: self.count,
                                                               bet: text!,
                                                               likes: 0,
                                                               comments: postComments,
                                                               witnesses: 0,                     // Show who witnesses are, COME BACK TO THIS LATER
                                                                better: "William",
                                                                betted: textTwo!,
                                                                upvotes: 0,
                                                                downvotes: 0,
                                                                timePosted: 1230,
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

        let configurePost = posts[indexPath.row]
        
        // Configure the cell...
        
        cell.configureCell(currPost: configurePost);
        cell.id = configurePost.postID
        
        if(isFirstOpening) {
            let postToGet = "post" + String(configurePost.postID)
            
            if let userSelectedColorData  = UserDefaults.standard.object(forKey: postToGet) as? NSData {
                print("HERE")
                if let userSelectedColor = NSKeyedUnarchiver.unarchiveObject(with: userSelectedColorData as Data) as? UIColor {
                    
                    cell.likeButton.setTitleColor(userSelectedColor, for: UIControlState.normal)
                }
            }
        }
        
        isFirstOpening = false
        
//        cell.Name2.text = "William W."
//        cell.bet.text = "10 Pushups or 2 Shots"
//        cell.numLikes.text = "Heart 100 People"
//        cell.witnesses.text = "Witnesses"

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
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

}
