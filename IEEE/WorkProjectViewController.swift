//
//  WorkProjectViewController.swift
//  Final Login
//
//  Created by Saransh Mittal on 07/02/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class WorkProjectViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    var refreshControl: UIRefreshControl!
    var workDetailsPending = [Array<Any>]()
    var workDetailsCompleted = [Array<Any>]()
    @IBOutlet weak var workAllotmentTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //for slide down to refresh control
        refreshControl = UIRefreshControl()
        refreshControl=UIRefreshControl()
        refreshControl.backgroundColor = UIColor.black
        refreshControl.tintColor = UIColor.white
        refreshControl.attributedTitle = NSAttributedString(string :"Pull to refresh" )
        refreshControl.addTarget(self, action: #selector(WorkProjectViewController.refresh), for: UIControlEvents.valueChanged)
        workAllotmentTable.addSubview(refreshControl)
        //for fetching JSON request
        Alamofire.request("https://ieeevitportal.herokuapp.com/work/voluntary",method:.get, headers: ["x-access-token":token]).responseJSON {response in
            let swiftyJsonVar = JSON(response.result.value!)
            let number=swiftyJsonVar["work"].count
            print(number)
            for i in 0...number-1{
                if(String(describing: swiftyJsonVar["work"][i]["status"])=="verified"){
                }
                else{
                    self.workDetailsPending.append([String(describing: swiftyJsonVar["work"][i]["title"]),String(describing: swiftyJsonVar["work"][i]["desc"]),String(describing: swiftyJsonVar["work"][i]["allotted_by"]["name"]),String(describing: swiftyJsonVar["work"][i]["status"]),String(describing: swiftyJsonVar["work"][i]["due"]),String(describing: swiftyJsonVar["work"][i]["created"]),String(describing: swiftyJsonVar["work"][i]["_id"])])
                }
            }
            print(self.workDetailsPending)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                self.workAllotmentTable.reloadData()
            }
        }
    }
    func refresh(){
        //for deleting all data int the arrays
        self.workDetailsPending.removeAll()
        self.workDetailsCompleted.removeAll()
        //for fetching JSON request
        Alamofire.request("https://ieeevitportal.herokuapp.com/work/voluntary",method:.get, headers: ["x-access-token":token]).responseJSON {response in
            let swiftyJsonVar = JSON(response.result.value!)
            let number=swiftyJsonVar["work"].count
            print(number)
            for i in 0...number-1{
                if(String(describing: swiftyJsonVar["work"][i]["status"])=="verified"){
                    }
                else{
                    self.workDetailsPending.append([String(describing: swiftyJsonVar["work"][i]["title"]),String(describing: swiftyJsonVar["work"][i]["desc"]),String(describing: swiftyJsonVar["work"][i]["allotted_by"]["name"]),String(describing: swiftyJsonVar["work"][i]["status"]),String(describing: swiftyJsonVar["work"][i]["due"]),String(describing: swiftyJsonVar["work"][i]["created"]),String(describing: swiftyJsonVar["work"][i]["_id"])])
                    }
            }
        print(self.workDetailsPending)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.workAllotmentTable.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK:  UITextFieldDelegate Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return workDetailsPending.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = workAllotmentTable.dequeueReusableCell(withIdentifier: "WorkCell", for: indexPath as IndexPath) as! WorkProjectTableViewCell
        
        cell.WorkDescriptionLabel?.text = String(describing: workDetailsPending[indexPath.row][1])
        if(String(describing: workDetailsPending[indexPath.row][3])=="verified"){
            cell.StatusLabel.backgroundColor = .blue}
        else if(String(describing: workDetailsPending[indexPath.row][3])=="completed"){
            cell.StatusLabel.backgroundColor = .green}
        else{
            cell.StatusLabel.backgroundColor = .red}
        cell.StatusLabel.layer.cornerRadius=4.0
        cell.StatusLabel.clipsToBounds=true
        cell.WorkTitleLabel?.text = String(describing: workDetailsPending[indexPath.row][0])
        cell.AllotedDate?.text = String(String(describing: workDetailsPending[indexPath.row][5]).characters.prefix(10))
        cell.DeadlineDate?.text = String(String(describing: workDetailsPending[indexPath.row][4]).characters.prefix(10))
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        workAllotmentTable.deselectRow(at: indexPath as IndexPath, animated: true)
        let optionMenu = UIAlertController(title: nil, message: "What do you want to do?", preferredStyle: UIAlertControllerStyle.actionSheet)
        let defaultAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let Approve = UIAlertAction(title: "Approve",style: UIAlertActionStyle.default, handler: nil)
        optionMenu.addAction(defaultAction)
        optionMenu.addAction(Approve)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let number = indexPath.row
        let Accept = UITableViewRowAction(style: .normal, title: "Accept") { action, index in
            //actions to be written down
            Alamofire.request("https://ieeevitportal.herokuapp.com/work/voluntary", method: .put, parameters: ["id":self.workDetailsPending[number][6]], headers: ["x-access-token":token]).responseJSON{response in print(response)}
        }
        Accept.backgroundColor = .blue
        let Verify = UITableViewRowAction(style: .normal, title: "Verify") { action, index in
            //actions to be written down
            Alamofire.request("https://ieeevitportal.herokuapp.com/work/voluntary/verify", method: .put, parameters: ["id":self.workDetailsPending[number][6]], headers: ["x-access-token":token]).responseJSON{response in print(response)}
        }
        Verify.backgroundColor = .lightGray
        let Done = UITableViewRowAction(style: .normal, title: "Done") { action, index in
            //actions to be written down
            Alamofire.request("https://ieeevitportal.herokuapp.com/work/voluntary/completed", method: .put, parameters: ["id":self.workDetailsPending[number][6]], headers: ["x-access-token":token]).responseJSON{response in print(response)}
        }
        Done.backgroundColor = .red
        return [Accept, Verify, Done]
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


