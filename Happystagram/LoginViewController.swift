//
//  LoginViewController.swift
//  Happystagram
//
//  Created by 助廣 賢三 on 2017/01/16.
//  Copyright © 2017年 parallelto. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createNewUser(_ sender: Any) {
        
        if emailTextField.text == nil || passwordTextField.text == nil {
            
            let alertViewController = UIAlertController(title: "おっと。", message: "入力欄がからの状態です！", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alertViewController.addAction(okAction)
            present(alertViewController, animated: true, completion: nil)
            
        } else {
            
            FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                if error == nil {
                    UserDefaults.standard.set("check", forKey: "check")
                    self.dismiss(animated: true, completion: nil)
                } else {
                    let alertViewController = UIAlertController(title: "おっと。", message: error?.localizedDescription, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alertViewController.addAction(okAction)
                    self.present(alertViewController, animated: true, completion: nil)
                }
            })
        }
    }

    @IBAction func userLogin(_ sender: Any) {
        FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
            if error == nil {
                
            } else {
                
            }
        })
    }

}
