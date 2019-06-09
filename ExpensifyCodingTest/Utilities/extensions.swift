//
//  extensions.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 09/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import Foundation

public extension Optional where Wrapped == String {
  var orEmpty: String {
    switch self {
    case .some(let value):
      return value
    case .none:
      return ""
    }
  }
}

extension String {
  
  var asInt: Int {
    return Int(self) ?? 0
  }
  
  var asDouble: Double {
    return Double(self) ?? 0.0
  }
  
  func truncate(by length: Int, trailing: String = "...") -> String {
    return count > length ? String(prefix(length)) + trailing : self
  }
  
}


extension Int {
  
  var asString: String {
    return String(self)
  }
  
  var asDouble: Double {
    return Double(self)
  }
  
  var asCurrency: Double {
    return Double(self / 1000)
  }
  
}


extension NumberFormatter {
  
  static func currency(from currencyCode: CurrencyCode, amount: Double) -> String? {
    let formatter = NumberFormatter()
    formatter.usesGroupingSeparator = true
    formatter.numberStyle = .currency
    formatter.currencyCode = currencyCode.string
    return formatter.string(from: NSNumber(value: amount))
  }
  
}

extension Date {
  
  static func nowString() -> String {
    let formatter = DateFormatter()
    let date = Date()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.string(from: date)
  }
  
  var expensifyDateFormat: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.string(from: self)
  }
  
}
