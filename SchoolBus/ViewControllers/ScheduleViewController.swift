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
    @IBOutlet weak var blurView: UIView!
    
    var items: [RouteModel] = []
    var sortedPoints: [PointModel]?
    var selectedElement: RouteModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllRouts(from: DatabaseManager.shared.items)
        selectedElement = items.count > 0 ? items[0] : nil
        if items.count > 0 {
            routsPicker.delegate = self
            routsPicker.dataSource = self
            loadItem()
        }
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
//        items.sort(by: { $0.beginTime > $1.beginTime})
    }
    
    func configureController() {
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
}

extension ScheduleViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedElement?.points == nil || selectedElement?.points?.count ?? 0 == 0 {
            return 0
        }
        return SBConstants.stableRowsInSchedule + (selectedElement?.qtyOfPoints ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var model: DataRepresentative = RouteViewModel(with: selectedElement, and: indexPath.row)
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TimePointCell.self)) as! TimePointCell
            cell.configure(with: model)
            return cell
            
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TimePointCell.self)) as! TimePointCell
            cell.configure(with: model, start: false)
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: Distancecell.self)) as! Distancecell
            cell.configure(with: model)
            return cell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlannedTimeCell") as! Distancecell
            cell.configure(with: model, distance: false )
            return cell
        }else if indexPath.row > 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PointCell.self)) as! PointCell
            if indexPath.row > 3, let point = sortedPoints?[indexPath.row - SBConstants.stableRowsInSchedule] {
                model = PointViewModel(with: point, and: indexPath.row)
                cell.configure(with: model)
            }
            return cell
        }
        
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < 2 {
            return SBConstants.heighStableRowsInSchedule
        } else if indexPath.row > 3 {
            return SBConstants.heighPointRowsInSchedule
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    func loadItem() {
        self.blurView.isHidden = false
        NetworkManager.getCompsByRouteFast(route: String(describing: selectedElement?.routeNum ?? 0), completion: { [unowned self] (result: DataResult<AllCompsModel>, statusCode: Int) in
            switch result {
            case .success(let comps):
                self.selectedElement?.points = comps.points
                self.sortedPoints = comps.points?.sorted(by: { $0.positionInRoute < $1.positionInRoute})
                 self.detailedTableView.reloadData()
                self.blurView.isHidden = true
            case .failure(let error):
                debugPrint(error)
            }
        })
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
        self.selectedElement = items[row]
        if self.selectedElement?.points != nil {
            detailedTableView.reloadData()
        } else {
            loadItem()
        }
    }
}
