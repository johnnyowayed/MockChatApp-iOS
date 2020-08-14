//
//  Utils.swift
//  Mobile Chat Test
//
//  Created by Johnny Owayed on 8/12/20.
//  Copyright © 2020 Johnny Owayed. All rights reserved.
//

import UIKit
import SwiftDate

let MY_USER_ID = "MY_USER_ID"

class Utils {
    
    // MARK: Set user default
    final class func saveUserDefault(inKey key:String, withValue value:Any) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    // MARK: Fetch user default
    final class func fetchUserDefault(key:String) -> Any? {
        return UserDefaults.standard.object(forKey: key)
    }
    
    // MARK: Format Date
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
