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
    
    struct LoginConstants {
        static let AuthorisedorisedButtonTitle = "Успішно залогінено. Натисніть щоб вийти."
        static let UnAuthorisedorisedButtonTitle = "Залогуватись."
        static let InternetConnectionAbsence = "Немає інтернет зєднання. Спробуйте пізніше."
        static let EMailDataEmpty = "Будь-ласка, внесіть email."
        static let PasswordDataEmpty = "Будь-ласка, внесіть пароль."
        static let WrongDataInserted = "Помилка в зєднанні. Неспівпадіння між логіном та паролем. Будь-ласка, спробуйте ще раз."
        static let ForgotPassword = "Забув пароль"
        static let CallCenter = "Кол-центр"
    }
    
    struct PointStatus {
        static let IsWaiting = "Очiкує"
        static let IsOnTheWay = "Знаходиться в дорозi"
        static let WasDelivered = "Прибув"
    }
}
