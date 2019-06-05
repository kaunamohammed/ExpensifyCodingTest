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
  
  override func start() {
    
    // initialize the viewController
    // If someone tried to use a `TransactionListViewController` here we won't be able to compile, enforcing type-safety
    viewController = SignInViewController()
    
    // here I kick of the navigation with the 'AppCoordinator' viewController
    navigate(to: viewController, with: .push, animated: false)
  }
  
}
