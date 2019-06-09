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
  public var signOutSuccess: (() -> Void)?
  public var errorSigningOutMessage: ((String) -> Void)?
  public var transactionListOutcome: ((TransactionListOutcome) -> Void)?
  
  public var token: String {
    return authToken
  }
  
  private let authToken: String
  private let manager: TransactionListManager
  
  public init(authToken: String, manager: TransactionListManager) {  
    self.authToken = authToken
    self.manager = manager
  }
  
  public func signOut() throws {
    return try AuthController.signOut()
  }
  
  public func loadData(force: Bool = false) {
    transactionListOutcome?(.loading)
    forcedReload?(force)
    
    manager.getTransactions(authToken: authToken,
                            completion: { [transactionListOutcome] result in
                              switch result {
                              case .success(let transactions):
                                transactionListOutcome?(.loaded(transactions: transactions))
                              case .failure(let error):
                                transactionListOutcome?(.failed(title: nil, reason: error.errorDescription))
                              }
    })
    
  }
  
}
