//
//  TransactionListViewModel.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 09/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import Foundation

public struct TransactionListViewModel {
  
  public enum TransactionListOutcome {
    case loading
    case loaded(transactions: [TransactionList])
    case failed(title: String?, reason: String?)
  }
  
  /// notifies the view controller if it was force reloaded
  public var forcedReload: ((Bool) -> Void)?
  
  /// notifies the view controller if sign out was successful
  public var signOutSuccess: (() -> Void)?
  
  /// notifies the view controller of an error while signing out
  public var errorSigningOutMessage: ((String) -> Void)?
  
  /// notifies the view controller of the current state of the data retrieval from the API
  public var transactionListOutcome: ((TransactionListOutcome) -> Void)?
  
  /// a read-only property to access the authToken
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
  
  /**
   
   loads the data to be confused
   
   - parameter isInitialLoad: whether this is the initial loading of data
   
   */
  public func loadData(isInitialLoad: Bool = false) {
    transactionListOutcome?(.loading)
    forcedReload?(isInitialLoad)
    
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
