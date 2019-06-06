//
//  URLQueryItem+RemoveNilValues.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 06/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import Foundation

extension Array where Element == URLQueryItem {
  func removeNilValues() -> [Element] {
    return filter { $0.value != nil }
  }
}
