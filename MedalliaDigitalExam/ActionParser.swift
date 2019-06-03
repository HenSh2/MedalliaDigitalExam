//
//  ActionParser.swift
//  MedalliaDigitalExam
//
//  Created by Hen Shabat on 03/06/2019.
//  Copyright © 2019 Hen Shabat. All rights reserved.
//

import Foundation

class ActionParser {
    
    class func parse(data: Data) -> [MedalliaAction] {
        var actions: [MedalliaAction] = [MedalliaAction]()
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [Any] {
                for json in jsonArray {
                    if let dictionary = json as? [String: Any] {
                        let action: MedalliaAction = MedalliaAction(dictionary: dictionary)
                        actions.append(action)
                    }
                }
            }
        } catch {
            print("ActionParser - ERROR")
        }
        return actions
    }
    
}
