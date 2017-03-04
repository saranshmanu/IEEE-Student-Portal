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

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    
    @IBOutlet weak var segmentedControl: TwicketSegmentedControl!
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    var segmentNumber = 1  // 1:Profile,2:Work,3:Projects
    var skills = ""
    var userInformation=[String]()
    var userWork=[Array<Any>]()
    var userProject=[Array<Any>]()
    
    let userInformationLabel=["EMAIL","EMAIL","GENDER","ROOM NUMBER","BLOCK","CONTACT","PROGRAM","SKILLS"]
    
    @IBAction func projectButton(_ sender: Any) {
        tabBarController?.selectedIndex = 4
    }
    @IBAction func workButton(_ sender: Any) {
        tabBarController?.selectedIndex = 0
    }
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var RegistrationNumberLabel: UILabel!
    @IBOutlet weak var ProfileTable: UITableView!
    @IBOutlet weak var ProfileImage: UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //segment control


        //initiates activity Indicator
        ActivityIndicator.startAnimating()
        // Do any additional setup after loading the view.
        self.ProfileImage.layer.masksToBounds=true
        self.ProfileImage.layer.cornerRadius = 70.0
        
        Alamofire.request("https://ieeevitportal.herokuapp.com/users/profile",method:.get, headers: ["x-access-token":token]).responseJSON { response in
            //print(response)
            
            let swiftyJsonVar = JSON(response.result.value!)
            //for saving profile details of the user
            self.NameLabel.text = String(describing: swiftyJsonVar["name"])
            self.RegistrationNumberLabel.text = String(describing: swiftyJsonVar["regno"])
            let number=swiftyJsonVar["skill"].count
            for i in 0...number-1{
                //self.skills.append(String(describing: swiftyJsonVar["skill"][i]["skill"]))
                self.skills += String(describing: swiftyJsonVar["skill"][i]["skill"])+", "
            }
            let urlImage:String="https://ieeevitportal.herokuapp.com/users/profile/image?regno="+self.RegistrationNumberLabel.text!
            self.userInformation.append(String(describing:swiftyJsonVar["email"][0]["email"]))
            self.userInformation.append(String(describing:swiftyJsonVar["email"][1]["email"]))
            self.userInformation.append(String(describing:swiftyJsonVar["gender"]))
            self.userInformation.append(String(describing:swiftyJsonVar["room"]))
            self.userInformation.append(String(describing:swiftyJsonVar["block"]))
            self.userInformation.append(String(describing:swiftyJsonVar["phone"][0]["phone"]))
            self.userInformation.append(String(describing:swiftyJsonVar["programme"]))
            self.userInformation.append(self.skills)
            print(self.userInformation)
            
            //for saving works of the user in the userWork array
            let numberWork = swiftyJsonVar["work_voluntary"].count
            if numberWork != 0{
                for i in 0...numberWork-1{
                    self.userWork.append([swiftyJsonVar["work_voluntary"][i]["title"],swiftyJsonVar["work_voluntary"][i]["desc"],swiftyJsonVar["work_voluntary"][i]["allotted_by"]["name"],swiftyJsonVar["work_voluntary"][i]["allotted_by"]["regno"]])
                }
            }
            print(self.userWork)
            //for saving projects of the user in the userProject array
            let numberProjects = swiftyJsonVar["projects"].count
            if numberProjects != 0{
                for i in 0...numberProjects-1{
                    self.userProject.append([swiftyJsonVar["projects"][i]["title"],swiftyJsonVar["projects"][i]["desc"],swiftyJsonVar["projects"][i]["created_by"],swiftyJsonVar["projects"][i]["created"]])
                }
            }
            print(self.userProject)
            //to get and display profile image
            Alamofire.request(String(urlImage),method:.get, headers: ["x-access-token":token]).responseImage { img in
                self.ProfileImage.image = img.result.value 
            }
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4) {
            self.ProfileTable.reloadData()
            self.ActivityIndicator.stopAnimating()

        }
        //stops activity indicator
    }
  
    
    
    //Profile Table
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentNumber==1{
            return userInformation.count
        }
        else if segmentNumber==2{
            return userWork.count
        }
        else{
            return userProject.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ProfileTable.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath as IndexPath) as! ProfileTableViewCell
        
        if segmentNumber==1{
            cell.InformationType?.text = userInformationLabel[indexPath.row]
            cell.Information?.text = userInformation[indexPath.row]
            return cell
        }
        else if segmentNumber==2{
            cell.InformationType?.text = String(describing: userWork[indexPath.row][0])
            cell.Information?.text = String(describing: userWork[indexPath.row][1])
            return cell
        }
        else{
            cell.InformationType?.text = String(describing: userProject[indexPath.row][0])
            cell.Information?.text = String(describing: userProject[indexPath.row][1])
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ProfileTable.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
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
