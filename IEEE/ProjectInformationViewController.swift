//
//  ProjectInformationViewController.swift
//  IEEE Students Portal
//
//  Created by Saransh Mittal on 14/02/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit

let heading = ["Details", "Members"]
var specificProjectDetails = [Any]()

class ProjectInformationViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet var ProjectInformationTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        var teamMembersOfTheSelectedProject = [[String(),String()]]
//        var projectDelatilsOfTheSelectedProject = [[String(),String()]]
//        let numProjectDetails = ProjectDetail[number].count - 3
//        for i in 0...numProjectDetails{
//            projectDelatilsOfTheSelectedProject.append([ProjectInformationLabel[i] as! String,ProjectDetail[number][i] as! String])
//        }
//        print(projectDelatilsOfTheSelectedProject)
////        let numProjectTeamMembers = ProjectTeamMembers[number].count
////        for i in 0...numProjectTeamMembers{
////            teamMembersOfTheSelectedProject.append([ProjectTeamMembers[number][i][0],ProjectTeamMembers[number][i][1]])
////        }
////        print(teamMembersOfTheSelectedProject)
//        specificProjectDetails = [[projectDelatilsOfTheSelectedProject],[teamMembersOfTheSelectedProject]]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return heading[section]
//    }
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return heading.count
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return (specificProjectDetails[section] as AnyObject).count
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = ProjectInformationTable.dequeueReusableCell(withIdentifier: "ProjectInformationCell", for: indexPath as IndexPath) as! ProjectInformationTableViewCell
//            cell.Label?.text = String(describing: specificProjectDetails[indexPath.section][indexPath.row][0])
//            cell.Value?.text = String(describing: specificProjectDetails[indexPath.section][indexPath.row][1])
//        return cell
//    }

     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return heading.count
     }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (ProjectDetail[number].count-2)
     }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ProjectInformationTable.dequeueReusableCell(withIdentifier: "ProjectInformationCell", for: indexPath as IndexPath) as! ProjectInformationTableViewCell
        cell.Label?.text = String(describing: ProjectInformationLabel[indexPath.row])
        cell.Value?.text = String(describing: ProjectDetail[number][indexPath.row])
     return cell
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
