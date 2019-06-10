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
    
    viewController = .init(viewModel: .init(router: Router()))
    // here I kick of the navigation with the 'AppCoordinator' viewController
    navigate(to: viewController, with: .set, animated: false)

    viewController.successfullySignedIn = { [startTransactionListViewCoordinator] in
      startTransactionListViewCoordinator(AuthController.authToken)
    }
    
  }

}

private extension SignInViewCoordinator {
  func startTransactionListViewCoordinator(with authToken: String) {
    add(child: transactionListViewCoorinator)
    transactionListViewCoorinator.authToken = authToken
    transactionListViewCoorinator.start()
  }
}

extension UINavigationController {
  func defaultBarPreference(shouldApply: Bool) {
    if shouldApply {
      navigationBar.shadowImage = nil
      navigationBar.setBackgroundImage(nil, for: .default)
      view.backgroundColor = .clear
      navigationBar.barTintColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
    } else {
      navigationBar.shadowImage = UIImage()
      navigationBar.setBackgroundImage(UIImage(), for: .default)
      view.backgroundColor = .clear
    }
  }
}
