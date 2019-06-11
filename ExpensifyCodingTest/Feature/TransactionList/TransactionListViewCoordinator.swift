//
//  TransactionListViewCoordinator.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 09/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import CoordinatorLibrary

public final class TransactionListViewCoorinator: ChildCoordinator<TransactionListViewController> {
  
  public var authToken: String?
      
  public var transactionNewlyCreated: (() -> Void)?
  
  private lazy var transactionDetailViewCoordinator: TransactionDetailViewCoordinator = .init(presenter: presenter,
                                                                                              removeCoordinator: remove)
  
  private lazy var createTransactionViewCoordinator: CreateTransactionViewCoordinator = .init(presenter: presenter,
                                                                                              removeCoordinator: remove)
 
  private lazy var signInViewCoordinator: SignInViewCoordinator = .init(persistenceManager: persistenceManager,
                                                                        presenter: presenter,
                                                                        removeCoordinator: remove)
  
  private let persistenceManager: PersistenceManager
  public init(persistenceManager: PersistenceManager, presenter: UINavigationController, removeCoordinator: @escaping ((Coordinatable) -> ())) {
    self.persistenceManager = persistenceManager
    super.init(presenter: presenter, removeCoordinator: removeCoordinator)
  }
  
  override public func start() {
        
    viewController = .init(viewModel: .init(authToken: authToken.orEmpty, manager: .init(router: Router())), coordinator: self)
    navigate(to: viewController, with: .push, animated: false)
    
    viewController.goToTransactionDetailScreen = { [weak self] detail in
      self?.startTransactionDetailViewCoordinator(with: detail)
    }
    
    viewController.goToCreateTransactionScreen = { [weak self] in
      guard let strongSelf = self else { return }
      strongSelf.startCreateTransactionViewCoordinator(with: strongSelf.authToken.orEmpty)
    }
    
    viewController.didTapToSignOut = { [startSignInViewCoordinator] in startSignInViewCoordinator()
    }
    
  }
}

// MARK: - CreateTransactionViewCoordinatorDelegate
extension TransactionListViewCoorinator: CreateTransactionViewCoordinatorDelegate { 
  
  public func didCreateTransaction() {
    transactionNewlyCreated?()
  }
  
}

// MARK: Child Coordinators
private extension TransactionListViewCoorinator {
  
  func startTransactionDetailViewCoordinator(with detail: TransactionDetail) {
    add(child: transactionDetailViewCoordinator)
    transactionDetailViewCoordinator.transactionDetail = detail
    transactionDetailViewCoordinator.start()
  }
  
  func startCreateTransactionViewCoordinator(with token: String) {
    add(child: createTransactionViewCoordinator)
    createTransactionViewCoordinator.authToken = token
    createTransactionViewCoordinator.delegate = self
    createTransactionViewCoordinator.start()
  }
  
  func startSignInViewCoordinator() {
    add(child: signInViewCoordinator)
    presenter.defaultBarPreference(shouldApply: false)
    signInViewCoordinator.start()
  }
  
}
