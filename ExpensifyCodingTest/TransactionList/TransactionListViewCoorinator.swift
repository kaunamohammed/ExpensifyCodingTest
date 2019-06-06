//
//  TransactionListViewCoorinator.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 06/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import CoordinatorLibrary

let mockToken = "31CFEB51EF330262AD8E4C16DA802E5AB14A0043A9D4F913BB1EE9EB62F70BA575DA424F3F5A0A1273CF76D7348830C5608EBE2607B443A086A45FBB0D3B55B446F60FE88C4C6A74FE10DCA66562A641BB02F02C52001E93C0BA22F2D16DE146EFDA820642D5413CD23A1623C5F360F84CA7620FA0BF8FF52C1BB75FBE5DFD98B3C38081E095A0A5AD4E58BB404F2B7D2AC0EBDD9097FF6475F02168A1480186830087CF77A5681D66732940D5EDD8CBD9990C72DBCE77542515A75FFBB949F28A2D2B182901A65A4135A06D6452B0C332A345F0942A3A29A427C89DB4F3E56C9AFAB078DDDA22AA4C9C3AAEF0995A0D8F6EC9B1F744610D7D1A96530B298657"

final class TransactionListViewCoorinator: NavigationCoordinator<TransactionListViewController> {
  
  public var apiResponse: APIResponse!
  
  override func start() {
    
    #if DEBUG
    viewController = TransactionListViewController(authToken: mockToken, router: Router())
    #else
    viewController = .init(authToken: apiResponse.authToken.orEmpty, router: Router())
    #endif
    navigate(to: viewController, with: .set, animated: false)
    
    //viewController.
    
  }
  
}
