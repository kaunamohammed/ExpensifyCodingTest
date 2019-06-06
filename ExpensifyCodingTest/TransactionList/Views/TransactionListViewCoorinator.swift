//
//  TransactionListViewCoorinator.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 06/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import CoordinatorLibrary

let mockToken = "B02923BA91F6BA75CC8F42D1557DB54E684457782062729B25FF8A9863BB8E04027B2A3203E11CD70674DACD34555E7CE8114CC919408605C6622347A3875BF254145C74D492FAF0DF9EF1FE52F8334E91DADA92F94E8E5082988A85FB8005A299C853F1EEEED7808C37D83DC1F8C948C4CF5E86B8444791EB8AFF2026BB2D575C2EA6606D614CC027685792FEB7ED3F44670B5A9B4C00D4A0D12AA3024DB46C5FC2B2C2BE43644FD9E17F05E9973D1A4D2251FE0DB59AB796F0F65B17CF42FD7FC70964CF96F51CE8E9D60B0FB2DF8DEF0AF2B76D2B7C7160EF76B70BFD3C324ABAAF749EBB7746DBFD7F0B05960735A7A2926471A48E758E095D6EDF257FBE"

final class TransactionListViewCoorinator: ChildCoordinator<TransactionListViewController> {
  
  public var apiResponse: APIResponse!
  
  private lazy var createTransactionViewCoordinator: CreateTransactionViewCoordinator = .init(presenter: presenter,
                                                                                              removeCoordinator: remove)
  private lazy var signInViewCoordinator: SignInViewCoordinator = .init(presenter: presenter,
                                                                        removeCoordinator: remove)
  
  override func start() {
    
    #if DEBUG
    viewController = TransactionListViewController(authToken: mockToken, router: Router())
    #else
    viewController = .init(authToken: apiResponse.authToken.orEmpty, router: Router())
    #endif
    navigate(to: viewController, with: .set, animated: false)
    
    viewController.goToCreateTransactionScreen = { [startCreateTransactionViewCoordinator] authToken in
      startCreateTransactionViewCoordinator(authToken)
    }
    
    viewController.logOut = { [startSignInViewCoordinator] in startSignInViewCoordinator() }
    
  }
  
  deinit {
    print("Bye: \(self.description)")
  }
  
}

private extension TransactionListViewCoorinator {
  
  func startCreateTransactionViewCoordinator(with token: String) {
    add(child: createTransactionViewCoordinator)
    createTransactionViewCoordinator.authToken = token
    createTransactionViewCoordinator.start()
  }
  
  func startSignInViewCoordinator() {
    add(child: signInViewCoordinator)
    signInViewCoordinator.start()
  }
}
