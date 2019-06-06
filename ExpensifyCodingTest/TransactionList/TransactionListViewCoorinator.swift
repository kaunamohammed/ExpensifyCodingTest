//
//  TransactionListViewCoorinator.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 06/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import CoordinatorLibrary

final class TransactionListViewCoorinator: NavigationCoordinator<TransactionListViewController> {
  
  public var apiResponse: APIResponse!
  
  override func start() {
    
    viewController = .init(authToken: apiResponse.authToken.orEmpty)
    navigate(to: viewController, with: .set, animated: false)
    
  }
  
}
