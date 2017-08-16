//
//  ProfileManager.swift
//  SchoolBus
//
//  Created by Andrey Shabunko on August/14/2017.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import Foundation
import Alamofire

class ProfileManager: NSObject {

    static func getProfileData() {
        let requestUrl = "https://main.ant-logistics.com/AntLogistics/AntService.svc/Comps_Get?Session_Ident=C96B2446-4E8F-418F-8E44-089AE854CEAC&page=1&rows=100000&sidx=Ext_Code&sord=asc&ByObserver=1"
        
        Alamofire.request(requestUrl, method: .get).responseJSON { (responseData) in
            switch responseData.result {
            case .success:
                if let jsonData = responseData.result.value as? [String: Any] {
                    let allUserPointsInfo = jsonData["rows"] as? [[String: Any]]
                    let profileInfoDictionary = allUserPointsInfo!.first! as [String: Any]
                    
                    let profileInfo = ProfileInfo()
                    profileInfo.additionalInfo = profileInfoDictionary["Additional_Info"] as! String
                    profileInfo.adress = profileInfoDictionary["Address"] as! String
                    profileInfo.compGroupId = profileInfoDictionary["CompGroup_Id"] as! Int
                    profileInfo.compGroupName = profileInfoDictionary["CompGroup_Name"] as! String
                    profileInfo.compId = profileInfoDictionary["Comp_Id"] as! Int
                    profileInfo.compName = profileInfoDictionary["Comp_Name"] as! String
                    profileInfo.contactPerson = profileInfoDictionary["Contact_Person"] as! String
                    profileInfo.externalStringCode = profileInfoDictionary["ExtStr_Code"] as! String
                    profileInfo.externalCode = profileInfoDictionary["Ext_Code"] as! Int
                    profileInfo.geoDataBindTypeName = profileInfoDictionary["GeoDataBindType_Name"] as! String
                    profileInfo.geoDataTypeName = profileInfoDictionary["GeoDataType_Name"] as! String
                    profileInfo.geocoderName = profileInfoDictionary["Geocoder_Name"] as! String
                    profileInfo.isBound = (profileInfoDictionary["Is_Bound"] != nil)
                    profileInfo.observerName = profileInfoDictionary["Observer_Name"] as! String
                    profileInfo.phone = profileInfoDictionary["Phone"] as! String
                    profileInfo.radiusVisit = profileInfoDictionary["RadiusVisit"] as! Int
                    profileInfo.timeWorkBegins = profileInfoDictionary["TimeWork_Beg"] as! String
                    profileInfo.timeWorkEnds = profileInfoDictionary["TimeWork_End"] as! String
                    profileInfo.timeBreak = profileInfoDictionary["Time_Break"] as! String
                    profileInfo.unloadTime = profileInfoDictionary["Unload_Time"] as! Int
                    profileInfo.latitude = profileInfoDictionary["lat"] as! Double
                    profileInfo.longitude = profileInfoDictionary["lng"] as! Double
                    
                    ProfileViewController.profileInfo = profileInfo
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

class ProfileInfo: NSObject {
    
    var additionalInfo = ""
    var adress = ""
    var compGroupId = 0
    var compGroupName = ""
    var compId = 0
    var compName = ""
    var contactPerson = ""
    var externalStringCode = ""
    var externalCode = 0
    var geoDataBindTypeName = ""
    var geoDataTypeName = ""
    var geocoderName = ""
    var isBound = true
    var observerName = ""
    var phone = ""
    var radiusVisit = 0
    var timeWorkBegins = ""
    var timeWorkEnds = ""
    var timeBreak = ""
    var unloadTime = 0
    var latitude = 0.0
    var longitude = 0.0
    
    override init() {
        super.init()
    }
    
}
