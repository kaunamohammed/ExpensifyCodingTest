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
    case success(transactionID: String)
    case failed(title: String?, reason: String?)
  }
  
  public var transactionOutcome: ((CreateTransactionOutcome) -> Void)?
  
  private let authToken: String
  private let router: NetworkRouter
  init(authToken: String, router: NetworkRouter) {
    self.authToken = authToken
    self.router = router
    transactionOutcome?(.none)
  }
  
  public func createTransaction(amount: String, created: String, merchant: String) {
    let amount = String(Int((amount.replacingOccurrences(of: "$", with: "").asDouble * 1000.0)))
    router.request(EndPoint.createTransaction(authToken: authToken,
                                              params: CreateTransactionParams(amount: amount,
                                                                              created: created,
                                                                              merchant: merchant)),
                   completion: { [handle] result in handle(result) })
  }
  
  private func handle(result: Result<Data, Error>) {
    transactionOutcome?(.creating)
    
    switch result {
    case .success(let data):
      do {

        let response: APIResponse = try data.decoded()
        switch response.jsonCode {
        case 200...299:
          transactionOutcome?(.success(transactionID: response.transactionID.orEmpty))
        default:
          transactionOutcome?(.failed(title: nil, reason: "We couldn't create your expense. Please try again"))
        }
      } catch let error {
        print(error)
        transactionOutcome?(.failed(title: nil, reason: "Looks like there was a problem. Please try again later"))
      }
      
    case .failure(let error):
      transactionOutcome?(.failed(title: nil, reason: error.localizedDescription))
    }
  }
  
}
