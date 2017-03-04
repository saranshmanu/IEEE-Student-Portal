//
//  SignUpViewController.swift
//  Final Login
//
//  Created by Saransh Mittal on 28/01/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SignUpViewController: UIViewController,UITextFieldDelegate  {
  
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var vitPasswordField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBAction func signUpAction(_ sender: Any) {
        if userNameField.text != "" && passwordField.text != "" {
            Alamofire.request("https://ieeevitportal.herokuapp.com/auth/save", method: .post, parameters: ["username" : userNameField.text!,"password": passwordField.text!,"vit_password": vitPasswordField.text!]).responseJSON(completionHandler: {response in
                print(response)
                
                if((response.result.value) != nil) {
                    let swiftyJsonVar = JSON(response.result.value!)
                    print(swiftyJsonVar)
                    if swiftyJsonVar["code"]=="0"
                    {
                        //Print into the console if successfully logged in
                        print("You have successfully signed up")
                        //alert for user to know that he has successfully signed up
                        let alertController = UIAlertController(title: "Success", message: "You have successfully sign up. Wait for us to respond.", preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                        //Go to the HomeViewController if the login is sucessful
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginPageViewController")
                        self.present(vc!, animated: true, completion: nil)
                    }
                    else
                    {
                        print("Sign Up not successfull as the user has already signed up or credentials arew invalid")
                        let alertController = UIAlertController(title: "Incorrect credentials", message: "Incorrect registration number or password", preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
                
            })
        }
        else{
            let alertController = UIAlertController(title: "Error", message: "Please enter your VIT registration number, password and VIT password.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // for hitting return
        userNameField.delegate = self
        passwordField.delegate = self
        vitPasswordField.delegate = self
        // for tapping
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard)))
        
        
    }
    // for tapping
    func dismissKeyboard() {
        userNameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        vitPasswordField.resignFirstResponder()
    }
    // for hitting return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userNameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        vitPasswordField.resignFirstResponder()
        return true
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
