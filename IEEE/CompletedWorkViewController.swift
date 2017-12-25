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

class CompletedWorkViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    var workDetailsCompleted = [Array<Any>]()
    var refreshControl: UIRefreshControl!
    @IBOutlet weak var completedWorkTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigation bar edit
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white,NSFontAttributeName : UIFont(name : "Avenir Next", size: 21)!]
        //refresh control
        refreshControl=UIRefreshControl()
        refreshControl.backgroundColor = UIColor.black
        refreshControl.tintColor = UIColor.white
        refreshControl.attributedTitle = NSAttributedString(string :"Pull to refresh" )
        refreshControl.addTarget(self, action: #selector(WorkProjectViewController.refresh), for: UIControlEvents.valueChanged)
        refreshControl.isEnabled = false
        completedWorkTable.addSubview(refreshControl)
        // Do any additional setup after loading the view.
        Alamofire.request("https://ieeevitportal.herokuapp.com/work/voluntary",method:.get, headers: ["x-access-token":token]).responseJSON {response in
            
            if response.result.isSuccess {
                let swiftyJsonVar = JSON(response.result.value!)
                let number=swiftyJsonVar["work"].count
                print(number)
                if number != 0 {
                    for i in 0...number-1{
                        if(String(describing: swiftyJsonVar["work"][i]["status"])=="verified"){
                            self.workDetailsCompleted.append([String(describing: swiftyJsonVar["work"][i]["title"]),String(describing: swiftyJsonVar["work"][i]["desc"]),String(describing: swiftyJsonVar["work"][i]["allotted_by"]["name"]),String(describing: swiftyJsonVar["work"][i]["status"]),String(describing: swiftyJsonVar["work"][i]["due"]),String(describing: swiftyJsonVar["work"][i]["created"]),String(describing: swiftyJsonVar["work"][i]["_id"])])
                        }
                        self.completedWorkTable.reloadData()
                    }
                }
                print(self.workDetailsCompleted)
            }
                
            
        }
        refreshControl.isEnabled = true
    }
    func refresh(){
        //for deleting all data int the arrays
        workDetailsCompleted.removeAll()
        //for fetching JSON request
        Alamofire.request("https://ieeevitportal.herokuapp.com/work/voluntary",method:.get, headers: ["x-access-token":token]).responseJSON {response in
            
            if response.result.isSuccess {
                let swiftyJsonVar = JSON(response.result.value!)
                let number=swiftyJsonVar["work"].count
                print(number)
                if number != 0{
                    for i in 0...number-1{
                        if(String(describing: swiftyJsonVar["work"][i]["status"])=="verified"){
                            self.workDetailsCompleted.append([String(describing: swiftyJsonVar["work"][i]["title"]),String(describing: swiftyJsonVar["work"][i]["desc"]),String(describing: swiftyJsonVar["work"][i]["allotted_by"]["name"]),String(describing: swiftyJsonVar["work"][i]["status"]),String(describing: swiftyJsonVar["work"][i]["due"]),String(describing: swiftyJsonVar["work"][i]["created"]),String(describing: swiftyJsonVar["work"][i]["_id"])])
                        }
                        self.completedWorkTable.reloadData()
                    }
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            //self.completedWorkTable.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    @IBAction func GoBackFromWorkCompleted(_ sender: Any) {
        //Go to the HomeViewController if the login is sucessful
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
        self.present(vc!, animated: true, completion: nil)
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
            return workDetailsCompleted.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = completedWorkTable.dequeueReusableCell(withIdentifier: "WorkCell", for: indexPath as IndexPath) as! WorkProjectTableViewCell
            cell.WorkDescriptionLabel?.text = String(describing: workDetailsCompleted[indexPath.row][1])
            if(String(describing: workDetailsCompleted[indexPath.row][3])=="verified"){
                cell.StatusLabel.backgroundColor = .blue}
            else if(String(describing: workDetailsCompleted[indexPath.row][3])=="completed"){
                cell.StatusLabel.backgroundColor = .green}
            else{
                cell.StatusLabel.backgroundColor = .red}
            cell.StatusLabel.layer.cornerRadius=4.0
            cell.StatusLabel.clipsToBounds=true
            cell.WorkTitleLabel?.text = String(describing: workDetailsCompleted[indexPath.row][0])
            cell.AllotedDate?.text = String((String(describing: workDetailsCompleted[indexPath.row][5]).characters.prefix(10)))
            cell.DeadlineDate?.text = String(String(describing: workDetailsCompleted[indexPath.row][4]).characters.prefix(10))
            return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            completedWorkTable.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
            let Undo = UITableViewRowAction(style: .normal, title: "Undo") { action, index in
                //actions to be written down
            }
            Undo.backgroundColor = .blue
            return [Undo]
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


