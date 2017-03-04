//
//  UsersViewController.swift
//  Final Login
//
//  Created by Saransh Mittal on 06/02/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage

var memberDetails = [[String(),String()]]
var memberImage = [UIImage]()
class UsersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var memberDetailTableCell: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //Activity indicator initiates
        ActivityIndicator.startAnimating()
        //to print all the users in the ieee login
         Alamofire.request("https://ieeevitportal.herokuapp.com/users/profiles",method:.get, headers: ["x-access-token":token]).responseJSON {response in
            print(response)
            let swiftyJsonVar = JSON(response.result.value!)
            let number=swiftyJsonVar["users"].count
            print(number)
            for i in 0...number-1{
                memberDetails.append([String(describing: swiftyJsonVar["users"][i]["name"]),String(describing: swiftyJsonVar["users"][i]["regno"])])
                Alamofire.request(String(describing: swiftyJsonVar["projects"][i]["image_url"]),method:.get, headers: ["x-access-token":token]).responseImage {
                    img in
                    //memberImage.append(img.result.value!)
                }
            }
         }
        memberDetails.remove(at: 0)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            self.memberDetailTableCell.reloadData()
            print(memberDetails)
            self.ActivityIndicator.stopAnimating()

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK:  UITextFieldDelegate Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberDetails.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = memberDetailTableCell.dequeueReusableCell(withIdentifier: "TextCellUser", for: indexPath as IndexPath) as! UsersTableViewCell
        cell.NameLabel?.text = memberDetails[indexPath.row][0]
        cell.RegistrationNumberLabel?.text = memberDetails[indexPath.row][1]
        let urlImage:String="https://ieeevitportal.herokuapp.com/users/profile/image?regno="+memberDetails[indexPath.row][1]
        Alamofire.request(String(urlImage),method:.get, headers: ["x-access-token":token]).responseImage { img in
            cell.ProfileImageLabel?.image = img.result.value
        }
        //cell.ProfileImageLabel?.image = memberImage[indexPath.row]
        cell.ProfileImageLabel.layer.cornerRadius=20.0
        cell.ProfileImageLabel.clipsToBounds=true
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        memberDetailTableCell.deselectRow(at: indexPath as IndexPath, animated: true)
        registrationNumber = memberDetails[indexPath.row][1]
        print(memberDetails[indexPath.row][1])
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtherMemberProfileViewController")
        self.present(vc!, animated: true, completion: nil)
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
