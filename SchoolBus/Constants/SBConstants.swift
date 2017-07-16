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
    static let numberOfDaysToLoad: Int = 5
    static let numberRowsInProfile: Int = 7
    
    struct LoginConstants {
        static let AuthorisedorisedButtonTitle = "Successfully signed. Click for change."
        static let UnAuthorisedorisedButtonTitle = "Sign in."
        static let InternetConnectionAbsence = "No internet connection. Try again later."
        static let EMailDataEmpty = "Please insert email."
        static let PasswordDataEmpty = "Please insert password."
        static let WrongDataInserted = "Error in Connection. Mismatch between login and password. Please Try again."
        static let ForgotPassword = "Forgot Password"
        static let CallCenter = "Call Center"
    }
    
    struct PointStatus {
        static let IsWaiting = "Очiкує"
        static let IsOnTheWay = "Знаходиться в дорозi"
        static let WasDelivered = "Прибув"
    }
}
