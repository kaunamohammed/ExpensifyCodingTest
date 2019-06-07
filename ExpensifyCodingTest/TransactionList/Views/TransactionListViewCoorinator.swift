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
  
  private lazy var createTransactionViewCoordinator: CreateTransactionViewCoordinator = .init(presenter: presenter,
                                                                                              removeCoordinator: remove)
  private lazy var signInViewCoordinator: SignInViewCoordinator = .init(presenter: presenter,
                                                                        removeCoordinator: remove)
  
  override func start() {
    
    viewController = .init(authToken: apiResponse.authToken.orEmpty, router: Router())
    
    navigate(to: viewController, with: .set, animated: false)
    
    viewController.goToCreateTransactionScreen = { [startCreateTransactionViewCoordinator] authToken in
      startCreateTransactionViewCoordinator(authToken)
    }
    
    viewController.logOut = { [startSignInViewCoordinator] in startSignInViewCoordinator() }
    
  }
  
}

private extension TransactionListViewCoorinator {
  
  func startCreateTransactionViewCoordinator(with token: String) {
    add(child: createTransactionViewCoordinator)
    createTransactionViewCoordinator.authToken = token
    createTransactionViewCoordinator.start()
  }
  
  func startSignInViewCoordinator() {
    add(child: signInViewCoordinator)
    signInViewCoordinator.start()
  }
}
