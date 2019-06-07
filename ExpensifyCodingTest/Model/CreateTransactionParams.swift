//
//  CreateTransactionParams.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 06/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import Foundation

struct CreateTransactionParams: Encodable { 
  
  let amount: String
  let created, merchant: String
  let currency, comment, category, tag, receiptID: String?
  let reimbursable, billable: Bool
  
  init(amount: String, created: String, merchant: String, currency: String? = nil, comment: String? = nil, category: String? = nil, tag: String? = nil, receiptID: String? = nil, reimbursable: Bool = false, billable: Bool = true) {
    self.amount = amount
    self.created = created
    self.merchant = merchant
    self.currency = currency
    self.comment = comment
    self.category = category
    self.tag = tag
    self.receiptID = receiptID
    self.reimbursable = reimbursable
    self.billable = billable
  }
  
}
