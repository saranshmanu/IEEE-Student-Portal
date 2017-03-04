//
//  ViewController.swift
//  CalendarTutorial
//
//  Created by Jeron Thomas on 2016-10-15.
//  Copyright © 2016 OS-Tech. All rights reserved.
//

import UIKit
import JTAppleCalendar
import Alamofire
import SwiftyJSON
import SwiftDate

var calenderEvents = [Array<Any>]()
var num:Int = 1
var eventsOnTheDay = [Array<Any>]()

class CalenderViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //Event Table
    @IBOutlet weak var listOfEventsOnTheDay: UITableView!
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsOnTheDay.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listOfEventsOnTheDay.dequeueReusableCell(withIdentifier: "CalenderCell", for: indexPath as IndexPath) as! CalenderTableViewCell
        print(indexPath.row)
        print(eventsOnTheDay)
        cell.EventTitle?.text = String(describing: eventsOnTheDay[indexPath.row][0])
        cell.EventDescription?.text = String(describing: eventsOnTheDay[indexPath.row][1])
        cell.layer.cornerRadius = 15
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        listOfEventsOnTheDay.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    @IBOutlet weak var selectedYear: UILabel!
    @IBOutlet weak var selectedMonth: UILabel!
    @IBOutlet weak var selectedDate: UILabel!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    let white = UIColor(colorWithHexValue: 0xECEAED)
    let darkPurple = UIColor(colorWithHexValue: 0x3A284C)
    let dimPurple = UIColor(colorWithHexValue: 0x667B92)
    let url = "https://ieeevitportal.herokuapp.com/calendar"
    let Header = ["x-access-token": token]
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                print(date.day,date.month,date.year)
                calenderEvents.append([date.day,date.month,date.year,swiftyJsonVar["calendar"][i]["title"],swiftyJsonVar["calendar"][i]["desc"]])
            }
        print(calenderEvents)
        let dateComponents = NSDateComponents()
        self.selectedDate.text = "1"//String(describing: dateComponents.day)
        self.selectedMonth.text = "JANUARY"//String(describing: dateComponents.month)
        self.selectedYear.text = "2017"//String(describing: dateComponents.year)
        }

        
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.registerCellViewXib(file: "CellView") // Registering your cell is manditory
        calendarView.cellInset = CGPoint(x: 0, y: 0)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Function to handle the text color of the calendar
    func handleCellTextColor(view: JTAppleDayCellView?, cellState: CellState) {
        guard let myCustomCell = view as? CellView  else {
            return
        }
        
        if cellState.isSelected {
            myCustomCell.dayLabel.textColor = darkPurple
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                myCustomCell.dayLabel.textColor = white
            } else {
                myCustomCell.dayLabel.textColor = dimPurple
            }
        }
    }
    
    // Function to handle the calendar selection
    func handleCellSelection(view: JTAppleDayCellView?, cellState: CellState) {
        guard let myCustomCell = view as? CellView  else {
            return
        }
        if cellState.isSelected {
            myCustomCell.selectedView.layer.cornerRadius =  20
            myCustomCell.selectedView.isHidden = false
        } else {
            myCustomCell.selectedView.isHidden = true
        }
    }
    
    
}
let formatter = DateFormatter()
extension CalenderViewController: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        
        let startDate = formatter.date(from: "2016 12 01")! // You can use date generated from a formatter
        let endDate = Date()                                // You can also use dates created from this function
        let parameters = ConfigurationParameters(startDate: startDate,endDate: endDate,numberOfRows: 6, // Only 1, 2, 3, & 6 are allowed
            calendar: Calendar.current,
            generateInDates: .forAllMonths,
            generateOutDates: .tillEndOfGrid,
            firstDayOfWeek: .sunday)
        return parameters
    }
    func calendar(_ calendar: JTAppleCalendarView, willDisplayCell cell: JTAppleDayCellView, date: Date, cellState: CellState) {
        let myCustomCell = cell as! CellView
        // Setup Cell text
        myCustomCell.dayLabel.text = cellState.text
        // Setup text color
        if cellState.dateBelongsTo == .thisMonth {
            myCustomCell.dayLabel.textColor = UIColor(colorWithHexValue: 0xECEAED)
        }
        else {
            myCustomCell.dayLabel.textColor = UIColor(colorWithHexValue: 0x667B92)
        }
        handleCellTextColor(view: cell, cellState: cellState)
        handleCellSelection(view: cell, cellState: cellState)
        print(myCustomCell.dayLabel)
    }
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        let myCustomCell = cell as! CellView
        // Let's make the view have rounded corners. Set corner radius to 25
        myCustomCell.selectedView.layer.cornerRadius =  25
        if cellState.isSelected {
            myCustomCell.selectedView.isHidden = false
        }
        handleCellSelection(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        selectedDate.text = String(date.day)
        if date.month == 1{
            selectedMonth.text = "JANUARY"
        }
        else if date.month==2{
            selectedMonth.text = "FEBUARY"
        }
        else if date.month==3{
            selectedMonth.text = "MARCH"
        }
        else if date.month==4{
            selectedMonth.text = "APRIL"
        }
        else if date.month==5{
            selectedMonth.text = "MAY"
        }
        else if date.month==6{
            selectedMonth.text = "JUNE"
        }
        else if date.month==7{
            selectedMonth.text = "JULY"
        }
        else if date.month==8{
            selectedMonth.text = "AUGUST"
        }
        else if date.month==9{
            selectedMonth.text = "SEPTEMBER"
        }
        else if date.month==10{
            selectedMonth.text = "OCTOBER"
        }
        else if date.month==11{
            selectedMonth.text = "NOVEMBER"
        }
        else{
            selectedMonth.text = "DECEMBER"
        }
        selectedYear.text = String(date.year)
        print(date.day,date.year,date.month)
        for i in 0...num-1{
            if (String(describing: calenderEvents[i][0]) == String(date.day)) && (String(describing: calenderEvents[i][1]) == String(date.month)) && (String(describing: calenderEvents[i][2]) == String(date.year)){
                eventsOnTheDay.append([calenderEvents[i][3],calenderEvents[i][4]])
            }
        }
        //reload the table
        print(eventsOnTheDay)
        listOfEventsOnTheDay.reloadData()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            eventsOnTheDay.removeAll()
        }
    }
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        handleCellSelection(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
}


extension UIColor {
    convenience init(colorWithHexValue value: Int, alpha:CGFloat = 1.0){
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}




