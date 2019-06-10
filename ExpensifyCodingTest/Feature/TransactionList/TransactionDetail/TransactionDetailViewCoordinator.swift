//
//  TransactionDetailViewCoordinator.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 10/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import CoordinatorLibrary

public final class TransactionDetailViewCoordinator: NavigationCoordinator<TransactionDetailViewController> {
  
  public var transactionDetail: TransactionDetail!
  
  override public func start() {

    viewController = .init(transactionDetail: transactionDetail)
    
    navigate(to: viewController, with: .push, animated: true)
    
  }
  
}
