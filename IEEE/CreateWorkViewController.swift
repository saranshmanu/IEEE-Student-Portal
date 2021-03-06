//
//  CreateWorkViewController.swift
//  IEEE Students Portal
//
//  Created by Saransh Mittal on 10/02/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class CreateWorkViewController: UIViewController,UITextFieldDelegate {
    var counter = 1
    @IBOutlet weak var workTitle: UITextField!
    @IBOutlet weak var workDescription: UITextField!
    @IBOutlet weak var workDateAndTime: UIDatePicker!
    @IBOutlet weak var workYear: UIButton!
    @IBOutlet weak var Post: UIButton!
    
    @IBAction func GoBackFromCreateWork(_ sender: Any) {
        //Go to the HomeViewController if the login is sucessful
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
        self.present(vc!, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CreateWorkViewController.dismissKeyboard)))
        
        workYear.setTitle(String(counter)+" year",for: .normal)
    }
    func dismissKeyboard() {
        workTitle.resignFirstResponder()
        workDescription.resignFirstResponder()
    }
    @IBAction func yearAllocatedTo(_ sender: Any) {
        if counter == 2{
            counter=1
            workYear.setTitle(String(counter)+" year",for: .normal)
        }
        else{
            counter += 1
            workYear.setTitle(String(counter)+" year",for: .normal)
        }
    }
    @IBAction func Post(_ sender: Any)
    {
        //to change the format of the date into ISO8601 format
        let dateFormatter = DateFormatter()
        let enUSPosixLocale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.locale = enUSPosixLocale as Locale!
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let iso8601String = dateFormatter.string(from: workDateAndTime.date as Date) + ".132Z"
        print(iso8601String)
        //to generate work
        let request = ["title":workTitle.text!, "desc":workDescription.text!, "vol_level":[counter], "due":iso8601String] as [String : Any]
        if workTitle.text != "" && workDescription.text != ""
            {
            Alamofire.request("https://ieeevitportal.herokuapp.com/work/voluntary", method: .post, parameters: request, encoding: JSONEncoding.default, headers: ["x-access-token":token]).response
                {response in let swiftyJsonVar = JSON(response.data as Any)
                    print(swiftyJsonVar)
                    if swiftyJsonVar["code"]=="1"
                    {
                        let alertController = UIAlertController(title: "Error", message: "You are not authorised to generate the task", preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else{
                        //Go to the HomeViewController if the task generation is sucessful
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
                        self.present(vc!, animated: true, completion: nil)
                        let alertController = UIAlertController(title: "Success", message: "Task successfully generated", preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                        

                    }
                }
            }
        else{
                let alertController = UIAlertController(title: "Error", message: "Fields are empty", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
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
