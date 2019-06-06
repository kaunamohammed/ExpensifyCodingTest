//
//  NumberFormatter+Ext.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 06/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import Foundation

extension NumberFormatter {
  
  static func currency(from currencyCode: CurrencyCode, amount: Double) -> String? {
    let formatter = NumberFormatter()
    formatter.usesGroupingSeparator = true
    formatter.numberStyle = .currency
    formatter.currencyCode = currencyCode.string
    return formatter.string(from: NSNumber(value: amount))
  }
  
}
