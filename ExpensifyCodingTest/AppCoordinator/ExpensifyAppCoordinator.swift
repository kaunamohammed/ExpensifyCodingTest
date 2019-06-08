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
  
  private lazy var signInViewCoordinator: SignInViewCoordinator = .init(presenter: presenter,
                                                                        removeCoordinator: remove)
  
  private lazy var transactionListViewCoorinator: TransactionListViewCoorinator = .init(presenter: presenter,
                                                                                        removeCoordinator: remove)
  
  override public func start() {
    
    presenter.navigationBar.barTintColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
    presenter.navigationBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    presenter.navigationBar.titleTextAttributes = [.foregroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)]
    
    startSignInViewCoordinator()
    
  }
  
}

private extension ExpensifyAppCoordinator {
  
  func startSignInViewCoordinator() {
    signInViewCoordinator = SignInViewCoordinator(presenter: presenter,
                                                  removeCoordinator: remove)
    
    // adding the signInViewCoordinator to the Coordinator Hierachy
    add(child: signInViewCoordinator)
    // calling start to trigger the navigation to signInViewCoordinator
    signInViewCoordinator.start()
  }
  
}

//  func startTransactionListViewCoordinator(with response: APIResponse = .init(accountID: nil,
//                                                                              httpCode: nil,
//                                                                              jsonCode: 200,
//                                                                              authToken: UUID().uuidString,
//                                                                              email: "email",
//                                                                              requestID: UUID().uuidString)) {
//    transactionListViewCoorinator = .init(presenter: presenter, removeCoordinator: remove)
//    add(child: transactionListViewCoorinator!)
//    transactionListViewCoorinator?.apiResponse = response
//    transactionListViewCoorinator!.start()
//  }
