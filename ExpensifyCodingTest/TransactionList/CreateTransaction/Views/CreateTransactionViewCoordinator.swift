//
//  CreateTransactionViewCoordinator.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 06/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import CoordinatorLibrary

final class CreateTransactionViewCoordinator: NavigationCoordinator<CreateTransactionViewController> {
  
  var authToken: String?
  
  override func start() {
    
    viewController = .init(authToken: authToken.orEmpty, router: Router())
    navigate(to: viewController, with: .push, animated: true)
    
  }
  
}
