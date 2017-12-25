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


class UsersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {


    public var memberDetails = [Array<Any>]()
    var filteredTableData = [Array<Any>]()
    let searchController = UISearchController(searchResultsController :nil)
    var refreshControl: UIRefreshControl!
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var memberDetailTableCell: UITableView!

    func updateSearchResults(for searchController: UISearchController) {
        filteredTableData.removeAll()
        if memberDetails.count == 0 {
            return
        }
        for i in 0...memberDetails.count-1{
            let tempString:String = (memberDetails[i][0] as! String).lowercased()
            if tempString.contains(searchController.searchBar.text!.lowercased()){
                filteredTableData.append(memberDetails[i])
            }
        }
        print(filteredTableData)
        memberDetailTableCell.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //Activity indicator initiates
        ActivityIndicator.startAnimating()
        
        //navigation bar edit
        self.title = "Members"
        //self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.backgroundColor = dark_blue
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: light_blue,NSFontAttributeName : UIFont(name : "Avenir Next", size: 21)!]
        
        //for implementation of search bar in the table
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        memberDetailTableCell.tableHeaderView = searchController.searchBar
        
        //for slide down to refresh control
        refreshControl = UIRefreshControl()
        refreshControl=UIRefreshControl()
        refreshControl.backgroundColor = UIColor.white
        refreshControl.tintColor = UIColor.black
        refreshControl.attributedTitle = NSAttributedString(string :"Pull to refresh" )
        refreshControl.addTarget(self, action: #selector(UsersViewController.refresh), for: UIControlEvents.valueChanged)
        memberDetailTableCell.addSubview(refreshControl)
        searchController.isEditing = false
        
        //to print all the users in the ieee login
         Alamofire.request("https://ieeevitportal.herokuapp.com/users/profiles",method:.get, headers: ["x-access-token":token]).responseJSON {response in
            print(response)
            if response.result.isSuccess {
                let swiftyJsonVar = JSON(response.result.value!)
                let number=swiftyJsonVar["users"].count
                print(number)
                if swiftyJsonVar["code"] == "1"
                {
                    let alertController = UIAlertController(title: "Something went wrong", message: "Please try again later", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                else{
                    for i in 0...number-1{
                        let urlImage:String="https://ieeevitportal.herokuapp.com/users/profile/image?regno="+String(describing: swiftyJsonVar["users"][i]["regno"])
                        Alamofire.request(String(urlImage),method:.get, headers: ["x-access-token":token]).responseImage { img in
                            self.memberDetails.append([String(describing: swiftyJsonVar["users"][i]["name"]),String(describing: swiftyJsonVar["users"][i]["regno"]),img.result.value!])
                            self.memberDetailTableCell.reloadData()
                        }
                    }
                }
                // to stop activity indicator
                self.ActivityIndicator.stopAnimating()
            } else {
                //FETCHING ERROR
            }
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
            //self.workAllotmentTable.reloadData()
            self.refreshControl.endRefreshing()
            self.ActivityIndicator.stopAnimating()
        }
        print(self.memberDetails)
    }

    var refresh_flag = 0
    func refresh(){
        if refresh_flag == 1 {
            return
        }
        refresh_flag = 1
        
        //to print all the users in the ieee login
        Alamofire.request("https://ieeevitportal.herokuapp.com/users/profiles",method:.get, headers: ["x-access-token":token]).responseJSON {response in
            print(response)
            
            if response.result.isSuccess {
                let swiftyJsonVar = JSON(response.result.value!)
                let number=swiftyJsonVar["users"].count
                print(number)
                if swiftyJsonVar["code"] == "1"
                {
                    let alertController = UIAlertController(title: "Something went wrong", message: "Please try again later", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                else{
                    self.memberDetails.removeAll()
                    for i in 0...number-1{
                        let urlImage:String="https://ieeevitportal.herokuapp.com/users/profile/image?regno="+String(describing: swiftyJsonVar["users"][i]["regno"])
                        Alamofire.request(String(urlImage),method:.get, headers: ["x-access-token":token]).responseImage { img in
                            self.memberDetails.append([String(describing: swiftyJsonVar["users"][i]["name"]),String(describing: swiftyJsonVar["users"][i]["regno"]),img.result.value!])
                            self.memberDetailTableCell.reloadData()
                        }
                        if i == number-1 {
                            self.refresh_flag = 0
                            self.refreshControl.endRefreshing()
                            self.memberDetailTableCell.reloadData()
                            print(self.memberDetails)
                        }
                    }
                }
            } else {
                //FETCHING ERROR
            }
            
        }
        self.refreshControl.endRefreshing()
        self.memberDetailTableCell.reloadData()
        print(self.memberDetails)
        
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
        if (self.searchController.isActive) {
            return self.filteredTableData.count
        }
        else {
            return memberDetails.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = memberDetailTableCell.dequeueReusableCell(withIdentifier: "TextCellUser", for: indexPath as IndexPath) as! UsersTableViewCell
        if (self.searchController.isActive) {
            cell.NameLabel?.text = String(describing: filteredTableData[indexPath.row][0])
            cell.RegistrationNumberLabel?.text = String(describing: filteredTableData[indexPath.row][1])
            cell.ProfileImageLabel?.image = filteredTableData[indexPath.row][2] as? UIImage
            cell.ProfileImageLabel.layer.cornerRadius=40.0
            cell.ProfileImageLabel.clipsToBounds=true
            return cell
        }
        else {
            cell.NameLabel?.text = String(describing: memberDetails[indexPath.row][0])
            cell.RegistrationNumberLabel?.text = String(describing: memberDetails[indexPath.row][1])
            cell.ProfileImageLabel?.image = memberDetails[indexPath.row][2] as? UIImage
            cell.ProfileImageLabel.layer.cornerRadius=40.0
            cell.ProfileImageLabel.clipsToBounds=true
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (self.searchController.isActive) {
            memberDetailTableCell.deselectRow(at: indexPath as IndexPath, animated: true)
            registrationNumber = filteredTableData[indexPath.row][1] as! String
        }
        else {
            memberDetailTableCell.deselectRow(at: indexPath as IndexPath, animated: true)
            registrationNumber = memberDetails[indexPath.row][1] as! String
        }
        
        //registrationNumber = filteredTableData[indexPath.row][1] as! String
        performSegue(withIdentifier: "show", sender: self)
    }
    

}
