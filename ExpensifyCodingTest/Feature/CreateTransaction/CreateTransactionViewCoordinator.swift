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
  func didCreateTransaction()
}

public final class CreateTransactionViewCoordinator: NavigationCoordinator<CreateTransactionViewController> {
  
  public var authToken: String?
  
  /// weak reference to delegate to avoid retain cycle
  public weak var delegate: CreateTransactionViewCoordinatorDelegate? = nil
  
  override public func start() {

    viewController = .init(viewModel: .init(authToken: authToken.orEmpty, router: Router()))
    navigate(to: viewController, with: .push, animated: true)
    
    viewController.didSuccessfullyCreateTransaction = { [weak self] in
      self?.delegate?.didCreateTransaction()
      self?.popViewController(animated: true)
    }
    
  }
  
}
