//
//  MedalliaAction.swift
//  MedalliaDigitalExam
//
//  Created by Hen Shabat on 03/06/2019.
//  Copyright © 2019 Hen Shabat. All rights reserved.
//

import Foundation

enum ActionType: String {
    case alert
    case screen
    case alertSheet
    case undefined
}

enum ActionDay: Int {
    case sunday = 0
    case monday = 1
    case tuesday = 2
    case wednesday = 3
    case thursday = 4
    case friday = 5
    case saturday = 6
    case undefined = 7
}

class MedalliaAction {
    
    var type: ActionType
    var enabled: Bool
    var title: String
    var body: String
    var priority: Int
    var validDays: [ActionDay]
    var coolDown: Int
    var triggeredAt: Date? = nil
    
    init(dictionary: [String: Any]) {
        if let type = dictionary["type"] as? String {
            self.type = ActionType(rawValue: type) ?? .undefined
        } else {
            self.type = .undefined
        }
        
        if let enabled = dictionary["enabled"] as? Bool {
            self.enabled = enabled
        } else {
            self.enabled = false
        }
        
        if let title = dictionary["text"] as? String {
            self.title = title
        } else {
            self.title = ""
        }
        
        if let body = dictionary["body"] as? String {
            self.body = body
        } else {
            self.body = ""
        }
        
        if let priority = dictionary["priority"] as? Int {
            self.priority = priority
        } else {
            self.priority = 0
        }
        
        if let validDays = dictionary["valid_days"] as? [Int] {
            self.validDays = validDays.map { ActionDay(rawValue: $0) ?? .undefined }
        } else {
            self.validDays = []
        }
        
        if let coolDown = dictionary["cool_down"] as? Int {
            self.coolDown = coolDown
        } else {
            self.coolDown = 0
        }
    }
    
    init(action: CDAction) {
        self.type = ActionType(rawValue: action.type ?? "") ?? .undefined
        self.enabled = action.enabled
        self.title = action.title ?? ""
        self.body = action.body ?? ""
        self.priority = Int(action.priority)
        self.validDays = []
        if let days = action.validDays {
            self.validDays = days.map { ActionDay(rawValue: Int($0)) ?? .undefined }
        }
        self.coolDown = Int(action.coolDown)
    }
    
}
