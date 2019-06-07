//
//  TransactionListViewCoorinator.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 06/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import CoordinatorLibrary

final class TransactionListViewCoorinator: ChildCoordinator<TransactionListViewController> {
  
  public var apiResponse: APIResponse!
  
  public var createdTransactionID: ((String) -> Void)?
  
  private lazy var createTransactionViewCoordinator: CreateTransactionViewCoordinator = .init(presenter: presenter,
                                                                                              removeCoordinator: remove)
  private lazy var signInViewCoordinator: SignInViewCoordinator = .init(presenter: presenter,
                                                                        removeCoordinator: remove)
  
  override func start() {
    
    viewController = .init(authToken: apiResponse.authToken.orEmpty, router: Router(), coordinator: self)
    
    navigate(to: viewController, with: .set, animated: false)
    
    viewController.goToCreateTransactionScreen = { [startCreateTransactionViewCoordinator] authToken in
      startCreateTransactionViewCoordinator(authToken)
    }
    
    viewController.didTapTologOut = { [startSignInViewCoordinator] in startSignInViewCoordinator() }
    
  }
  
}

extension TransactionListViewCoorinator: CreateTransactionViewCoordinatorDelegate {
  
  func didCreateTransaction(_ transactionID: String) {
    createdTransactionID?(transactionID)
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
