//
//  ScheduleViewController.swift
//  SchoolBus
//
//  Created by Melany Gulianovych on 6/18/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController {
    
    @IBOutlet weak var detailedTableView: UITableView!
    @IBOutlet weak var routsPicker: UIPickerView!
    var items: [RouteModel] = []
    var selectedElement: RouteModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllRouts(from: DatabaseManager.shared.items)
        navigationItem.title = "Your Schedule"
    }
    
    //MARK: - Private methods
    
    func getAllRouts(from dayItems: [DayRouts]) {
        for day in dayItems {
            if let routs = day.routs {
                for rout in routs {
                    items.append(rout)
                }
            }
        }
       items.sort(by: { $0.beginTime > $1.beginTime})
    }
    
}

extension ScheduleViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = items[indexPath.row]

        if indexPath.row == 0 {
             let cell = tableView.dequeueReusableCell(withIdentifier: "TimePointCell") as! TimePointCell
            cell.configure(with: element.beginTime)
            return cell

        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EndPointCell") as! TimePointCell
            cell.configure(with: element.endTime)
            return cell
        }
        
        return UITableViewCell()
    }

}

extension ScheduleViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Date.getDayOfWeek(items[row].beginTime)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("selected - \(row)")
        self.selectedElement = items[row]
    }
}
