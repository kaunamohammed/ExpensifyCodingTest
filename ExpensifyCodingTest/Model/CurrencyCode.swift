//
//  CurrencyCode.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 06/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import Foundation

struct CurrencyCode {
  let string: String
}
extension CurrencyCode: ExpressibleByStringLiteral {
  init(stringLiteral value: String) {
    string = value
  }
}
