//
//  TransactionListViewModel.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 08/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import Foundation

public struct TransactionListViewModel {
  
  public enum TransactionListOutcome {
    case loading
    case loaded(transactions: [TransactionList])
    case failed(title: String?, reason: String?)
  }
  
  public var forcedReload: ((Bool) -> Void)?
  public var transactionListOutcome: ((TransactionListOutcome) -> Void)?
  
  public var token: String {
    return authToken
  }
  
  private let authToken: String
  private let router: NetworkRouter
  
  public init(authToken: String, router: NetworkRouter) {
    self.authToken = authToken
    self.router = router
  }
  
  public func loadData(force: Bool = false) {
    transactionListOutcome?(.loading)
    forcedReload?(force)
    router.request(EndPoint.getTransactions(authToken: authToken, params: TransactionParams(idType: .none,
                                                                                            endDate: Date.nowString(),
                                                                                            limit: 100.asString)),
                   completion: { [handle] result in handle(result, force) })
  }
  
  private func handle(result: Result<Data, NetworkError>, isReloaded: Bool) {
    switch result {
    case .success(let data):
      do {
        // here i'm taking advantage of the decoded() extension on `Data`
        let payload: TransactionPayload = try data.decoded()
        switch payload.jsonCode {
        case 200...299:
           forcedReload?(isReloaded)
          transactionListOutcome?(.loaded(transactions: payload.transactionList ?? []))
        default:
          forcedReload?(isReloaded)
          transactionListOutcome?(.failed(title: nil, reason: "We couldn't retrieve your transactions"))
        }
      } catch let error {
        print(error)
        forcedReload?(isReloaded)
      }
      
    case .failure(let error):
      forcedReload?(isReloaded)
      transactionListOutcome?(.failed(title: nil, reason: error.errorDescription.orEmpty))
    }
  }
  
}
