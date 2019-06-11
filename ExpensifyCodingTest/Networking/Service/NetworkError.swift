//
//  NetworkError.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 05/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import Foundation

public enum NoDataError {
  case underlying
}

extension NoDataError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .underlying: return "We couldn't fulfil this request"
    }
  }
}
