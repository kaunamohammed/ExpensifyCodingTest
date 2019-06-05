//
//  EndPoint.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 05/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import Foundation

/// An `EndPoint` composes together the api command methods i.e Get, Authenticate and appends URLQueryItems to construct a full url
struct EndPoint: RESTComponent {

  let path: String = "/api"
  /// the query items
  private let queryItems: [URLQueryItem]
  
}

extension EndPoint: URLProducer {
  var url: URL? {
    var components = URLComponents()
    components.scheme = scheme
    components.host = host
    components.path = path
    components.queryItems = queryItems
    return components.url
  }
}


// static factory methods for common endpoints
extension EndPoint {
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
}


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

