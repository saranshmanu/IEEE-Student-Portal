//
//  ProjectsViewController.swift
//  IEEE Students Portal
//
//  Created by Saransh Mittal on 14/02/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage

var ProjectDetail=[Array<Any>]()
var ProjectInformationLabel=["Title","Description","Created By","Date Created","Image_url","id"]
var ProjectTeamMembers = [Array<Any>]()
var number = 0
var ProjectImage = [UIImage]()

class ProjectsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var ProjectListTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Alamofire.request("https://ieeevitportal.herokuapp.com/project",method:.get, headers: ["x-access-token":token]).responseJSON {response in
            let swiftyJsonVar = JSON(response.result.value!)
            let number=swiftyJsonVar["projects"].count
            for i in 0...number-1{
                //["Title","Description","Created By","Date Created","Image_url","id"]
                ProjectDetail.append([String(describing: swiftyJsonVar["projects"][i]["title"]),String(describing: swiftyJsonVar["projects"][i]["desc"]),swiftyJsonVar["projects"][i]["created_by"]["name"],String(describing: swiftyJsonVar["projects"][i]["created"]),swiftyJsonVar["projects"][i]["image_url"],String(describing: swiftyJsonVar["projects"][i]["_id"])])
                //for fetching the image and savinf it in ProjectImage
                Alamofire.request(String(describing: swiftyJsonVar["projects"][i]["image_url"]),method:.get, headers: ["x-access-token":token]).responseImage { img in
                    //ProjectImage.append(img.result.value!)
                }
                //for fetching the team member list and save it in projectteam member list
                let num = swiftyJsonVar["projects"][i]["team_other"].count
                var team = [Array<Any>]()
                if num != 0{
                    for j in 0...num-1{
                        team.append([swiftyJsonVar["projects"][i]["team_other"][j]["name"],swiftyJsonVar["projects"][i]["team_other"][j]["regno"]])
                    }
                }
                ProjectTeamMembers.append(team)
            }
            print(ProjectDetail)
            print(ProjectTeamMembers)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                self.ProjectListTable.reloadData()
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProjectDetail.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ProjectListTable.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath as IndexPath) as! ProjectsTableViewCell
        cell.ProjectName?.text = String(describing: ProjectDetail[indexPath.row][0])
        Alamofire.request(String(describing: ProjectDetail[indexPath.row][4]),method:.get, headers: ["x-access-token":token]).responseImage { img in
            cell.ProjectImage?.image = img.result.value
        }
        //cell.ProjectImage?.image = ProjectImage[indexPath.row]// as? Image
        return cell
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let Accept = UITableViewRowAction(style: .normal, title: "Accept") { action, index in
            //actions to be written down
            let id = String(describing: ProjectDetail[indexPath.row][5])
            Alamofire.request("https://ieeevitportal.herokuapp.com/project", method: .put, parameters: ["id":id], headers: ["x-access-token":token]).responseJSON{response in print(response)
                let swiftyJsonVar = JSON(response.result.value!)
                if(swiftyJsonVar["__v"]==0){
                    let alertController = UIAlertController(title: "Success", message: "Congratulations! You are a part of the project now.", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                else{
                    let alertController = UIAlertController(title: "Failure", message: "Something went wrong.Please try again", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        Accept.backgroundColor = .blue
        return [Accept]
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        number = indexPath.row
        ProjectListTable.deselectRow(at: indexPath as IndexPath, animated: true)
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
