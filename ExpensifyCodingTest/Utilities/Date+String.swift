//
//  Date+String.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 07/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import Foundation

extension Date {
  
  static func nowString() -> String {
    let formatter = DateFormatter()
    let date = Date()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.string(from: date)
  }
  
}
