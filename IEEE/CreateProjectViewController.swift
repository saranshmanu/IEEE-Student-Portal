//
//  CreateProjectViewController.swift
//  IEEE
//
//  Created by Saransh Mittal on 12/03/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CreateProjectViewController: UIViewController {

    @IBOutlet weak var generateProjectButton: UIButton!
    @IBOutlet weak var urlOfTheImage: UITextField!
    @IBOutlet weak var DescriptionOfTheProject: UITextField!
    @IBOutlet weak var titleOfTheProject: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        generateProjectButton.layer.cornerRadius = 10
        //to dismiss keyboard
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CreateProjectViewController.dismissKeyboard)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func generateProjectButtonAction(_ sender: Any) {
        generateProjectButton.isEnabled = false
        Alamofire.request("https://ieeevitportal.herokuapp.com/project", method: .post, parameters: ["title":titleOfTheProject.text!,"desc":DescriptionOfTheProject.text!,"image_url":urlOfTheImage.text!], headers: ["x-access-token":token]).responseJSON{
            response in print(response)
            let swiftyJsonVar = JSON(response.data as Any)
            if swiftyJsonVar["code"]=="0"
            {
                self.generateProjectButton.isEnabled = true
                //Go to the HomeViewController if the project generation is sucessful
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
                self.present(vc!, animated: true, completion: nil)
                let alertController = UIAlertController(title: "Success", message: "Project successfully created.", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
            else{
                self.generateProjectButton.isEnabled = true
                let alertController = UIAlertController(title: "Failure", message: "Something went wrong! Project not created.", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
            print(response)
        }
    }
    // for hitting return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        urlOfTheImage.resignFirstResponder()
        DescriptionOfTheProject.resignFirstResponder()
        titleOfTheProject.resignFirstResponder()
        return true
    }
    func dismissKeyboard() {
        titleOfTheProject.resignFirstResponder()
        DescriptionOfTheProject.resignFirstResponder()
        urlOfTheImage.resignFirstResponder()
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
