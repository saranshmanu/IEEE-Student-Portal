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

class OtherMemberProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var RegistrationNumberLabel: UILabel!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var ProfileTable: UITableView!
    @IBOutlet weak var ProfileImage: UIImageView!
    var skills = ""
    var userInformation=[String]()
    let userInformationLabel=["EMAIL","EMAIL","GENDER","ROOM NUMBER","BLOCK","CONTACT","PROGRAM","SKILLS"]

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.ProfileImage.layer.masksToBounds=true
        self.ProfileImage.layer.cornerRadius = 50.0
        
        Alamofire.request(("https://ieeevitportal.herokuapp.com/users/profile?regno="+registrationNumber),method:.get, headers: ["x-access-token":token]).responseJSON { response in
            let swiftyJsonVar = JSON(response.result.value!)
            self.NameLabel.text = String(describing: swiftyJsonVar["name"])
            self.RegistrationNumberLabel.text = String(describing: swiftyJsonVar["regno"])
            let number=swiftyJsonVar["skill"].count
            for i in 0...number{
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
            //to get and display profile image
            Alamofire.request(String(urlImage),method:.get, headers: ["x-access-token":token]).responseImage { img in
                self.ProfileImage.image = img.result.value
            }
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.ProfileTable.reloadData()
        }
    }
    
    
    
    //Profile Table
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userInformation.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ProfileTable.dequeueReusableCell(withIdentifier: "OtherUserProfileCell", for: indexPath as IndexPath) as! ProfileTableViewCell
        cell.InformationType?.text = userInformationLabel[indexPath.row]
        cell.Information?.text = userInformation[indexPath.row]
        return cell
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
