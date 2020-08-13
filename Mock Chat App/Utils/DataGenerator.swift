//
//  Data Generator.swift
//  Mobile Chat Test
//
//  Created by Johnny Owayed on 8/11/20.
//  Copyright © 2020 Johnny Owayed. All rights reserved.
//

import UIKit

class DataGenerator {
    
    class func randomString(length:Int! = 7) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyz"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
