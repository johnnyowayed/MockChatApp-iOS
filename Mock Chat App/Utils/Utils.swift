//
//  Utils.swift
//  Mobile Chat Test
//
//  Created by Johnny Owayed on 8/12/20.
//  Copyright © 2020 Johnny Owayed. All rights reserved.
//

import UIKit

class Utils {
    
    class func fetchFormatedDateString(date:Date) -> String {
        let dateFormatter = DateFormatter()
        var dateString = ""
        
        if date.isToday {
            dateFormatter.dateFormat = "h:mm a"
            dateString = dateFormatter.string(from: date)
        }else if date >= (Date() - 7.days){
            let weekday = date.toFormat("EEEE, h:mm a", locale: Locale.current)
            dateString = weekday
        }else {
            dateFormatter.dateFormat = "MM/dd/yy, h:mm a"
            dateString = dateFormatter.string(from: date)
        }
        return dateString
    }
    
}
