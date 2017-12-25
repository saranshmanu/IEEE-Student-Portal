//
//  ProfileViewController.swift
//  Final Login
//
//  Created by Saransh Mittal on 29/01/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage
import TwicketSegmentedControl
import MessageUI


class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TwicketSegmentedControlDelegate, MFMailComposeViewControllerDelegate
{

    override func viewDidAppear(_ animated: Bool) {
        let imageHeight = ProfileImage.frame.size.height // to get the heightof the image according to the size of the screen of the iphone UIScreen.main.bounds.height
        self.ProfileImage.clipsToBounds = true
        self.ProfileImage.layer.cornerRadius = imageHeight/2
    }
    var userGeneral = [Array<Any>]()
    var userEmail = [Array<Any>]()
    var userPhone = [Array<Any>]()
    var userSkills = [Array<Any>]()
    var userInformation=[Array<Any>]()
    var userWork=[Array<Any>]()
    var userProject=[Array<Any>]()
    
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    var segmentNumber = 0  // 1:Profile,2:Work,3:Projects

    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var RegistrationNumberLabel: UILabel!
    @IBOutlet weak var ProfileTable: UITableView!
    @IBOutlet weak var ProfileImage: UIImageView!

    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var segmentView: UIView!
    override func viewDidLoad(){
        super.viewDidLoad()
        
        //initiates activity Indicator
        ActivityIndicator.startAnimating()
        
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: light_blue,NSFontAttributeName : UIFont(name : "Avenir Next", size: 21)!]
        
        ProfileTable.delegate = self
        ProfileTable.dataSource = self
        
