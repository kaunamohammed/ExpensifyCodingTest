//
//  CreateTransactionViewCoordinator.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 06/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import CoordinatorLibrary

/**
 
 A delegate that offers the implementation for when a transaction was created
 
 */
public protocol CreateTransactionViewCoordinatorDelegate: class {
  func didCreateTransaction(_ transactionID: String)
}

public final class CreateTransactionViewCoordinator: NavigationCoordinator<CreateTransactionViewController> {
  
  public var authToken: String?
  
  /// weak reference to delegate to avoid retain cycle
  public weak var delegate: CreateTransactionViewCoordinatorDelegate?
  
  override public func start() {

    viewController = .init(viewModel: .init(authToken: authToken.orEmpty, router: Router()))
    navigate(to: viewController, with: .push, animated: true)
    
    viewController.didSuccessfullyCreateTransaction = { [weak self] transactionID in
      self?.delegate?.didCreateTransaction(transactionID)
      self?.popViewController(animated: true)
    }
    
  }
  
  deinit {
    delegate = nil
  }
  
}
