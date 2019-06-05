//
//  AccountInfo.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 05/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import Foundation

struct AccountInfo: Decodable {
  let accountID, httpCode, jsonCode: Int
  let authToken, email, requestID: String
}
