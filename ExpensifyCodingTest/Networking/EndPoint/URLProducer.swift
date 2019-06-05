//
//  URLProducer.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 05/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import Foundation

/// All types conforming will need to produce an optional url 
protocol URLProducer {
  var url: URL? { get }
}
