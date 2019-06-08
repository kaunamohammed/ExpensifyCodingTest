//
//  CurrencyCode.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 06/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import Foundation

public struct CurrencyCode {
  let string: String
}
extension CurrencyCode: ExpressibleByStringLiteral {
  public init(stringLiteral value: String) {
    string = value
  }
}
