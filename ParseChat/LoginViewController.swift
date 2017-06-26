//
//  LoginViewController.swift
//  ParseChat
//
//  Created by Rhian Chavez on 6/26/17.
//  Copyright © 2017 Rhian Chavez. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    let alertController = UIAlertController(title: "Error", message: "Username or Password Empty", preferredStyle: .alert)
    
    // create a cancel action
    let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
        // handle cancel response here. Doing nothing will dismiss the view.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // add the cancel action to the alertController
        alertController.addAction(cancelAction)
        // Do any additional setup after loading the view.
    }

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUp(_ sender: Any) {
        let newUser = PFUser()
        if usernameField.text?.isEmpty == true || passwordField.text?.isEmpty == true{
            present(alertController, animated: true) 
        }
        else{
            // set user properties
            newUser.username = usernameField.text
            //newUser.email = emailLabel.text
            newUser.password = passwordField.text
            
            // call sign up function on the object
            newUser.signUpInBackground { (success: Bool, error: Error?) in
                if let error = error {
                    print(error.localizedDescription)
                    let alertControllerError = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                        // handle cancel response here. Doing nothing will dismiss the view.
                    }
                    alertControllerError.addAction(cancelAction)
                    self.present(alertControllerError, animated: true)
                } else {
                    print("User Registered successfully")
                    // manually segue to logged in view
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                }
            }
        }
    }

    @IBAction func login(_ sender: Any) {
        let username = usernameField.text ?? ""
        let password = passwordField.text ?? ""
        if username == "" || password == ""{
            present(alertController, animated: true)
        }
        PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
            if let error = error {
                print("User log in failed: \(error.localizedDescription)")
                let alertControllerError = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                    // handle cancel response here. Doing nothing will dismiss the view.
                }
                alertControllerError.addAction(cancelAction)
                self.present(alertControllerError, animated: true)
            } else {
                print("User logged in successfully")
                // display view controller that needs to shown after successful login
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
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
