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
  
  private lazy var transactionDetailViewCoordinator: TransactionDetailViewCoordinator = .init(presenter: presenter,
                                                                                              removeCoordinator: remove)
  
  private lazy var createTransactionViewCoordinator: CreateTransactionViewCoordinator = .init(presenter: presenter,
                                                                                              removeCoordinator: remove)
  private lazy var signInViewCoordinator: SignInViewCoordinator = .init(presenter: presenter,
                                                                        removeCoordinator: remove)
  
  override public func start() {
        
    viewController = .init(viewModel: .init(authToken: authToken, manager: .init()), coordinator: self)
    navigate(to: viewController, with: .push, animated: false)
    
    viewController.goToTransactionDetailScreen = { [startTransactionDetailViewCoordinator] detail in
      startTransactionDetailViewCoordinator(detail)
    }
    
    viewController.goToCreateTransactionScreen = { [startCreateTransactionViewCoordinator, authToken] in
      startCreateTransactionViewCoordinator(authToken.orEmpty)
    }
    
    viewController.didTapToSignOut = { [startSignInViewCoordinator] in startSignInViewCoordinator()
    }
    
  }
  
}

// MARK: - CreateTransactionViewCoordinatorDelegate
extension TransactionListViewCoorinator: CreateTransactionViewCoordinatorDelegate {
  
  public func didCreateTransaction(_ transactionID: String) {
    newlyCreatedTransactionID?(transactionID)
  }
  
}

// MARK: Child Coordinators
private extension TransactionListViewCoorinator {
  
  func startTransactionDetailViewCoordinator(with detail: TransactionDetail) {
    add(child: transactionDetailViewCoordinator)
    transactionDetailViewCoordinator.transactionDetail = detail
    transactionDetailViewCoordinator.start()
  }
  
  func startCreateTransactionViewCoordinator(with token: String) {
    add(child: createTransactionViewCoordinator)
    createTransactionViewCoordinator.authToken = token
    createTransactionViewCoordinator.delegate = self
    createTransactionViewCoordinator.start()
  }
  
  func startSignInViewCoordinator() {
    add(child: signInViewCoordinator)
    presenter.defaultBarPreference(shouldApply: false)
    signInViewCoordinator.start()
  }
  
}
