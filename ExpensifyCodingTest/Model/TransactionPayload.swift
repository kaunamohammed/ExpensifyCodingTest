//
//  TransactionPayload.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 05/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import Foundation
import CoreData

// MARK: - TransactionPayload
public struct TransactionPayload: Decodable {
  let jsonCode: Int
  let httpCode: Int?
  let transactionList: [TransactionList]?
  let title, message, transactionID, codeRevision, requestID: String?
}

// MARK: - CDDBTransactionList
public class DBTransactionList: NSManagedObject {
  
}

extension DBTransactionList {
  
  @NSManaged public var amount: Int64
  @NSManaged public var category: String?
  @NSManaged public var comment: String?
  @NSManaged public var created: String?
  @NSManaged public var currency: String?
  @NSManaged public var merchant: String
  @NSManaged public var reimbursable: Bool
  
}

// MARK: - TransactionList
public struct TransactionList: Decodable {
  
  let amount: Int
  let category, comment: String?
  let created: String?
  let currency: String?
  let merchant: String
  let reimbursable: Bool
  
}

extension TransactionList {
  init(dbTransactionList: DBTransactionList) {
    self.amount = Int(dbTransactionList.amount)
    self.category = dbTransactionList.category
    self.currency = dbTransactionList.currency
    self.created = dbTransactionList.created
    self.comment = dbTransactionList.comment
    self.merchant = dbTransactionList.merchant
    self.reimbursable = dbTransactionList.reimbursable
  }
  
  
  func mapTo(dbTransactionList: DBTransactionList) {
    dbTransactionList.amount = Int64(amount)
    dbTransactionList.category = category
    dbTransactionList.created = created
    dbTransactionList.comment = comment
    dbTransactionList.created = created
    dbTransactionList.merchant = merchant
    dbTransactionList.reimbursable = reimbursable
  }
  
}
