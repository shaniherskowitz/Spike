//
//  SignUpViewController.swift
//  Walki Dog
//
//  Created by shani herskowitz on 9/23/18.
//  Copyright © 2018 shani herskowitz. All rights reserved.
//
import Foundation
import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var tapToChange: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    var imagePicker:UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(imageTap)
        imageView.layer.cornerRadius = imageView.bounds.height / 2
        imageView.clipsToBounds = true
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
    }
    
    @IBAction func signup(_ sender: Any) {
        guard let username = self.username?.text else {return}
        guard let email = self.email?.text else {return}
        guard let password = self.password?.text else {return}
        guard let image = self.profileImage.image else {return}
        
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            if error == nil && user != nil {
                print("User created!")
                
                // upload the profile image to firebase storage
                self.uplaodProfileImage(image) {url in
                    if url != nil {
                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                        changeRequest?.displayName = username
                        changeRequest?.photoURL = url
                        changeRequest?.commitChanges { error in
                            if error == nil {
                                print("User display name changed!")
                                self.saveProfile(username: username, profileImageURL: url!) { success in
                                    if success! {
                                        self.navigationController?.popViewController(animated: true)
                                        self.dismiss(animated: true, completion: nil)
                                    }
                                }
                                //self.navigationController?.popViewController(animated: true)
                                //self.dismiss(animated: false, completion: nil)
                            } else {
                                print("Error: \(error!.localizedDescription)")
                            }
                        }
                    } else {
                        // handle error unable to upload profile image
                    }
                }
                
            } else {
                print("Error: \(error!.localizedDescription)")
            }
        }
    }
    
    func uplaodProfileImage(_ image:UIImage, completion: @escaping((_ url:URL?) -> ())) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let storageRef = Storage.storage().reference().child("user/\(uid)")
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {return}
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        storageRef.putData(imageData, metadata: metaData) { metaData, error in
            if error == nil, metaData != nil {
                storageRef.downloadURL(completion: { (url, error) in
                    if error != nil {
                        print("couldn't get profile image url \(String(describing: error).debugDescription)")
                        completion(nil)
                    } else {
                        completion(url?.absoluteURL)
                    }
                })
                // success!
            } else {
                // failed
                completion(nil)
            }
            //        storageRef.downloadURL { (url, error) in
            //            guard let downloadURL = url else {
            //                print("couldn't get profile image url")
            //                completion(nil)
            //                return
            //            }
            
        }
    }
    
    func saveProfile(username:String, profileImageURL:URL, completion: @escaping((_ success:Bool?) -> ())) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let databaseRef = Database.database().reference().child("users/profile/\(uid)")
        let userObject = [
            "username": username,
            "photoURL":profileImageURL.absoluteString
            ] as [String: Any]
        
        databaseRef.setValue(userObject) { error, ref in completion(error == nil) }
    }
    
    @objc func openImagePicker(_ sender:Any) {
        // Open Image Picker
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.profileImage.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
}