        if Reachability.isConnectedToNetwork() == true {
            //segment control
            let titles = ["Personal", "Work", "Project"]
            
            let segmentedControl = TwicketSegmentedControl(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
            segmentedControl.delegate = self
            segmentedControl.setSegmentItems(titles)
            self.segmentView.addSubview(segmentedControl)

            // Do any additional setup after loading the view.
            Alamofire.request("https://ieeevitportal.herokuapp.com/users/profile",method:.get, headers: ["x-access-token":token]).responseJSON { response in
                
                if response.result.isSuccess {
                    let swiftyJsonVar = JSON(response.result.value!)
                    //for saving name and registration number details of the user
                    self.NameLabel.text = String(describing: swiftyJsonVar["name"])
                    self.RegistrationNumberLabel.text = String(describing: swiftyJsonVar["regno"])
                    
                    //for profile image of the profile tab
                    let urlImage:String="https://ieeevitportal.herokuapp.com/users/profile/image?regno="+self.RegistrationNumberLabel.text!
                    Alamofire.request(String(urlImage),method:.get, headers: ["x-access-token":token]).responseImage { img in
                        self.ProfileImage.image = img.result.value
                        self.ProfileTable.reloadData()
                    }
                    
                    //for saving user general information in the userGeneral array
                    self.userGeneral.append(["GENDER",String(describing:swiftyJsonVar["gender"]),"Gender"])
                    self.userGeneral.append(["ROOM NUMBER",String(describing:swiftyJsonVar["room"]),"Room Number"])
                    self.userGeneral.append(["BLOCK",String(describing:swiftyJsonVar["block"]),"Block"])
                    self.userGeneral.append(["PROGRAMME",String(describing:swiftyJsonVar["programme"]),"Programme"])
                    
                    //for saving user emails in the userEmail array
                    let emailNumber = swiftyJsonVar["email"].count
                    if emailNumber != 0{
                        for i in 0...emailNumber-1{
                            self.userEmail.append(["EMAIL",String(describing:swiftyJsonVar["email"][i]["email"]),"Email"])
                            self.ProfileTable.reloadData()
                        }
                    }
                    
                    //for saving user phone numbers in the userPhone array
                    let numberPhone = swiftyJsonVar["phone"].count
                    if numberPhone != 0{
                        for i in 0...numberPhone-1{
                            self.userPhone.append(["CONTACT",String(describing:swiftyJsonVar["phone"][i]["phone"]),"Contact"])
                            self.ProfileTable.reloadData()
                        }
                    }
                    //for saving user skills in the userSkills array
                    let numberSkills=swiftyJsonVar["skill"].count
                    if numberSkills != 0{
                        for i in 0...numberSkills-1{
                            self.userSkills.append(["SKILLS",String(describing: swiftyJsonVar["skill"][i]["skill"]),"Skills"])
                            self.ProfileTable.reloadData()
                        }
                    }
                    else{
                        self.userSkills.append(["SKILLS","nil","Skills"])
                        self.ProfileTable.reloadData()
                    }
                    self.userInformation = self.userGeneral + self.userPhone + self.userEmail + self.userSkills
                    print(self.userInformation)
                    
                    //for saving works of the user in the userWork array
                    let numberWork = swiftyJsonVar["work_voluntary"].count
                    if numberWork != 0{
                        for i in 0...numberWork-1{
                            let z = [swiftyJsonVar["work_voluntary"][i]["title"],swiftyJsonVar["work_voluntary"][i]["desc"],swiftyJsonVar["work_voluntary"][i]["allotted_by"]["name"],swiftyJsonVar["work_voluntary"][i]["allotted_by"]["regno"]]
                            self.userWork.append(z)
                            self.ProfileTable.reloadData()
                        }
                    }
                    print(self.userWork)
                    //for saving projects of the user in the userProject array
                    let numberProjects = swiftyJsonVar["projects"].count
                    if numberProjects != 0{
                        for i in 0...numberProjects-1{
                            self.userProject.append([swiftyJsonVar["projects"][i]["title"],swiftyJsonVar["projects"][i]["desc"],swiftyJsonVar["projects"][i]["created_by"],swiftyJsonVar["projects"][i]["created"]])
                            self.ProfileTable.reloadData()
                        }
                    }
                    print(self.userProject)
                    
                    //stops activity Indicator
                    self.ActivityIndicator.stopAnimating()
                } else {
                    self.ActivityIndicator.stopAnimating()
                }
            }
        }
        else{
            //to stop activity indicator
            self.ActivityIndicator.stopAnimating()
            let alertController = UIAlertController(title: "Internet Connection not Available!", message: "Check your internet connection.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            print("Internet Connection not Available!")
        }
    }
  
    //Profile Table

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if segmentNumber==0{
            return userInformation.count
        }
        else if segmentNumber==1{
            return userWork.count
        }
        else{
            return userProject.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ProfileTable.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath as IndexPath) as! ProfileTableViewCell
        if segmentNumber==0{
            cell.InformationType?.text = String(describing: userInformation[indexPath.row][0])
            cell.Information?.text = String(describing: userInformation[indexPath.row][1])
            cell.Icon.image = UIImage(named : String(describing: userInformation[indexPath.row][2]))
            return cell
        }
        else if segmentNumber==1{
            cell.InformationType?.text = String(describing: userWork[indexPath.row][0])
            cell.Information?.text = String(describing: userWork[indexPath.row][1])
            cell.Icon.image = UIImage(named : "Tick")

            return cell
        }
        else{
            cell.InformationType?.text = String(describing: userProject[indexPath.row][0])
            cell.Information?.text = String(describing: userProject[indexPath.row][1])
            cell.Icon.image = UIImage(named : "Green Tick")

            return cell
        }
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if segmentNumber == 0{
            return 1//userInformation.count
        }
        else if segmentNumber == 1{
            return 1
        }
        else{
            return 1
        }
    }

