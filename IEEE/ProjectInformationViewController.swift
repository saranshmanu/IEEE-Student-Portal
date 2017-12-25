//
//  ProjectInformationViewController.swift
//  IEEE Students Portal
//
//  Created by Saransh Mittal on 14/02/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit
import Alamofire

let heading = ["Details", "Members"]
let ProjectInformationLabel=["Title","Description","Created By","Date Created","Image_url","id"]

class ProjectInformationViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var ProjectImage: UIImageView!
    var specificProjectDetails=[Array<Any>]()
    var teamMembersOfTheSelectedProject = [Array<Any>]()
    var projectDelatilsOfTheSelectedProject = [Array<Any>]()
    
    @IBOutlet var ProjectInformationTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setting up the image of the project
        ProjectImage.image = ProjectDetail[number][6] as? UIImage
        //        // Do any additional setup after loading the view.
        //        let numProjectDetails = ProjectDetail[number].count - 3
        //        for i in 0...numProjectDetails{
        //            projectDelatilsOfTheSelectedProject.append([ProjectInformationLabel[i],String(describing: ProjectDetail[number][i])])
        //        }
        //        print(projectDelatilsOfTheSelectedProject)
        //        let numProjectTeamMembers = ProjectTeamMembers[number].count
        //        for i in 0...numProjectTeamMembers-1{
        //            print(ProjectTeamMembers[number][i])
        //            //teamMembersOfTheSelectedProject+=ProjectTeamMembers[number][i]
        //            //teamMembersOfTheSelectedProject.append(ProjectTeamMembers[number][i])
        //            teamMembersOfTheSelectedProject.append([ProjectTeamMembersName[number][i] as! String,ProjectTeamMembersRegistrationNumber[number][i] as! String])
        //        }
        //        print(teamMembersOfTheSelectedProject)
        //        specificProjectDetails = [projectDelatilsOfTheSelectedProject,teamMembersOfTheSelectedProject]
        //        print(specificProjectDetails
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return heading[section]
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return heading.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section==0{
            return (ProjectDetail[number].count-3)
        }
        else if section == 1 {
            return ProjectTeamMembers[number].count
        }
        else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ProjectInformationTable.dequeueReusableCell(withIdentifier: "ProjectInformationCell", for: indexPath as IndexPath) as! ProjectInformationTableViewCell
        print(indexPath.section)
        print(indexPath.row)
        if indexPath.section==0{
            cell.Label?.text = String(describing: ProjectInformationLabel[indexPath.row])
            cell.Value?.text = String(describing: ProjectDetail[number][indexPath.row])
        }
        else if indexPath.section==1 && ProjectTeamMembers[number].count != 0{
            cell.Label?.text = "String"//String(describing: ProjectTeamMembers[number][indexPath.row][0])
            cell.Value?.text = "String"//String(describing: ProjectTeamMembers[number][indexPath.row][1])
        }
        return cell
    }
    
    //     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    //        return heading.count
    //     }
    //     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        return (ProjectDetail[number].count-2)
    //     }
    //     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let cell = ProjectInformationTable.dequeueReusableCell(withIdentifier: "ProjectInformationCell", for: indexPath as IndexPath) as! ProjectInformationTableViewCell
    //        cell.Label?.text = String(describing: ProjectInformationLabel[indexPath.row])
    //        cell.Value?.text = String(describing: ProjectDetail[number][indexPath.row])
    //     return cell
    //     }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
