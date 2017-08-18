//
//  InfoViewController.swift
//  SchoolBus
//
//  Created by Melany Gulianovych on 7/16/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import UIKit
import RealmSwift

class InfoViewController: UIViewController {
  static var updateRouteTimer: Timer?
  @IBOutlet weak var blurView: UIView!
  @IBOutlet weak var detailedTableView: UITableView!

  var currentRoute: RouteModel?
  var routFinished: Bool = false
  var sortedPoints: [PointModel]?
  var updateRouteTimer: Timer!
  override func viewDidLoad() {
    super.viewDidLoad()
    getRoute()
    // Do any additional setup after loading the view.
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateRouteIfNeedef()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    if updateRouteTimer != nil {
      updateRouteTimer.invalidate()
    }
  }

  func updateRouteIfNeedef() {
    if !routFinished && currentRoute != nil {
      if updateRouteTimer == nil {
        updateRouteTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(updateRoute), userInfo: nil, repeats: true)
        updateRouteTimer.fire()
      }
    } else {
      if updateRouteTimer != nil {
        updateRouteTimer.invalidate()
      }
    }
  }

  @objc private func updateRoute() {
    Loader.getUpdatesOnRoute(for: currentRoute?.lastChangedData ?? Date(), for: String(describing: currentRoute?.routeId), actualroute: currentRoute!) {
      [weak self] (changes, statusCode) in
      self?.sortedPoints = self?.currentRoute?.points?.sorted(by: { $0.positionInRoute < $1.positionInRoute})
      self?.detailedTableView.reloadData()
      if self?.sortedPoints?.last?.visited == true {
        self?.routFinished = true
      }
    }
  }

  private func getRoute() {
    currentRoute = Loader.getClosestRoute()
    //        currentRoute = DatabaseManager.shared.items[0].routs?[0]
    if currentRoute != nil, currentRoute?.points == nil {
      Loader.loadPoints(for: currentRoute?.routeNum ?? 0) {
        [unowned self] (result: List<PointModel>?, statusCode: Int) in
        if result != nil {
          self.currentRoute?.points = result
          self.sortedPoints = result?.sorted(by: { $0.positionInRoute < $1.positionInRoute})
          self.detailedTableView.delegate = self
          self.detailedTableView.dataSource = self
          self.detailedTableView.reloadData()
          self.blurView.isHidden = true
          self.updateRouteIfNeedef()
        } else {
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
        }
      }
    } else if currentRoute?.points != nil {
      self.sortedPoints = currentRoute?.points?.sorted(by: { $0.positionInRoute < $1.positionInRoute})
      self.detailedTableView.delegate = self
      self.detailedTableView.dataSource = self
      self.detailedTableView.reloadData()
      self.blurView.isHidden = true
    }
  }

  private func showAlert(with text: String) {
    DispatchQueue.main.async { [weak self] in
      let alertView = UIAlertController(title: "", message: text, preferredStyle: .alert)
      let action = UIAlertAction(title: "OK", style: .default, handler: nil)
      alertView.addAction(action)
      self?.present(alertView, animated: true, completion: nil)
    }
  }
}

extension InfoViewController: UITableViewDataSource, UITableViewDelegate {

  func numberOfSections(in tableView: UITableView) -> Int{
    return SBConstants.stableRowsInSchedule
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return 1
    } else if section == 1 {
      return 2
    } else if section == 2 {
      return 3
    } else if section == 3 {
      return (currentRoute?.points?.count)! - 1 ?? 0
    }
    return 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var model: DataRepresentative = PointViewModel(with: sortedPoints?[0], and: indexPath.row)
    if indexPath.section == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DetaleImageCell.self)) as! DetaleImageCell
      cell.configure(with: model)
      return cell
    } else if indexPath.section == 1 {
      let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FrameCell.self)) as! FrameCell
      if indexPath.row == 1, let count = currentRoute?.points?.count, count > 0 {
        model = PointViewModel(with: sortedPoints?[count - 2], and: indexPath.row)
        cell.configure(with: model)
      } else {
        cell.configure(with: model)
      }
      return cell
    } else if indexPath.section == 2 {
      let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DetailCell.self)) as! DetailCell
      model = RouteViewModel(with: currentRoute, and: indexPath.row)
      cell.configure(with: model)
      return cell
    } else if indexPath.section == 3 {
      let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PointCell.self)) as! PointCell
      if let point = sortedPoints?[indexPath.row] {
        model = PointViewModel(with: point, and: indexPath.row)
        cell.configure(with: model)
        return cell
      }
    }
    return UITableViewCell()
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return SBConstants.heighStableRowsInSchedule
  }
}
