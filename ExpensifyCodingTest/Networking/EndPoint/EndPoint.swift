//
//  EndPoint.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 05/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import Foundation

/// An `EndPoint` composes together the api command methods i.e Get, Authenticate and appends URLQueryItems to construct a full url
public struct EndPoint: RESTComponent {

  public let path: String = "/api"
  /// the query items
  private let queryItems: [URLQueryItem]
  
}

extension EndPoint: URLProducer {
  public var url: URL? {
    var components = URLComponents()
    components.scheme = scheme
    components.host = host
    components.path = path
    components.queryItems = queryItems.removeNilValues() 
    return components.url
  }
}

// static factory methods for common endpoints
public extension EndPoint {
  /**
   
   authenticates a user
   
   - parameter partnerName: partner name
   - parameter partnerPassword: partner password
   - parameter partnerUserID: user email address or other identifier
   - parameter partnerUserSecret: user password
   
   - returns: A new `EndPoint` consisting of the parameters above

   */
  static func authenticateUser(with partnerName: String = Constants.Partner.name,
                               partnerPassword: String = Constants.Partner.password,
                               partnerUserID: String,
                               partnerUserSecret: String) -> EndPoint {
    return EndPoint(
      queryItems: [
        URLQueryItem(name: "command", value: "Authenticate"),
        URLQueryItem(name: "partnerName", value: partnerName),
        URLQueryItem(name: "partnerPassword", value: partnerPassword),
        URLQueryItem(name: "partnerUserID", value: partnerUserID),
        URLQueryItem(name: "partnerUserSecret", value: partnerUserSecret),
      ])
  }
  
  /**
   
   lists the transactions for the currently signed in user
   
   - parameter authToken: The authToken for the current session
   - parameter params: The list to return to the user
   
   - returns: A new `EndPoint` consisting of the parameters above
   
   - note: Although this meets the minimum requirements of the checklist, If I were to develop this further, I would most likely use a protocol to compose some of the params in the returnValueList options in order to reduce code duplication and reuse this function

   */
  static func getTransactions(authToken: String, params: TransactionParams) -> EndPoint {
    return EndPoint(
      queryItems: [
        URLQueryItem(name: "command", value: "Get"),
        URLQueryItem(name: "authToken", value: authToken),
        URLQueryItem(name: "returnValueList", value: "transactionList"),
        URLQueryItem(name: params.idType.rawValue, value: params.startDate),
        URLQueryItem(name: "startDate", value: params.startDate),
        URLQueryItem(name: "endDate", value: params.endDate),
        URLQueryItem(name: "limit", value: params.limit),
        URLQueryItem(name: "offset", value: params.offset)
      ])
  }
  
  /**
   
   create a transactionsfor the currently signed in user
   
   - parameter authToken: The authToken for the current session
   - parameter params: The params to create the transaction with
   
   - returns: A new `EndPoint` consisting of the parameters above
   
   - note: Although this meets the minimum requirements of the checklist, If I were to develop this further, I would most likely use a protocol to compose some of the params in the returnValueList options in order to reduce code duplication and reuse this function
   
   */
  static func createTransaction(authToken: String, params: CreateTransactionParams) -> EndPoint {
    return EndPoint(
      queryItems: [
        URLQueryItem(name: "command", value: "CreateTransaction"),
        URLQueryItem(name: "authToken", value: authToken),
        URLQueryItem(name: "amount", value: params.amount),
        URLQueryItem(name: "created", value: params.created),
        URLQueryItem(name: "merchant", value: params.merchant),
        URLQueryItem(name: "category", value: params.category),
        URLQueryItem(name: "comment", value: params.comment),
        URLQueryItem(name: "currency", value: params.currency),
        URLQueryItem(name: "receiptID", value: params.receiptID),
        URLQueryItem(name: "tag", value: params.tag),
      ])
  }
  
}
