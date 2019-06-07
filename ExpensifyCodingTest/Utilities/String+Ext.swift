//
//  String+OrEmpty.swift
//  Collabo
//
//  Created by Kauna Mohammed on 07/02/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import UIKit

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
    return Int(self)!
  }
  
  func truncate(by length: Int, trailing: String = "...") -> String {
    return count > length ? String(prefix(length)) + trailing : self
  }
  
}
