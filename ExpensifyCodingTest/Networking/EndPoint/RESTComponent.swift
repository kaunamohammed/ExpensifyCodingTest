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
public protocol RESTComponent {
  /// the url scheme e.g. http/https
  var scheme: String { get }
  /// the url ost
  var host: String { get }
  /// url path 
  var path: String { get }
}

// common scheme and host
public extension RESTComponent {
  var scheme: String {
    return "https"
  }
  var host: String {
    return "expensify.com"
  }
}
