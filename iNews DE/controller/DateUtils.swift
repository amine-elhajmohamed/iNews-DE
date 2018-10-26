//
//  DateUtils.swift
//  iNews DE
//
//  Created by MedAmine on 10/26/18.
//  Copyright © 2018 amine. All rights reserved.
//

import Foundation

class DateUtils {
    
    static let shared = DateUtils()
    
    func differenceBetweenDates(from: Date, to: Date) -> String {
        let calendar = Calendar.current
        let differenceDateComponents = calendar.dateComponents([.day, .hour, .minute], from: from, to: to)
        
        let days = differenceDateComponents.day ?? 0
        let hours = differenceDateComponents.hour ?? 0
        let minutes = differenceDateComponents.minute ?? 0
        
        if days > 0 {
            return "\(days) day\(days == 1 ? "": "s")"
        } else if hours > 0{
            return "\(hours) hour\(hours == 1 ? "": "s")"
        } else {
            if minutes == 0 || minutes == 1 {
                return "1 minute"
            }else{
                return "\(minutes) minutes"
            }
        }
    }
    
}
