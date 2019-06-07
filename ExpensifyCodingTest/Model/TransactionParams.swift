//
//  TransactionParams.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 06/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import Foundation

struct TransactionParams {
  let idType: IDType
  let id, startDate, endDate, limit, offset: String?
  
  init(idType: IDType, id: String? = nil, startDate: String? = nil, endDate: String? = nil, limit: String? = nil, offset: String? = nil) {
    self.idType = idType
    self.id = id
    self.startDate = startDate
    self.endDate = endDate
    self.limit = limit
    self.offset = offset
  }
  
}

extension TransactionParams {
  enum IDType: String {
    case none = ""
    case cardID
    case reportIDList
    case transactionID
  }
}
