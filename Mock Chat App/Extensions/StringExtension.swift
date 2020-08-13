//
//  StringExtension.swift
//  Mobile Chat Test
//
//  Created by Johnny Owayed on 8/13/20.
//  Copyright © 2020 Johnny Owayed. All rights reserved.
//

import UIKit

extension String {
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }
}
