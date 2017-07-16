//
//  ProfileViewModel.swift
//  SchoolBus
//
//  Created by Melany Gulianovych on 7/16/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import Foundation

class ProfileViewModel: ProfileRepresentative {
    
    var model: UserModel
    var index: Int
    
    public init(with model1: UserModel, and index1: Int) {
        model = model1
        index = index1
    }
    
    var profileData: (title: String, name: String) {
        if index == 0 {
            return firstName
        } else if index == 1 {
            return surName
        } else if index == 2 {
            return telephone
        } else if index == 3 {
            return email
        } else if index == 4 {
            return location
        } else if index == 5 {
            return address
        } else {
            return destination
        }
    }
    
    private var firstName: (String, String) {
        return (title: "Iм'я", name: model.name)
    }
    private var surName: (String, String) {
        return (title: "Фамiлiя", name: model.surname)
    }
    private var telephone: (String, String) {
        return (title: "Телефон", name: model.tel)
    }
    private var email: (String, String) {
        return (title: "E-mail", name: model.email)
    }
    private var location: (String, String) {
        return (title: "Мiсцезнаходження", name: model.location)
    }
    private var address: (String, String) {
        return (title: "Адреса", name: model.address)
    }
    private var destination: (String, String) {
        return (title: "Пункт призначення", name: model.destination)
    }
}


protocol ProfileRepresentative {
    
    var profileData: (title: String, name: String) { get }
    
}
