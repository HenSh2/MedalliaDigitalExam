//
//  MainVCVM.swift
//  MedalliaDigitalExam
//
//  Created by Hen Shabat on 03/06/2019.
//  Copyright © 2019 Hen Shabat. All rights reserved.
//

import Foundation

class MainVCVM {
    
    var actions: [CDAction] {
        return CDService.actions()
    }
    
    var isActionsAvailable: Bool {
        return CDService.actions().count > 0
    }
    
    var actionToShow: CDAction? {
        return self.getActionToShow()
    }
    
    var isShouldRequestActions: Bool {
        return self.actions.count == 0
    }
    
    func requestActions(completion: @escaping ([CDAction], Bool) -> ()) {
        //request new actions when you don't have enabled action saved on your device
        if !self.isShouldRequestActions {
            completion(CDService.actions(), false)
            return
        }
        ApiService.shared.requestActions { (actions, error) in
            let enabledActions: [MedalliaAction] = actions.filter { $0.enabled }
            CDService.saveActions(enabledActions)
            completion(CDService.actions(), error)
        }
    }
    
    private func getActionToShow() -> CDAction? {
        let availableActions: [CDAction] = self.availableActions()
        var index: Int = 0
        for i in 0..<availableActions.count  {
            if i < availableActions.count - 1 && availableActions[i].priority != availableActions[i+1].priority {
                break
            } else {
                index = i
            }
        }
        index += 1
        let randomNumber: Int = Int.random(in: 0..<index)
        return availableActions.count > 0 ? availableActions[randomNumber] : nil
    }
    
    private func availableActions() -> [CDAction] {
        return self.filterdAvailableDaysActions()
    }
    
    private func filterdAvailableDaysActions() -> [CDAction] {
        let today: ActionDay = self.getDay()
        let filterdActions: [CDAction] = self.actions.filter { $0.validDays?.contains(today.rawValue) ?? false }
        return self.sortedByPriorityAndCooledDownActions(actions: filterdActions)
    }
    
    private func sortedByPriorityAndCooledDownActions(actions: [CDAction]) -> [CDAction] {
        let filterdActions: [CDAction] = actions.sorted { (a1, a2) -> Bool in
            return a1.priority > a2.priority
        }
        return filterdActions.filter { self.isCooledDown(action: $0) }
    }
    
    private func isCooledDown(action: CDAction) -> Bool {
        if let trigger = action.triggeredAt {
            return Int(abs(trigger.timeIntervalSinceNow) * 1000) > Int(action.coolDown)
        } else {
            return true
        }
    }
    
    private func getDay() -> ActionDay {
        let day: Int = Calendar.current.component(.weekday, from: Date()) - 1
        return ActionDay(rawValue: day) ?? .undefined
    }
    
}
