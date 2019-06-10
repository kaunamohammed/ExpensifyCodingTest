//
//  TransactionListViewCoordinator.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 09/06/2019.
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
  
  public var isNavigatedTo = false
  
  override public func start() {
        
    viewController = .init(viewModel: .init(authToken: authToken, manager: .init()), coordinator: self)
    navigate(to: viewController, with: .push, animated: false)
    
    viewController.goToCreateTransactionScreen = { [startCreateTransactionViewCoordinator, authToken] in
      startCreateTransactionViewCoordinator(authToken.orEmpty)
    }
    
    viewController.didTapToSignOut = { [isNavigatedTo, popViewController, startSignInViewCoordinator] in
      isNavigatedTo ? popViewController(true) : startSignInViewCoordinator()
    }
    
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
    printChildCount()
    add(child: createTransactionViewCoordinator)
    printChildCount()
    createTransactionViewCoordinator.authToken = token
    createTransactionViewCoordinator.delegate = self
    createTransactionViewCoordinator.start()
  }
  
  func startSignInViewCoordinator() {
    isNavigatedTo = false
    printChildCount()
    add(child: signInViewCoordinator)
    printChildCount()
    presenter.defaultBarPreference(shouldApply: false)
    delay(seconds: 0.1) {
      self.signInViewCoordinator.start()
    }
  }
  
}