    // For dissmissing the mail view controller on cacel button
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ProfileTable.deselectRow(at: indexPath as IndexPath, animated: true)
        if String(describing: userInformation[indexPath.row][0]) == "CONTACT" {
            let optionMenu = UIAlertController(title: nil, message: "What do you want to do?", preferredStyle: UIAlertControllerStyle.actionSheet)
            let defaultAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let Add = UIAlertAction(title: "Add contact", style: .default, handler: { (action) -> Void in
                let alertController = UIAlertController(title: "Contact Number", message: "Please enter your contact number to be added", preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
                    if let field = alertController.textFields?[0] {
                        // store your data
                        UserDefaults.standard.set(field.text, forKey: "Contact")
                        UserDefaults.standard.synchronize()
                        //adding new contact to the backend
                        let url = "https://ieeevitportal.herokuapp.com/users/profile/phone"
                        let parameters = ["phone":field.text!]
                        let header = ["x-access-token":token]
                        Alamofire.request(url, method: .put, parameters: parameters, headers: header).responseJSON{
                            response in
                            print(response)
                            let swiftyJsonVar = JSON(response.result.value!)
                            if swiftyJsonVar["code"] == "0"
                            {
                                //to initiate alert if login is unsuccesfull
                                let alertController = UIAlertController(title: "Success", message: "Contact number added successfully", preferredStyle: .alert)
                                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                alertController.addAction(defaultAction)
                                self.present(alertController, animated: true, completion: nil)
                            }
                            else{
                                //to initiate alert if login is unsuccesfull
                                let alertController = UIAlertController(title: "Failure", message: "Contact number was not added. Please try again after some time.", preferredStyle: .alert)
                                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                alertController.addAction(defaultAction)
                                self.present(alertController, animated: true, completion: nil)
                            }
                        }
                    }
                    else {
                        // user did not fill field
                    }
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
                alertController.addTextField { (textField) in
                    textField.placeholder = "Email"
                }
                alertController.addAction(confirmAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)

            })
            //to make phone calls directly from the profile
            let Call = UIAlertAction(title: "Call", style: .default, handler: { (action) -> Void in
                var phoneNumber:Optional = self.userInformation[indexPath.row][1]
                if let callNumber = phoneNumber {
                    let aURL = NSURL(string: "telprompt://\(callNumber)")
                    if UIApplication.shared.canOpenURL(aURL as! URL) {
                        UIApplication.shared.openURL(aURL as! URL)
                    } else {
                        print("error")
                    }
                }
                else {
                    print("error")}
            })
            optionMenu.addAction(defaultAction)
            optionMenu.addAction(Add)
            optionMenu.addAction(Call)
            self.present(optionMenu, animated: true, completion: nil)
        }
        else if String(describing: userInformation[indexPath.row][0]) == "EMAIL"{
            let optionMenu = UIAlertController(title: nil, message: "What do you want to do?", preferredStyle: UIAlertControllerStyle.actionSheet)
            let defaultAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let Add = UIAlertAction(title: "Add email", style: .default, handler: { (action) -> Void in
                let alertController = UIAlertController(title: "Email", message: "Please enter your email to be added", preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
                    if let field = alertController.textFields?[0] {
                        // store your data
                        UserDefaults.standard.set(field.text, forKey: "Email")
                        UserDefaults.standard.synchronize()
                        //adding new email to the backend
                        let url = "https://ieeevitportal.herokuapp.com/users/profile/email"
                        let parameters = ["email":field.text!]
                        let header = ["x-access-token":token]
                        Alamofire.request(url, method: .put, parameters: parameters, headers: header).responseJSON{
                            response in
                            print(response)
                            let swiftyJsonVar = JSON(response.result.value!)
                            if swiftyJsonVar["code"] == "0"
                            {
                                //to initiate alert if login is unsuccesfull
                                let alertController = UIAlertController(title: "Success", message: "Email added successfully", preferredStyle: .alert)
                                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                alertController.addAction(defaultAction)
                                self.present(alertController, animated: true, completion: nil)
                            }
                            else{
                                //to initiate alert if login is unsuccesfull
                                let alertController = UIAlertController(title: "Failure", message: "Email was not added. Please try again after some time.", preferredStyle: .alert)
                                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                alertController.addAction(defaultAction)
                                self.present(alertController, animated: true, completion: nil)
                            }
                        }
                    }
                    else {
                        // user did not fill field
                    }
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
                alertController.addTextField { (textField) in
                    textField.placeholder = "Email"
                }
                alertController.addAction(confirmAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            })

            //to send email directly from profile
            let Mail = UIAlertAction(title: "Send Email", style: .default, handler: { (action) -> Void in
                if !MFMailComposeViewController.canSendMail() {
                    //to initiate alert if login is unsuccesfull
                    let alertController = UIAlertController(title: "Error", message: "Mail services are not available", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                    print("Mail services are not available")
                    return
                }
                else{
                    let composeVC = MFMailComposeViewController()
                    composeVC.mailComposeDelegate = self
                    // Configure the fields of the interface.
                    composeVC.setToRecipients([String(describing: self.userInformation[indexPath.row][1])])
                    composeVC.setSubject("")
                    composeVC.setMessageBody("", isHTML: false)
                    // Present the view controller modally.
                    self.present(composeVC, animated: true, completion: nil)
                }
            })
            optionMenu.addAction(Mail)
            optionMenu.addAction(defaultAction)
            optionMenu.addAction(Add)
            self.present(optionMenu, animated: true, completion: nil)
        }
        else if String(describing: userInformation[indexPath.row][0]) == "SKILLS"{
            let optionMenu = UIAlertController(title: nil, message: "What do you want to do?", preferredStyle: UIAlertControllerStyle.actionSheet)
            let defaultAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let Add = UIAlertAction(title: "Add more skills to your profile", style: .default, handler: { (action) -> Void in
                let alertController = UIAlertController(title: "Skills", message: "Please enter your skill to be added", preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
                    if let field = alertController.textFields?[0] {
                        // store your data
                        UserDefaults.standard.set(field.text, forKey: "Skills")
                        UserDefaults.standard.synchronize()
                        //adding new skill to the backend
                        let url = "https://ieeevitportal.herokuapp.com/users/skill"
                        _ = field
                        let parameters = ["id":field]
                        let header = ["x-access-token":token]
                        Alamofire.request(url, method: .put, parameters: parameters, headers: header).responseJSON{
                            response in
                            print(response)
                            let swiftyJsonVar = JSON(response.result.value!)
                            if swiftyJsonVar["code"] == "0"
                            {
                                //to initiate alert if login is unsuccesfull
                                let alertController = UIAlertController(title: "Success", message: "Skill registrered successfully", preferredStyle: .alert)
                                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                alertController.addAction(defaultAction)
                                self.present(alertController, animated: true, completion: nil)
                            }
                            else{
                                //to initiate alert if login is unsuccesfull
                                let alertController = UIAlertController(title: "Failure", message: "Skill was not registered. Please try again after some time.", preferredStyle: .alert)
                                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                alertController.addAction(defaultAction)
                                self.present(alertController, animated: true, completion: nil)
                            }
                        }
                    }
                    else {
                        // user did not fill field
                    }
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
                alertController.addTextField { (textField) in
                    textField.placeholder = "Email"
                }
                alertController.addAction(confirmAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            })
            optionMenu.addAction(defaultAction)
            optionMenu.addAction(Add)
            self.present(optionMenu, animated: true, completion: nil)
        }
        else{
            print("other")
        }
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    // MARK: Segmented Control
    
    func didSelect(_ segmentIndex: Int) {
        self.segmentNumber = segmentIndex
        if segmentIndex==0{
            ProfileTable.reloadData()
            print("0")
        }
        else if segmentIndex==1{
            ProfileTable.reloadData()
            print("1")
        }
        else if segmentIndex==2{
            ProfileTable.reloadData()
            print("2")
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
