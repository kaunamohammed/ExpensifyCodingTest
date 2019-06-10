//
//  CreateTransactionViewCoordinator.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 06/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import CoordinatorLibrary

public protocol CreateTransactionViewCoordinatorDelegate: class {
  func didCreateTransaction(_ transactionID: String)
}

public final class CreateTransactionViewCoordinator: NavigationCoordinator<CreateTransactionViewController> {
  
  public var authToken: String?
  
  public weak var delegate: CreateTransactionViewCoordinatorDelegate?
  
  override public func start() {

    viewController = .init(viewModel: .init(authToken: authToken.orEmpty, router: Router()))
    navigate(to: viewController, with: .push, animated: true)
    
    viewController.didSuccessfullyCreateTransaction = { [delegate, popViewController] transactionID in
      delegate?.didCreateTransaction(transactionID)
      popViewController(true)
    }
    
  }
  
  deinit {
    delegate = nil
  }
  
}
