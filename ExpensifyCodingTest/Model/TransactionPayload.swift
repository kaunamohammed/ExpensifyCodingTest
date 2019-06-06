//
//  TransactionPayload.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 05/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct TransactionPayload: Codable {
  let jsonCode: Int
  let title, httpCode: Int?
  let transactionList: [TransactionList]?
  let codeRevision, requestID: String
}

// MARK: - TransactionList
struct TransactionList: Codable {
  let amount: Int
  let bank: String?
  let billable: Bool
  let cardID: Int
  let cardName, cardNumber, category, comment: String?
  let created, details, externalID: String?
  let currency: String?
  let inserted: String
  let managedCard: Bool
  let mcc: Int
  let merchant: String
  let modified: Bool
  let reimbursable: Bool
  let reportID, tag, transactionHash, transactionID: String?
  let nameValuePairs: NameValuePairs?
  let unverified: Bool
  let convertedAmount, currencyConversionRate: Int?
  let editable: String
}

// MARK: - NameValuePairs
struct NameValuePairs: Codable {
  let comment: String
}


