//
//  RESTComponent.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 05/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import Foundation

/**
 
 RESTComponent is used to allow for constructing URL components
 
 */
protocol RESTComponent {
  var scheme: String { get }
  var host: String { get }
  var path: String { get }
}

// The expension defines the common scheme and host
extension RESTComponent {
  var scheme: String {
    return "https"
  }
  var host: String {
    return "expensify.com"
  }
}
