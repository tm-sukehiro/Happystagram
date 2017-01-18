//
//  SettingViewController.swift
//  Happystagram
//
//  Created by 助廣 賢三 on 2017/01/16.
//  Copyright © 2017年 parallelto. All rights reserved.
//

import UIKit
import Firebase

class SettingViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userNameTextField.delegate = self
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeProfile(_ sender: Any) {
        let alertViewController = UIAlertController(title: "選択してください", message: "", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "カメラ", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
            self.openCamera()
        })
        let photosAction = UIAlertAction(title: "アルバム", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
            self.openPhoto()
        })
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        
        alertViewController.addAction(cameraAction)
        alertViewController.addAction(photosAction)
        alertViewController.addAction(cancelAction)
        
        present(alertViewController, animated: true, completion: nil)
    }
    
    @IBAction func logout(_ sender: Any) {
        
        try! FIRAuth.auth()?.signOut()
        UserDefaults.standard.removeObject(forKey: "check")
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done(_ sender: Any) {
        
        var data: NSData = NSData()
        if let image = profileImageView.image {
            data = UIImageJPEGRepresentation(image, 0.1)! as NSData
        }
        
        let userName = userNameTextField.text
        let base64String = data.base64EncodedString(options: .lineLength64Characters) as String
        UserDefaults.standard.set(base64String, forKey: "profileImage")
        UserDefaults.standard.set(userName, forKey: "userName")
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            profileImageView.contentMode = .scaleToFill
            profileImageView.image = pickedImage
            
        }

        picker.dismiss(animated: true, completion: nil)
    }
    
    func openCamera() {
        let sourceType: UIImagePickerControllerSourceType = .camera
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
        }
    }
    
    func openPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoPicker = UIImagePickerController()
            photoPicker.sourceType = .photoLibrary
            photoPicker.delegate = self
            self.present(photoPicker, animated: true, completion: nil)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (userNameTextField.isFirstResponder) {
            userNameTextField.resignFirstResponder()
        }
    }
}
