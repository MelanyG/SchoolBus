//
//  ScheduleViewController.swift
//  SchoolBus
//
//  Created by Melany Gulianovych on 6/18/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import UIKit
import RealmSwift

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Loader.checkIfThereNeedToLoadNewRoute {
            [unowned self] (loaded: Bool) in
            if loaded {
                DispatchQueue.main.async { [weak self] in
                    self?.routsPicker.reloadAllComponents()
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("ScheduleViewController - viewWillDisappear")
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
        items.sort(by: { $0.beginTime < $1.beginTime})
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
        return SBConstants.stableRowsInSchedule + (selectedElement?.points?.count ?? 0)
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
        Loader.loadPoints(for: selectedElement?.routeNum ?? 0) {
            [unowned self] (result: List<PointModel>?, statusCode: Int) in
            switch statusCode {
            case DataStatusCode.Unauthorized.rawValue:
                self.showAlert(with: "Ви не маэте достатнiх прав")
                return
            case DataStatusCode.Error.rawValue:
                self.showAlert(with: "Error")
                return
            case DataStatusCode.ERR_SESSION_CLOSE.rawValue:
                self.showAlert(with: "ERR_SESSION_CLOSE")
                return
            case DataStatusCode.ERR_KNOWN.rawValue:
                self.showAlert(with: "ERR_KNOWN")
                return
            case DataStatusCode.INFO.rawValue:
                self.showAlert(with: "INFO")
                return
            case DataStatusCode.WARNING.rawValue:
                self.showAlert(with: "WARNING")
                return
            case DataStatusCode.VIOLATION_TARIFF.rawValue:
                self.showAlert(with: "VIOLATION_TARIFF")
                return
            default:
                break
            }
            self.selectedElement?.points = result
            self.sortedPoints = result?.sorted(by: { $0.positionInRoute < $1.positionInRoute})
            self.detailedTableView.reloadData()
            self.blurView.isHidden = true
        }
    }
    
    func showAlert(with text: String) {
        DispatchQueue.main.async { [weak self] in
            let alertView = UIAlertController(title: "", message: text, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertView.addAction(action)
            self?.present(alertView, animated: true, completion: nil)
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
        self.selectedElement = items[row]
        if self.selectedElement?.points != nil {
            detailedTableView.reloadData()
        } else {
            loadItem()
        }
    }
}
