//
//  ProfileViewController.swift
//  Social Betting
//
//  Created by Ashish Keshan on 1/5/17.
//  Copyright © 2017 Ashish Keshan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var profileImage: UIImageView!
    

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var betSenseLabel: UILabel!
    @IBOutlet weak var totalBetsLabel: UILabel!
    
    let user = FIRAuth.auth()?.currentUser
    
    let ref = FIRDatabase.database().reference(withPath: "users")
    var userRef = FIRDatabase.database().reference()
    var profileRef = FIRDatabase.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        profileImage.isUserInteractionEnabled = true
        
        profileImage.layer.borderWidth = 0.1
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.black.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
        
        userRef = ref.child((self.user?.uid)!)
        print("IN PROFILE ABOUT TO PRINT USER ID")
        print((self.user?.uid)!)
        profileRef = userRef.child("profileImageURL")
        profileRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? String
            if value != nil {
                let profileImageURL = value
                let url = NSURL(string: profileImageURL!)
                let request = URLRequest(url: url! as URL)
                URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                    if error != nil {
                        print(error ?? "error")
                        return
                    }
                    else{
                        DispatchQueue.main.async {
                            self.profileImage.image = UIImage(data: data!)
                        }
                    }
                    
                }).resume()
            }
        })
        
        if self.revealViewController() != nil {
            menuButton?.target = self.revealViewController()
            menuButton?.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        // Do any additional setup after loading the view.
    }
    
    func handleSelectProfileImageView() {
        let actionSheetController: UIAlertController = UIAlertController(title: "Action Sheet", message: "Swiftly Now! Choose an option!", preferredStyle: .actionSheet)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheetController.addAction(cancelAction)
        //Create and add first option action
        let takePictureAction: UIAlertAction = UIAlertAction(title: "Take Picture", style: .default) { action -> Void in
            //Code for launching the camera goes here
        }
        actionSheetController.addAction(takePictureAction)
        //Create and add a second option action
        let choosePictureAction: UIAlertAction = UIAlertAction(title: "Choose From Camera Roll", style: .default) { action -> Void in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            self.present(picker, animated: true, completion: nil)
        }
        actionSheetController.addAction(choosePictureAction)
        
        //Present the AlertController
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            //print((editedImage as AnyObject).size)
            selectedImageFromPicker = editedImage
            
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
           // print((originalImage as AnyObject).size)
            selectedImageFromPicker = originalImage as? UIImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImage.image = selectedImage
            let storageRef = FIRStorage.storage().reference().child("\(usernameLabel.text!).png")
            if let uploadData = UIImagePNGRepresentation(self.profileImage.image!) {
                storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error)
                        return
                    }
                    else{
                        if let profileImageURL = metadata?.downloadURL()?.absoluteString {
                            self.profileRef.setValue(profileImageURL)
                        }
                        print(metadata)
                    }
                })
            }
        }
        
        print(info)
        dismiss(animated: true, completion: nil)

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
