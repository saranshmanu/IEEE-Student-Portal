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
var eventsOnTheDay = [Array<Any>]()
var num:Int = 0

class CalenderViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //Event Table
    @IBOutlet weak var typeOfEventLabel: UILabel!
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
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        listOfEventsOnTheDay.deselectRow(at: indexPath as IndexPath, animated: true)
    }

    @IBOutlet weak var selectedDate: UILabel!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    let white = UIColor(colorWithHexValue: 0xECEAED)
    let darkPurple = UIColor(colorWithHexValue: 0x3A284C)
    let dimPurple = UIColor(colorWithHexValue: 0x667B92)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //for navigation Bar edit
        
        
        UINavigationBar.appearance().barTintColor = UIColor(colorWithHexValue: 0x2E4960)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white,NSFontAttributeName : UIFont(name : "Avenir Next", size: 21)!]
        
        //for setup of initial todays date
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        let year =  components.year
        let month = components.month
        let day = components.day
        if month == 1{
            selectedDate.text = String(describing: day!) + " January " + String(describing: year!)
        }
        else if month==2{
            selectedDate.text = String(describing: day!) + " Febuary " + String(describing: year!)
        }
        else if month==3{
            selectedDate.text = String(describing: day!) + " March " + String(describing: year!)
        }
        else if month==4{
            selectedDate.text = String(describing: day!) + " April " + String(describing: year!)
        }
        else if month==5{
            selectedDate.text = String(describing: day!) + " May " + String(describing: year!)
        }
        else if month==6{
            selectedDate.text = String(describing: day!) + " June " + String(describing: year!)
        }
        else if month==7{
            selectedDate.text = String(describing: day!) + " July " + String(describing: year!)
        }
        else if month==8{
            selectedDate.text = String(describing: day!) + " August " + String(describing: year!)
        }
        else if month==9{
            selectedDate.text = String(describing: day!) + " September " + String(describing: year!)
        }
        else if month==10{
            selectedDate.text = String(describing: day!) + " October " + String(describing: year!)
        }
        else if month==11{
            selectedDate.text = String(describing: day!) + " November " + String(describing: year!)
        }
        else{
            selectedDate.text = String(describing: day!) + " Decemeber " + String(
                describing: year!)
        }
        
        //for setting up delegate and data source for the calendar
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.scrollToDate(date)
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
            let selectedViewHeight = myCustomCell.selectedView.frame.size.height
            myCustomCell.selectedView.layer.cornerRadius =  selectedViewHeight/2
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
        let endDate = formatter.date(from: "2060 12 01")!//Date() TO CHANGE THE END DATE OF THE CALENDER
        let parameters = ConfigurationParameters(startDate: startDate,endDate: endDate,numberOfRows: 6, // Only 1, 2, 3, & 6 are allowed
            calendar: Calendar.current,
            generateInDates: .forAllMonths,
            generateOutDates: .tillEndOfGrid,
            firstDayOfWeek: .sunday)
        return parameters
    }
    func calendar(_ calendar: JTAppleCalendarView, willDisplayCell cell: JTAppleDayCellView, date: Date, cellState: CellState) {
        let myCustomCell = cell as! CellView
        myCustomCell.dayLabel.text = cellState.text
        if cellState.dateBelongsTo == .thisMonth {
            myCustomCell.dayLabel.textColor = UIColor(colorWithHexValue: 0xECEAED)
            print("Date belongs to this month " ,date)
        }
        else {
            myCustomCell.dayLabel.textColor = UIColor(colorWithHexValue: 0x667B92)
            print("Date does not belong to this month ", date)
        }
        handleCellTextColor(view: cell, cellState: cellState)
        handleCellSelection(view: cell, cellState: cellState)
        let eventsOnTheDayViewHeight = myCustomCell.eventsOnTheDayView.bounds.height
        myCustomCell.eventsOnTheDayView.layer.cornerRadius = eventsOnTheDayViewHeight/2
        myCustomCell.eventsOnTheDayView.isHidden = true
        myCustomCell.todayView.isHidden = true
        //FOR HIGHLIGHTING THE EVENTS ON THE CALENDER ON WHICH DATE THE EVENTS ARE THERE
        if num != 0{
            for i in 0...num-1{
                if ((calenderEvents[i][0] as! DateInRegion).day == date.day) && ((calenderEvents[i][0] as! DateInRegion).year == date.year) && ((calenderEvents[i][0] as! DateInRegion).month == date.month) && cellState.dateBelongsTo == .thisMonth{
                    myCustomCell.eventsOnTheDayView.isHidden = false
                    let eventsOnTheDayViewHeight = myCustomCell.eventsOnTheDayView.frame.size.height
                    myCustomCell.eventsOnTheDayView.layer.cornerRadius = eventsOnTheDayViewHeight/2
                }
            }
        }
        // to change the color of date of present to differenciate it from others
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        let year =  components.year
        let month = components.month
        let day = components.day
        let rome = Region(tz: TimeZoneName.europeRome, cal: CalendarName.gregorian, loc: LocaleName.italian)
        let dateToday = try! DateInRegion(components: [.year: year!, .month: month!, .day: day! , .hour: 11, .minute: 11, .second: 11], fromRegion: rome)
        if (cellState.date.day == dateToday.day) && (cellState.date.month == dateToday.month) && (cellState.date.year == dateToday.year) {
            // Configure my cell's background this way
            myCustomCell.todayView.isHidden = false
            let selectedTodayViewHeight = myCustomCell.todayView.frame.size.height
            myCustomCell.todayView.layer.cornerRadius =  selectedTodayViewHeight/2
        }
    }
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        print("cell selected")

        let myCustomCell = cell as! CellView
        // Let's make the view have rounded corners. Set corner radius to 25
        let selectedViewHeight = myCustomCell.selectedView.frame.size.height
        myCustomCell.selectedView.layer.cornerRadius =  selectedViewHeight
        if cellState.isSelected {
            myCustomCell.selectedView.isHidden = false
        }
        handleCellSelection(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        if date.month == 1{
            selectedDate.text = String(date.day) + " January " + String(date.year)
        }
        else if date.month==2{
            selectedDate.text = String(date.day) + " Febuary " + String(date.year)
        }
        else if date.month==3{
            selectedDate.text = String(date.day) + " March " + String(date.year)
        }
        else if date.month==4{
            selectedDate.text = String(date.day) + " April " + String(date.year)
        }
        else if date.month==5{
            selectedDate.text = String(date.day) + " May " + String(date.year)
        }
        else if date.month==6{
            selectedDate.text = String(date.day) + " June " + String(date.year)
        }
        else if date.month==7{
            selectedDate.text = String(date.day) + " July " + String(date.year)
        }
        else if date.month==8{
            selectedDate.text = String(date.day) + " August " + String(date.year)
        }
        else if date.month==9{
            selectedDate.text = String(date.day) + " September " + String(date.year)
        }
        else if date.month==10{
            selectedDate.text = String(date.day) + " October " + String(date.year)
        }
        else if date.month==11{
            selectedDate.text = String(date.day) + " November " + String(date.year)
        }
        else{
            selectedDate.text = String(date.day) + " Decemeber " + String(date.year)
        }
        
        //to change the format of orignal date format of swift library to SwiftDate format
        let rome = Region(tz: TimeZoneName.europeRome, cal: CalendarName.gregorian, loc: LocaleName.italian)
        let selectedDateInSwiftDateFormat = try! DateInRegion(components: [.year: date.year, .month: date.month, .day: date.day , .hour: date.hour, .minute: date.minute, .second: date.second], fromRegion: rome)
        print(selectedDateInSwiftDateFormat)
        var numberOfEventsOnTheDay = 0
        if num != 0{
            eventsOnTheDay.removeAll()
            for i in 0...num-1{
                if ((calenderEvents[i][0] as! DateInRegion).day == selectedDateInSwiftDateFormat.day) && ((calenderEvents[i][0] as! DateInRegion).year == selectedDateInSwiftDateFormat.year) && ((calenderEvents[i][0] as! DateInRegion).month == selectedDateInSwiftDateFormat.month){
                    eventsOnTheDay.append([calenderEvents[i][1],calenderEvents[i][2]])
                    numberOfEventsOnTheDay += 1
                }
            }
//            print(numberOfEventsOnTheDay)
            if numberOfEventsOnTheDay==0{
                typeOfEventLabel.text = "Upcoming Events"
                for i in 0...num-1{
                    if calenderEvents[i][0] as! DateInRegion > selectedDateInSwiftDateFormat{
                        eventsOnTheDay = [[calenderEvents[i][1],calenderEvents[i][2]]] + eventsOnTheDay
                    }
                }
            }
            else{
                typeOfEventLabel.text = "Events Today"
            }
        }
        
        //reload the table
        listOfEventsOnTheDay.reloadData()
    }
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        print("cell deselected")
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




