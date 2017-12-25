//
//  CreateCalenderEventViewController.swift
//  IEEE
//
//  Created by Saransh Mittal on 05/03/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftDate

class CreateCalenderEventViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var DateAndTimeOfTheEvent: UIDatePicker!
    @IBOutlet weak var DescriptionOfTheEvent: UITextField!
    @IBOutlet weak var TitleOfTheEvent: UITextField!
    let url = "https://ieeevitportal.herokuapp.com/calendar"
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        createButton.layer.cornerRadius = 10
        //for navigation bar edit
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white,NSFontAttributeName : UIFont(name : "Avenir Next", size: 21)]
        //to dismiss keyboard
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CreateCalenderEventViewController.dismissKeyboard)))
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // for hitting return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        TitleOfTheEvent.resignFirstResponder()
        DescriptionOfTheEvent.resignFirstResponder()
        return true
    }
    // for tapping
    func dismissKeyboard() {
        TitleOfTheEvent.resignFirstResponder()
        DescriptionOfTheEvent.resignFirstResponder()
    }

    @IBAction func Create(_ sender: UIButton) {
        createButton.isEnabled = false
        //to change the format of the date into ISO8601 format
        let dateFormatter = DateFormatter()
        let enUSPosixLocale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.locale = enUSPosixLocale as Locale!
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let iso8601String = dateFormatter.string(from: DateAndTimeOfTheEvent.date as Date) + ".132Z"
        print(iso8601String)
        //to generate JSON request for creating event in the calender
        var request = ["date":iso8601String,"desc":DescriptionOfTheEvent.text!,"title":TitleOfTheEvent.text!]
        var header = ["x-access-token":token]
        Alamofire.request(url, method: .post, parameters: request, encoding: JSONEncoding.default, headers: header).response{
            response in print(response)
            let swiftyJsonVar = JSON(response.data as Any)
            if swiftyJsonVar["code"]=="1"
            {
                self.createButton.isEnabled = true
                let alertController = UIAlertController(title: "Error", message: "Event not created. Try after some time.", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
            else{
                //for fetching events in the calender
                let url = "https://ieeevitportal.herokuapp.com/calendar"
                let Header = ["x-access-token": token]
                calenderEvents.removeAll()
                Alamofire.request(url, method:.get, headers: Header).responseJSON{
                    response in
                    print(response.result.value as Any)
                    let swiftyJsonVar = JSON(response.result.value!)
                    num = swiftyJsonVar["calendar"].count
                    for i in 0...(num-1){
                        let rome = Region(tz: TimeZoneName.europeRome, cal: CalendarName.gregorian, loc: LocaleName.italian)
                        //to change the format of date from 2016-12-31T23:37:33.545Z to 2016-12-31T23:37:33+01:00
                        let DateString:String = String(describing: swiftyJsonVar["calendar"][i]["date"])
                        let Date:String = String(DateString.characters.prefix(19)) + "+01:00"
                        let date = try! DateInRegion(string: Date, format: .iso8601(options: .withInternetDateTime) , fromRegion: rome)
                        calenderEvents.append([date,swiftyJsonVar["calendar"][i]["title"],swiftyJsonVar["calendar"][i]["desc"]])
                    }
                    print(calenderEvents)
                }
                self.createButton.isEnabled = true
                let alertController = UIAlertController(title: "Success", message: "Event added into the calender", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true,completion: nil)
                //Go to the HomeViewController if the task generation is sucessful
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
                self.present(vc!, animated: true, completion: nil)
                
        }
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
