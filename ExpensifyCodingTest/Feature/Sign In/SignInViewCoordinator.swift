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
    // If someone tried to use a `TransactionListViewController` here the code won't compile, enforcing type-safety
    
    // also using type inference to leave out a full definition i.e SignInViewCoordinator(viewModel: SignInViewModel(router: Router()))
    viewController = .init(viewModel: .init(router: Router()))
    
    // here I kick of the navigation with the 'AppCoordinator' presenter to `SignInViewController`
    navigate(to: viewController, with: .set, animated: false)

    // when the user successfully signs in, the coordinator receives a allback notifying it to start the `TransactionListViewCoorinator`
    viewController.successfullySignedIn = { [weak self] in
      self?.startTransactionListViewCoordinator(with: AuthController.authToken)
    }
    
  }

}

// MARK: Child Coordinators
private extension SignInViewCoordinator {
  func startTransactionListViewCoordinator(with authToken: String) {
    add(child: transactionListViewCoorinator)
    transactionListViewCoorinator.authToken = authToken
    transactionListViewCoorinator.start()
  }
}
