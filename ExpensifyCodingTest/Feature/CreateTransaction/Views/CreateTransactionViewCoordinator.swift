//
//  CreateTransactionViewCoordinator.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 06/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import CoordinatorLibrary

protocol CreateTransactionViewCoordinatorDelegate: class {
  func didCreateTransaction(_ transactionID: String)
}

final class CreateTransactionViewCoordinator: NavigationCoordinator<CreateTransactionViewController> {
  
  var authToken: String?
  
  public weak var delegate: CreateTransactionViewCoordinatorDelegate?
  
  override func start() {

    viewController = .init(authToken: authToken.orEmpty, router: Router())
    navigate(to: viewController, with: .push, animated: true)
    
    viewController.didSuccessfullyCreateTransaction = { [delegate] transactionID in
      delegate?.didCreateTransaction(transactionID)
    }
    
  }
  
}
