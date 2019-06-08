//
//  Date+Format.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 08/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import Foundation

extension Date {
  
  var expensifyDateFormat: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.string(from: self)
  }
  
}
