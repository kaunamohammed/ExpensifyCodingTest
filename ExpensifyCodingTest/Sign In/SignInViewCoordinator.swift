//
//  SignInViewCoordinator.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 05/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import CoordinatorLibrary

// here I have marked the class final because there's no need to inherit from it
final class SignInViewCoordinator: ChildCoordinator<SignInViewController> {
  
  private lazy var transactionListViewCoorinator: TransactionListViewCoorinator = .init(presenter: presenter,
                                                                                        removeCoordinator: remove)
  
  override func start() {
    
    // initialize the viewController
    // If someone tried to use a `TransactionListViewController` here we won't be able to compile, enforcing type-safety
    // also using type inference to leave out a full definition i.e SignInViewCoordinator(router: Router())
    viewController = .init(router: Router())
    
    // here I kick of the navigation with the 'AppCoordinator' viewController
    navigate(to: viewController, with: .set, animated: false)
    
    viewController.successfullySignedIn = { [startTransactionListViewCoordinator] apiResponse in
      startTransactionListViewCoordinator(apiResponse)
    }
    
  }

}

extension SignInViewCoordinator {
  private func startTransactionListViewCoordinator(with response: APIResponse) {
    add(child: transactionListViewCoorinator)
    transactionListViewCoorinator.apiResponse = response
    transactionListViewCoorinator.start()
  }
}
