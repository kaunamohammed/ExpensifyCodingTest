//
//  SignInViewCoordinator.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 05/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import CoordinatorLibrary

public final class SignInViewCoordinator: ChildCoordinator<SignInViewController> {
  
  private var transactionListViewCoorinator: TransactionListViewCoorinator? = nil
  
  private let persistenceManager: PersistenceManager
  public init(persistenceManager: PersistenceManager, presenter: UINavigationController, removeCoordinator: @escaping ((Coordinatable) -> ())) {
    self.persistenceManager = persistenceManager
    super.init(presenter: presenter, removeCoordinator: removeCoordinator)
  }
  
  override public func start() {
    
    // initialize the viewController
    // If someone tried to use a `TransactionListViewController` here the code won't compile, enforcing type-safety
    
    // also using type inference to leave out a full definition i.e SignInViewCoordinator(viewModel: SignInViewModel(manager: SignInManager(router: Router())))
    viewController = .init(viewModel: .init(manager: .init(router: Router())))
    
    navigate(to: viewController, with: .set, animated: false)

    // when the user successfully signs in, the coordinator receives a callback notifying it that sign in was successful and to start the `TransactionListViewCoorinator`
    viewController.successfullySignedIn = { [weak self] in
      self?.startTransactionListViewCoordinator(with: AuthController.authToken)
    }
    
  }

}

// MARK: Child Coordinators
private extension SignInViewCoordinator {
  func startTransactionListViewCoordinator(with authToken: String) {
    transactionListViewCoorinator = .init(persistenceManager: persistenceManager,
                                          presenter: presenter,
                                          removeCoordinator: remove)
    add(child: transactionListViewCoorinator!)
    transactionListViewCoorinator!.authToken = authToken
    transactionListViewCoorinator!.start()
  }
}
