//
//  NetworkError.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 05/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import Foundation

enum NetworkError: String, Error {
  case unknown
  case unrecognizedCommand
  case missingArgument
  case malformedOrExpiredToken
  case accountDeleted = "Looks like this account has been deleted"
  case insufficientPrivelages
  case aborted
  case dbTransactionError
  case queryError
  case QueryResponseError
  case unrecognizedObjectState
}
