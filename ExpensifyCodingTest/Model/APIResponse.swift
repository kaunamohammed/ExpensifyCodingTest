//
//  APIResponse.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 05/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import Foundation

public struct APIResponse: Decodable {
  let accountID, httpCode: Int?
  let jsonCode: Int
  let title, message, authToken, email, codeRevision, requestID, transactionID: String?
}
