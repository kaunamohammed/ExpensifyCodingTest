//
//  ExpensifyAppCoordinator.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 05/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import CoordinatorLibrary

/**
 'AppCoordinator' is similar to the 'AppDelegate' class in the sense that it launches all other coordinators used in the app
 
 It inherits from the `ChildCoordinator` base class which encapsulates the implementation details having to do with navigation and child coordinator management i.e adding/removing a child coordinator
 
 I could mark this class as `final` but incase I want to kick of a different navigation flow based on business logic I'll like to inherit from this class
 */
public class ExpensifyAppCoordinator: AppCoordinator {
  
  private lazy var signInViewCoordinator: SignInViewCoordinator = .init(persistenceManager: persistenceManager,
                                                                        presenter: presenter,
                                                                        removeCoordinator: remove)
  
  private lazy var transactionListViewCoorinator: TransactionListViewCoorinator = .init(persistenceManager: persistenceManager,
                                                                                        presenter: presenter,
                                                                                        removeCoordinator: remove)
  
  private let persistenceManager: PersistenceManager
  init(persistenceManager: PersistenceManager = .shared,
       presenter: UINavigationController,
       window: UIWindow) {
    self.persistenceManager = persistenceManager
    super.init(presenter: presenter, window: window)
  }
  
  override public func start() {
        
    AuthController.isSignedIn ?
      startTransactionListViewCoordinator(with: AuthController.authToken) : startSignInViewCoordinator()

  }
  
}

// MARK: Child Coordinators
private extension ExpensifyAppCoordinator {
  
  func startSignInViewCoordinator() {
    add(child: signInViewCoordinator)
    signInViewCoordinator.start()
  }
  
  func startTransactionListViewCoordinator(with token: String) {
    add(child: transactionListViewCoorinator)
    transactionListViewCoorinator.authToken = token
    transactionListViewCoorinator.start()
  }

  
}
