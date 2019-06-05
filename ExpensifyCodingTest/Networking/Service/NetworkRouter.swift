//
//  NetworkRouter.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 05/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import Foundation

typealias NetworkCompletion = ((Result<Data, NetworkError>) -> Void)

protocol NetworkRouter: class {
  func request(_ route: URLProducer, completion: @escaping NetworkCompletion)
  func cancel()
}
