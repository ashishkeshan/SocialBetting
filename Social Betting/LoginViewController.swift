//
//  LoginViewController.swift
//  Social Betting
//
//  Created by Ashish Keshan on 12/23/16.
//  Copyright © 2016 Ashish Keshan. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldLogin: UITextField!
    var friendsList: [String] = []
    var userID: String = ""
    var email:String = ""
    var name:String = ""
    var fName:String = ""
    var lName:String = ""
    var username:String = ""
    var id:String = ""
    var imageView : UIImageView?
    var usernameMap: NSMapTable<AnyObject, AnyObject>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        //imageView?.center = CGPoint(x: view.center.x, y: 150)
        //imageView?.image = UIImage(named: "silhouette.png")
        //view.addSubview(imageView!)
        
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        view.addSubview(loginButton)
        //frame's are obselete, please use constraints instead because its 2016 after all
        loginButton.frame = CGRect(x: 64, y: view.frame.height/1.5, width: view.frame.width - 128, height: 50)
        
        loginButton.delegate = self
        
        // Do any additional setup after loading the view.
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            if user != nil {
                //self.performSegue(withIdentifier: "showFeed", sender: nil)
            }
        }
    }

    @IBAction func loginPressed(_ sender: Any) {
        FIRAuth.auth()!.signIn(withEmail: textFieldLogin.text!,
                               password: textFieldPassword.text!)
    }
    @IBAction func signUpPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Register",
                                      message: "Register",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
            let emailField = alert.textFields![0]
            let passwordField = alert.textFields![1]
            FIRAuth.auth()!.createUser(withEmail: emailField.text!, password: passwordField.text!) { user, error in
                if error != nil {
                    print(error!)
                    return
                }
                guard let uid = user?.uid else{
                    return
                }
                let ref = FIRDatabase.database().reference(fromURL: "https://social-betting.firebaseio.com/")
                let usersReference = ref.child("users").child(uid)
                let values = ["email": emailField.text]
                usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                    if err != nil{
                        print(err as Any)
                        return
                    }
                    print("saved friend successfully!")
                })
                    
                FIRAuth.auth()!.signIn(withEmail: self.textFieldLogin.text!, password: self.textFieldPassword.text!)
                self.performSegue(withIdentifier: "showFeed", sender: self)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField { textEmail in
            textEmail.placeholder = "Enter your email"
        }
        
        alert.addTextField { textPassword in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Enter your password"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook")
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult?, error: Error!) {
        
        if error != nil {
            print(error)
            return
        }
        if (result?.isCancelled)!{
            return
        }
        
        getUserInfo()
        
        let fbRequest = FBSDKGraphRequest(graphPath:"/me/friends", parameters: nil)
        fbRequest?.start { (connection : FBSDKGraphRequestConnection?, result : Any?, error : Error?) -> Void in
            
            var resultDictionary:NSDictionary!
            
            if error == nil {
                
                print("Friends are : \(result)")
                resultDictionary = result as! [String:AnyObject] as NSDictionary!
                let test = resultDictionary.object(forKey: "data") as! [[String:AnyObject]]
                for i in test {
                    let dict = i as NSDictionary
                    let name = dict["name"] as! String
                    self.friendsList.append(name)
                }
            }
            let currUser = User(friendsList: self.friendsList, fullName: self.name, fName: self.fName, lName: self.lName, username: self.username )
            var val : Int = 0
            let userIndexRef = FIRDatabase.database().reference(withPath: "usernameOptions")
            userIndexRef.observeSingleEvent(of: .value, with: { (snapshot) in
                print(snapshot.childrenCount) // I got the expected number of items
                let enumerator = snapshot.children
                while let rest = enumerator.nextObject() as? FIRDataSnapshot {
                    if self.username == rest.key {
                        val = rest.value as! Int
                        val += 1
                        print("HERERERERERERERE")
                        
                    }
                }
            })
            print(val)
            userIndexRef.updateChildValues(["\(self.username)": val])
            let ref = FIRDatabase.database().reference(withPath: "users")
            let userRef = ref.child(self.id)
            userRef.setValue(currUser.toAnyObject())
            
            
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                if error != nil {
                    return
                }
            }
        self.performSegue(withIdentifier: "showFeed", sender: nil)
        print("Successfully logged in with facebook...")
        }
    }
    
    func getUserInfo() {
        
        let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name, first_name, last_name"])
        request?.start { (connection : FBSDKGraphRequestConnection?, result : Any?, error : Error?) -> Void in
            
            var infoDictionary:NSDictionary!
            
            if error == nil {
                infoDictionary = result as! [String:AnyObject] as NSDictionary!
                self.email = infoDictionary["email"] as! String
                self.id = infoDictionary["id"] as! String
                self.name = infoDictionary["name"] as! String
                self.fName = infoDictionary["first_name"] as! String
                self.lName = infoDictionary["last_name"] as! String
                self.username = self.fName + "-" + self.lName
                self.usernameMap?.setObject(self.username as AnyObject?, forKey: 1 as AnyObject?)
                let url = NSURL(string: "https://graph.facebook.com/\(self.id)/picture?type=large&return_ssl_resources=1")!
                if let data = NSData(contentsOf: url as URL) {
                    self.imageView?.image = UIImage(data: data as Data)
                }
                print(self.email + " " + self.id + " " + self.name)
            }
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
