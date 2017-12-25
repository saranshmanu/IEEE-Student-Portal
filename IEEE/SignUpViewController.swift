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
  
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var userNameField: CustomTextField!
    @IBOutlet weak var passwordField: CustomTextField!
    @IBOutlet weak var vitPasswordField: CustomTextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var ActivityIndicatorLoader: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func signUpAction(_ sender: Any) {
        signUpButton.isEnabled = false
        //to start activity indicator
        ActivityIndicatorLoader.startAnimating()
        if Reachability.isConnectedToNetwork() == true
        {
            print("Internet Connection Available!")
            if userNameField.text != "" && passwordField.text != "" && vitPasswordField.text != "" {
                Alamofire.request("https://ieeevitportal.herokuapp.com/auth/save", method: .post, parameters: ["username" : userNameField.text!,"password": passwordField.text!,"vit_password": vitPasswordField.text!]).responseJSON(completionHandler: {response in
                    print(response)
                    
                    if(((response.result.value) != nil) && response.result.isSuccess) { //MOD
                        let swiftyJsonVar = JSON(response.result.value!)
                        print(swiftyJsonVar)
                        if swiftyJsonVar["code"]=="0"
                        {
                            //to stop activity indicator
                            self.ActivityIndicatorLoader.stopAnimating()
                            //Print into the console if successfully logged in
                            print("You have successfully signed up")
                            self.signUpButton.isEnabled = true
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
                            //to stop activity indicator
                            self.ActivityIndicatorLoader.stopAnimating()
                            print("Sign Up not successfull as the user has already signed up or credentials are invalid")
                            self.signUpButton.isEnabled = true
                            let alertController = UIAlertController(title: "Incorrect credentials", message: "Incorrect registration number or password", preferredStyle: .alert)
                            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            alertController.addAction(defaultAction)
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                    
                })
            }
            else{
                //to stop activity indicator
                self.ActivityIndicatorLoader.stopAnimating()
                //to initiate alert if the text fields are empty
                signUpButton.isEnabled = true
                let alertController = UIAlertController(title: "Error", message: "Please your VIT registration number and password.", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        else
        {
            //to stop activity indicator
            self.ActivityIndicatorLoader.stopAnimating()
            print("Internet Connection not Available!")
            signUpButton.isEnabled = true
            let alertController = UIAlertController(title: "Internet Connection not Available!", message: "Check your internet connection.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            print("Internet Connection not Available!")
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        signUpButton.layer.cornerRadius =  10
        loginButton.layer.cornerRadius = 10
        // for hitting return
        userNameField.delegate = self
        passwordField.delegate = self
        vitPasswordField.delegate = self
        // for tapping
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard)))
        
        
        //for dismmisiong and moving up the keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    var keyboard_flag = 0
    
    func keyboardWillHide(_ notification: Notification) {
        print("HIDE")
        if keyboard_flag == 0 {
            return
        }
        keyboard_flag = 0
        let userInfo: NSDictionary = (notification as NSNotification).userInfo! as NSDictionary
        let keyboardFrame: NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardHeight = keyboardFrame.cgRectValue.height
        let duration = userInfo.object(forKey: UIKeyboardAnimationDurationUserInfoKey) as! TimeInterval
        bottomConstraint.constant -= (keyboardHeight-100)
        UIView.animate(withDuration: duration, animations: {void in
            
            self.view.layoutIfNeeded()
            
        })
    }
    
    func keyboardWillShow(_ notification: Notification) {
        print("SHow")
        if keyboard_flag != 0 {
            return
        }
        keyboard_flag = 1
        let userInfo: NSDictionary = (notification as NSNotification).userInfo! as NSDictionary
        let keyboardFrame: NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardHeight = keyboardFrame.cgRectValue.height
        let duration = userInfo.object(forKey: UIKeyboardAnimationDurationUserInfoKey) as! TimeInterval
        self.bottomConstraint.constant += (keyboardHeight-100)
        UIView.animate(withDuration: duration, animations: {void in
            self.view.layoutIfNeeded()
        })
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
    
    var initialCenter: CGFloat = 0.0

    //for moving up the view when the keyboard is called
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        UIView.animate(withDuration: 0.3) {
//            self.initialCenter = self.moveUpView.center.y
//            self.moveUpView.center.y = self.view.center.y - 20.0
//        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        if !(self.userNameField.isEditing || self.passwordField.isEditing) {
//            
//            UIView.animate(withDuration: 0.5, animations: {
//                self.moveUpView.center.y = self.initialCenter
//            })
//            
//        }
        textField.resignFirstResponder()
        //dismissKeyboard()
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
