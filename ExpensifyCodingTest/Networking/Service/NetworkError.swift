//
//  NetworkError.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 05/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import Foundation

public enum NetworkError {
  case unknown
  case unrecognizedCommand
  case missingArgument
  case malformedOrExpiredToken
  case accountDeleted
  case insufficientPrivelages
  case aborted
  case dbTransactionError
  case queryError
  case QueryResponseError
  case unrecognizedObjectState
  case requestFailure
}

extension NetworkError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .accountDeleted: return "Looks like this account has been deleted"
    case .requestFailure: return "There was an error reaching our network. Please try again when there's better service"
    default: return "An internal error has occured. Please wait a little and try again"
    }
  }
}
