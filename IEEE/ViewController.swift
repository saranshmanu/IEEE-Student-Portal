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
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var DiveInButton: UIButton!
    @IBOutlet weak var SignUpButton: UIButton!
    
    @IBAction func loginAction(_ sender: Any) {
        print("login taking place")
        ActivityIndicatorLoader.startAnimating()
        if userNameField.text != "" && passwordField.text != ""
        {
            //almofire request to server
            Alamofire.request("https://ieeevitportal.herokuapp.com/auth/login", method: .post, parameters: ["username" : userNameField.text!,"password": passwordField.text!]).responseJSON(completionHandler: {response in
                if((response.result.value) != nil) {
                    let swiftyJsonVar = JSON(response.result.value!)
                    token = String(describing: swiftyJsonVar["token"])
                    
                    if swiftyJsonVar["code"]=="1"
                    {
                        print("Login not successful")
                        //to stop activity indicator
                        self.ActivityIndicatorLoader.stopAnimating()
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
            let alertController = UIAlertController(title: "Error", message: "Please your VIT registration number and password.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    //for activation of finger print authentication this function is used along with notify function
    func fingerprintAuthenticationTwo()
    {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics,error: &error)
        {
            // Device can use TouchID
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics,localizedReason: "Access requires authentication",reply: {(success, error) in
                    DispatchQueue.main.async {
                        if error != nil {
                            switch error!._code {
                            case LAError.Code.systemCancel.rawValue:self.notifyUser("Session cancelled",err: error?.localizedDescription)
                            case LAError.Code.userCancel.rawValue:self.notifyUser("Please try again",err: error?.localizedDescription)
                            case LAError.Code.userFallback.rawValue:self.notifyUser("Authentication",err: "Password option selected")
                            // Custom code to obtain password here
                            default:self.notifyUser("Authentication failed",err: error?.localizedDescription)
                            }
                        }
                        else {
                            //Go to the HomeViewController if the login is sucessful
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
                            self.present(vc!, animated: true, completion: nil)
                        }
                    }
            })
        }
        else {
            // Device cannot use TouchID
        }
    }
    func notifyUser(_ msg: String, err: String?) {
        let alert = UIAlertController(title: msg,message: err,preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK",style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true,completion: nil)
    }

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
        let defaults = UserDefaults.standard
        token = defaults.string(forKey: "MyKey")!
        
        if(token != "")
        {
            self.fingerprintAuthenticationTwo()
        }
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
