//
//  CreateTransactionViewModel.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 08/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import Foundation

public struct CreateTransactionViewModel {
  
  public enum CreateTransactionOutcome {
    case none
    case creating
    case success
    case failed(title: String?, reason: String?)
  }
  
  /// notifies the view controller of the current state of the outcome of creating the transaction
  public var transactionOutcome: ((CreateTransactionOutcome) -> Void)?
  
  private let authToken: String
  private let router: NetworkRouter
  init(authToken: String, router: NetworkRouter) {
    self.authToken = authToken
    self.router = router
    transactionOutcome?(.none)
  }
  
  public func createTransaction(amount: String, created: String, merchant: String) {
    transactionOutcome?(.creating)

    let amount = String(Int((amount.replacingOccurrences(of: "$", with: "").asDouble * 1000.0)))
    router.request(EndPoint.createTransaction(authToken: authToken,
                                              params: CreateTransactionParams(amount: amount,
                                                                              created: created,
                                                                              merchant: merchant)),
                   completion: { result in self.handle(result: result) })
  }
  
}

private extension CreateTransactionViewModel {
  func handle(result: Result<Data, Error>) {
    assert(Thread.isMainThread, GlobalConstants.ErrorMessage.notOnMainThread)
    switch result {
    case .success(let data):
      do {
        
        let response: APIResponse = try data.decoded()
        switch response.jsonCode {
        case 200...299:
          transactionOutcome?(.success)
        default:
          transactionOutcome?(.failed(title: nil, reason: GlobalConstants.ErrorMessage.couldntRetrieveExpenses))
        }
      } catch _ {
        transactionOutcome?(.failed(title: nil, reason: GlobalConstants.ErrorMessage.internalError2))
      }
      
    case .failure(let error):
      transactionOutcome?(.failed(title: nil, reason: error.localizedDescription))
    }
  }
}
