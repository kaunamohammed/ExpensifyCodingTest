//
//  TransactionListViewCoorinator.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 06/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import CoordinatorLibrary

public final class TransactionListViewCoorinator: ChildCoordinator<TransactionListViewController> {
  
  public var authToken: String!
  
  public var newlyCreatedTransactionID: ((String) -> Void)?
  
  private lazy var createTransactionViewCoordinator: CreateTransactionViewCoordinator = .init(presenter: presenter,
                                                                                              removeCoordinator: remove)
  private lazy var signInViewCoordinator: SignInViewCoordinator = .init(presenter: presenter,
                                                                        removeCoordinator: remove)
  
  var viewModel: TransactionListViewModel!
  
  override public func start() {
    viewModel = TransactionListViewModel(authToken: authToken, router: Router())

    viewController = .init(viewModel: viewModel, coordinator: self)
    navigate(to: viewController, with: .set, animated: false)
    
    viewController.goToCreateTransactionScreen = { [startCreateTransactionViewCoordinator, authToken] in
      startCreateTransactionViewCoordinator(authToken.orEmpty)
    }
    
    
    viewController.didTapToSignOut = { [startSignInViewCoordinator] in startSignInViewCoordinator() }
    
  }
  
}

// MARK: - CreateTransactionViewCoordinatorDelegate
extension TransactionListViewCoorinator: CreateTransactionViewCoordinatorDelegate {
  
  public func didCreateTransaction(_ transactionID: String) {
    newlyCreatedTransactionID?(transactionID)
  }
  
}

private extension TransactionListViewCoorinator {
  
  func startCreateTransactionViewCoordinator(with token: String) {
    add(child: createTransactionViewCoordinator)
    createTransactionViewCoordinator.authToken = token
    createTransactionViewCoordinator.delegate = self
    createTransactionViewCoordinator.start()
  }
  
  func startSignInViewCoordinator() {
    add(child: signInViewCoordinator)
    signInViewCoordinator.start()
  }
}
