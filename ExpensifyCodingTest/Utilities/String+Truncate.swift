//
//  String+Truncate.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 06/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import Foundation

extension String {
  
  func truncate(by length: Int, trailing: String = "...") -> String {
    return count > length ? String(prefix(length)) + trailing : self
  }
  
}
