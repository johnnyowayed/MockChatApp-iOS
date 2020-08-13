//
//  UITableViewExtensions.swift
//  Mobile Chat Test
//
//  Created by Johnny Owayed on 8/12/20.
//  Copyright © 2020 Johnny Owayed. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    
    func scrollToBottom(animated:Bool? = true) {
        let rows = self.numberOfRows(inSection: 0)

        if rows > 0 {
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: rows - 1, section: 0)
                self.scrollToRow(at: indexPath, at: .bottom, animated: animated ?? true)
            }
        }
    }
}
