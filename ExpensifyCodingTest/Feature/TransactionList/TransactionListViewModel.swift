//
//  TransactionListViewModel.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 09/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import Foundation

public class TransactionListViewModel {
  
  public enum TransactionListOutcome {
    case loading
    case loaded
    case failed(title: String?, message: String?)
  }
  
  ///
  public var dateFormatter = DateFormatter()
    
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
  
  private var dbtransactions = [DBTransactionList]()
  
  private let authToken: String
  private let manager: TransactionListManager
  private let persistenceManager: PersistenceManager = .shared
  public init(authToken: String, manager: TransactionListManager) {
    self.authToken = authToken
    self.manager = manager
    
    do {
      dbtransactions = try (self.persistenceManager.context.fetch(DBTransactionList.fetchRequest()) as? [DBTransactionList] ?? [])
    } catch _ {
      transactionListOutcome?(.failed(title: nil, message: "Couldn't retrieve your transactions."))
    }
    
  }
  
  public func signOut() throws {
    return try AuthController.signOut()
  }
  
  public func currency(from currencyCode: CurrencyCode, amount: Double) -> String? {
    let formatter = NumberFormatter()
    formatter.usesGroupingSeparator = true
    formatter.numberStyle = .currency
    formatter.currencyCode = currencyCode.string
    return formatter.string(from: NSNumber(value: amount))
  }
  
  /**
   
   loads the data to be confused
   
   - parameter isInitialLoad: whether this is the initial loading of data
   
   */
  public func loadData(isInitialLoad: Bool = false) {
    transactionListOutcome?(.loading)
    forcedReload?(isInitialLoad)
    
    manager.getTransactions(authToken: authToken,
                            completion: { [weak self] result in
                              guard let strongSelf = self else { return }
                              switch result {
                              case .success(let transactions):
                                
                                // deletes all objects currently in the data store
                                strongSelf.dbtransactions.forEach { strongSelf.persistenceManager.context.delete($0) }
                                
                                // maps transactions received from .success to an array of DBTransactionList
                                transactions.forEach { $0
                                  .mapTo(dbTransactionList: .init(context: strongSelf.persistenceManager.context))  }
                                
                                // saves the data to the store
                                strongSelf.persistenceManager.save()
                                
                                // attepts to fetch the transactions
                                do {
                                  strongSelf.dbtransactions = try strongSelf.persistenceManager.context.fetch(DBTransactionList.fetchRequest()) as? [DBTransactionList] ?? []
                                  
                                  strongSelf.transactionListOutcome?(.loaded)
                                  
                                } catch _ {
                                  strongSelf.transactionListOutcome?(.failed(title: nil, message: "Couldn't retrieve your transactions."))
                                }
                                
                              case .failure(let error):
                                strongSelf.transactionListOutcome?(.failed(title: "Offline mode enabled", message: error.errorDescription))
                              }
    })
    
  }
  
}

// MARK: - Helpers
extension TransactionListViewModel {
  
  private var transactions: [[TransactionList]] {
    return groupByDate(list: dbtransactions.map(TransactionList.init))
  }
  
  public func item(for indexPath: IndexPath) -> TransactionList {
    return transactions[indexPath.section][indexPath.row]
  }
  
  public func title(for section: Int) -> String? {
    return transactions[section].first?.created
  }
  
  public func numberOfSections() -> Int {
    return transactions.count
  }
  
  public func numberOfRows(for section: Int) -> Int {
    return transactions[section].count
  }
  
  private func groupByDate(list: [TransactionList]) -> [[TransactionList]] {
    
    var transactionListGroupedByDate: [[TransactionList]] = [[]]
    
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    let groupedByDate = Dictionary(grouping: list) { (element) -> Date in
      let date = dateFormatter.date(from: element.created.orEmpty)
      return date!
    }
    groupedByDate.keys.sorted(by: { $0 > $1 }).forEach { key in
      let values = groupedByDate[key]
      transactionListGroupedByDate.append(values ?? [])
    }
    
    return transactionListGroupedByDate
  }
  
}
