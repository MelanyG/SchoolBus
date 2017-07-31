//
//  SBConstants.swift
//  SchoolBus
//
//  Created by Melany Gulianovych on 7/9/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import Foundation
import UIKit

class SBConstants {

    static let callCenterNumber = "555-555-5555"
    static let stableRowsInSchedule: Int = 4
    static let heighStableRowsInSchedule: CGFloat = 70.0
    static let heighPointRowsInSchedule: CGFloat = 80.0
    static let numberOfDaysToLoad: Int = 7
    static let numberRowsInProfile: Int = 7
    static let Main = "Main"
    
    struct LoginConstants {
        static let AuthorisedorisedButtonTitle = "Успішно залогінено. Натисніть щоб вийти."
        static let UnAuthorisedorisedButtonTitle = "Залогуватись."
        static let InternetConnectionAbsence = "Немає інтернет зєднання. Спробуйте пізніше."
        static let EMailDataEmpty = "Будь-ласка, внесіть email."
        static let PasswordDataEmpty = "Будь-ласка, внесіть пароль."
        static let WrongDataInserted = "Помилка в зєднанні. Неспівпадіння між логіном та паролем. Будь-ласка, спробуйте ще раз."
        static let ForgotPassword = "Забув пароль"
        static let CallCenter = "Кол-центр"
        static let BackButtonTitle = "Назад"
    }
    
    struct PointStatus {
        static let IsWaiting = "Очiкує"
        static let IsOnTheWay = "Знаходиться в дорозi"
        static let WasDelivered = "Прибув"
    }
    struct ModelConstants {
        static let DayRoute = "Route"
        static let DayRouteFast = "rows"
        static let DayComps = "Comps"
        static let ErrorResponseError = "error"
        static let ErrorResponseMsg = "Comps"
        static let PointRoutNum = "Route_Num"
        static let PointCompID = "Comp_Id"
        static let ExtIdentifier = "Ext_Ident"
        static let PointIsVisited = "Is_Visited"
        static let PointPosition = "Pos_Id"
        static let PointAddress = "Address"
        static let PointName = "Comp_Name"
        static let PointTimeArrival = "Time_Arrival"
//        static let PointTimeArrivalFact = "Time_Arrival_fact"
        static let PointLatitude = "lat"
        static let PointLongitude = "lng"
        static let PointDistance = "distance"
//        static let PointTimeArrivalToPoint = "Time_Arrival"
        static let PointTravelTime = "Travel_Time"
        static let SessionID = "Session_Ident"
        static let ErrorResponse = "ErrorResponse"
        static let CountComps = "Count_Comps"
        static let RoutTravelDuration = "Travel_Duration"
        static let RouteTimeBegin = "RouteTime_B"
        static let RouteTimeEnd = "RouteTime_E"
        static let DayRoutsCount = "records"
    }
    struct NotificationConstants {
        static let ReadMessage = "Прочитані"
        static let UnReadMessage = "Не прочитані"
    }
}
