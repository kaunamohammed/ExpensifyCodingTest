//
//  DecodableModel+JSONDecoder.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 06/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import Foundation

extension Data {
  /**
   
   This allows us to easily decode data using type-inference. Allowing us to rely on Swifts powerful type-system
   
   - parameter decoder: The `JSONDecoder` decoding the data
   
   - throws: a decoded type
   
   */
  func decoded<T: Decodable>(using decoder: JSONDecoder = .init()) throws -> T {
    let decoded = try decoder.decode(T.self, from: self)
    return decoded
  }
}
