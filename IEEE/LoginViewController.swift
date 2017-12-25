//
//  ViewController.swift
//  Final Login
//
//  Created by Saransh Mittal on 21/01/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import LocalAuthentication


var token:String = "" //token generated is stored in parameter
var registrationNumber = ""

class ViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var ActivityIndicatorLoader: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var userNameField: CustomTextField!
    @IBOutlet weak var passwordField: CustomTextField!
    @IBOutlet weak var DiveInButton: UIButton!
    @IBOutlet weak var SignUpButton: UIButton!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var initialCenter: CGFloat = 0.0
    override func viewDidAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        token = defaults.string(forKey: "MyKey")!
        print(token)
        if(token != "")
        {
            print("Using previous session")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
            self.present(vc!, animated: true, completion: nil)
            //self.fingerprintAuthenticationTwo()
        }
    }
    
    @IBAction func loginAction(_ sender: Any) {
        ActivityIndicatorLoader.startAnimating()
        SignUpButton.isEnabled = false
        DiveInButton.isEnabled = false
        userNameField.isEnabled = false
        passwordField.isEnabled = false
        if Reachability.isConnectedToNetwork() == true
        {
            print("login taking place with internet connection available")
            if userNameField.text != "" && passwordField.text != ""
            {
                //almofire request to server
                Alamofire.request("https://ieeevitportal.herokuapp.com/auth/login", method: .post, parameters: ["username" : userNameField.text!,"password": passwordField.text!]).responseJSON(completionHandler: {response in
                    if(((response.result.value) != nil) && response.result.isSuccess) { //MOD
                        let swiftyJsonVar = JSON(response.result.value!)
                        token = String(describing: swiftyJsonVar["token"])
                        
                        if swiftyJsonVar["code"]=="1"
                        {
                            print("Login not successful")
                            //to stop activity indicator
                            self.ActivityIndicatorLoader.stopAnimating()
                            self.SignUpButton.isEnabled = true
                            self.DiveInButton.isEnabled = true
                            self.userNameField.isEnabled = true
                            self.passwordField.isEnabled = true
                            //to initiate alert if login is unsuccesfull
                            let alertController = UIAlertController(title: "Incorrect credentials", message: "Incorrect registration number or password", preferredStyle: .alert)
                            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            alertController.addAction(defaultAction)
                            self.present(alertController, animated: true, completion: nil)
                        }
                        else
                        {
                            //Print into the console if successfully logged in
                            print("You have successfully logged in")
                            //for enabling the action buttons again
                            self.SignUpButton.isEnabled = true
                            self.DiveInButton.isEnabled = true
                            self.userNameField.isEnabled = true
                            self.passwordField.isEnabled = true
                            //if the login is successfull saving the value of token for logging in next time
                            let defaults = UserDefaults.standard
                            defaults.set(token, forKey: "MyKey")
                            defaults.synchronize()
                            //to stop activity indicator
                            self.ActivityIndicatorLoader.stopAnimating()
                            //Go to the HomeViewController if the login is sucessful
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
                            self.present(vc!, animated: true, completion: nil)
                            registrationNumber = self.userNameField.text!
                        }
                        print(token)
                    }
                })
            }
                
            else{
                //to stop activity indicator
                self.ActivityIndicatorLoader.stopAnimating()
                //to initiate alert if the text fields are empty
                SignUpButton.isEnabled = true
                DiveInButton.isEnabled = true
                userNameField.isEnabled = true
                passwordField.isEnabled = true
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
            SignUpButton.isEnabled = true
            DiveInButton.isEnabled = true
            let alertController = UIAlertController(title: "Internet Connection not Available!", message: "Check your internet connection.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            print("Internet Connection not Available!")
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
//    //for activation of finger print authentication this function is used along with notify function
//    func fingerprintAuthenticationTwo()
//    {
//        let context = LAContext()
//        var error: NSError?
//        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics,error: &error)
//        {
//            // Device can use TouchID
//            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics,localizedReason: "Access requires authentication",reply: {(success, error) in
//                    DispatchQueue.main.async {
//                        if error != nil {
//                            switch error!._code {
//                            case LAError.Code.systemCancel.rawValue:self.notifyUser("Session cancelled",err: error?.localizedDescription)
//                            case LAError.Code.userCancel.rawValue:self.notifyUser("Please try again",err: error?.localizedDescription)
//                            case LAError.Code.userFallback.rawValue:self.notifyUser("Authentication",err: "Password option selected")
//                            // Custom code to obtain password here
//                            default:self.notifyUser("Authentication failed",err: error?.localizedDescription)
//                            }
//                        }
//                        else {
//                            //Go to the HomeViewController if the login is sucessful
//                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
//                            self.present(vc!, animated: true, completion: nil)
//                        }
//                    }
//            })
//        }
//        else {
//            // Device cannot use TouchID
//        }
//    }
//    func notifyUser(_ msg: String, err: String?) {
//        let alert = UIAlertController(title: msg,message: err,preferredStyle: .alert)
//        let cancelAction = UIAlertAction(title: "OK",style: .cancel, handler: nil)
//        alert.addAction(cancelAction)
//        self.present(alert, animated: true,completion: nil)
//    }

    //view did load function
    override func viewDidLoad() {
        super.viewDidLoad()
        ActivityIndicatorLoader.isHidden = true
        
        DiveInButton.layer.cornerRadius =  10
        SignUpButton.layer.cornerRadius =  10
        
        // for hitting return
        userNameField.delegate = self
        passwordField.delegate = self
        
        // for tapping
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard)))
        
        //parallax effect in back image
        let min = CGFloat(-30)
        let max = CGFloat(30)
        let xMotion = UIInterpolatingMotionEffect(keyPath: "layer.transform.translation.x", type: .tiltAlongHorizontalAxis)
        xMotion.minimumRelativeValue = min
        xMotion.maximumRelativeValue = max
        let yMotion = UIInterpolatingMotionEffect(keyPath: "layer.transform.translation.y", type: .tiltAlongVerticalAxis)
        yMotion.minimumRelativeValue = min
        yMotion.maximumRelativeValue = max
        let motionEffectGroup = UIMotionEffectGroup()
        motionEffectGroup.motionEffects = [xMotion,yMotion]
        imageView.addMotionEffect(motionEffectGroup)
        //for assigning value of token for last session
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        
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
    }
    // for hitting return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userNameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        return true
    }

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
        //textField.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
