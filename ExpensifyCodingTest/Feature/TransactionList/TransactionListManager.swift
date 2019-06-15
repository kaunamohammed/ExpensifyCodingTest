//
//  NetworkManager.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 07/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import Foundation

public class TransactionListManager {

  private let router: NetworkRouter
  public init(router: NetworkRouter) {
    self.router = router
  }
  
  public func getTransactions(authToken: String, completion: @escaping (Result<[TransactionList], ApiJsonCodeResponse>) -> Void) {
    router.request(EndPoint.getTransactions(authToken: authToken,
                                            params: TransactionParams(idType: .none,
                                                                      endDate: Date.nowString(),
                                                                      limit: 100.asString)),
                   completion: { result in

                    switch result {
                      
                    case .success(let data):
                      do {
                        let response: TransactionResponse = try data.decoded()
                        switch response.jsonCode {
                        case 200: completion(.success(response.transactionList ?? []))
                        case 400: completion(.failure(.unrecognizedCommand))
                        case 402: completion(.failure(.missingArgument))
                        case 407: completion(.failure(.malformedOrExpiredToken))
                        case 408: completion(.failure(.accountDeleted))
                        case 411: completion(.failure(.insufficientPrivelages))
                        case 500: completion(.failure(.aborted))
                        case 501: completion(.failure(.dbTransactionError))
                        case 502: completion(.failure(.queryError))
                        case 503: completion(.failure(.queryResponseError))
                        case 504: completion(.failure(.unrecognizedObjectState))
                        default: completion(.failure(.unknown(reason: "")))
                        }
                      } catch let error {
                        completion(.failure(.unknown(reason: error.localizedDescription)))
                      }
                      
                    case .failure(let error):
                      completion(.failure(.unknown(reason: error.localizedDescription)))
                    }
                    
    })
  }
  
}


public enum ApiJsonCodeResponse {
  case unknown(reason: String)
  case unrecognizedCommand
  case missingArgument
  case malformedOrExpiredToken
  case accountDeleted
  case insufficientPrivelages
  case aborted
  case dbTransactionError
  case queryError
  case queryResponseError
  case unrecognizedObjectState
  case requestFailure
}

extension ApiJsonCodeResponse: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .insufficientPrivelages: return "Insufficeient privelages"
    case .unrecognizedCommand: return "We do not recognize this command"
    case .missingArgument: return "missing argument"
    case .aborted: return "aborted"
    case .dbTransactionError: return "transaction error"
    case .queryError: return "query error"
    case .queryResponseError: return "response error"
    case .unrecognizedObjectState: return "object not recognized"
    case .malformedOrExpiredToken: return "Your session seems to have expired. Please try signing in again"
    case .accountDeleted: return "Looks like this account has been deleted"
    case .requestFailure: return "There was an error reaching our network. Please try again when there's better service"
    case .unknown(let reason) : return reason
  
    }
  }
}
