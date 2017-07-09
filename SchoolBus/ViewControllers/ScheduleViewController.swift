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
        selectedElement = items.count > 0 ? items[0] : nil
        configureController()
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
    
    func configureController() {
        navigationController?.navigationItem.title = "Your Schedule"
        title = "Your Schedule"
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
}

extension ScheduleViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedElement?.qtyOfPoints == 0 {
            return 0
        }
        return 4 + (selectedElement?.qtyOfPoints ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var model: DataRepresentative = RouteViewModel(with: selectedElement, and: indexPath.row)
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimePointCell") as! TimePointCell
            cell.configure(with: model)
            return cell
            
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EndPointCell") as! TimePointCell
            cell.configure(with: model, start: false)
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DistanceCell") as! Distancecell
            cell.configure(with: model)
            return cell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlannedTimeCell") as! Distancecell
            cell.configure(with: model, distance: false )
            return cell
        }else if indexPath.row > 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PointCell") as! PointCell
            if indexPath.row > 3, let point = selectedElement?.points?[indexPath.row - 4] {
                model = PointViewModel(with: point, and: indexPath.row)
                cell.configure(with: model)
            }
            return cell
        }
        
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < 2 {
            return 70
        } else if indexPath.row > 3 {
            return 80
        } else {
            return UITableViewAutomaticDimension
        }
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
        detailedTableView.reloadData()
    }
}
