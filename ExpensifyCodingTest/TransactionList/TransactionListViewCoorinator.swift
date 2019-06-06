//
//  TransactionListViewCoorinator.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 06/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import CoordinatorLibrary

let mockToken = "9C575F1CAFC7C37639C025D0C233C9AA873A3E39BE3B54E98E9354B02EFAA24A1DEF4C11468197701278BBC03FF361280EB30165D9527DC7C722867688CFC0E01696B98923679907832AFE31587ACD17CA0C63421555C0BB20A678E083D6DAEF69FAED4B1953FBFB020C6F80C43E70C5354EF645187DC1937A496E8F9C57372366B97F559931B4C69E49065BE61E4107B4ADF0C864218795A1E1CF3691C44110BE13EE433907350B30C5180FFD8F98A218D6DF4C934EFB94CBD02DF8A4D7FF5BFB6A6894173B61EF15E52D2D0BE91259A63EBC1BD8825D0BBC0010187C40A530014E479D328925642F963E983D8DF8D19DA4CEB5B8840C7DF1E0D3B0AFDA99BE"

final class TransactionListViewCoorinator: NavigationCoordinator<TransactionListViewController> {
  
  public var apiResponse: APIResponse!
  
  override func start() {
    
    viewController = .init(authToken: apiResponse.authToken.orEmpty, router: Router())
//    viewController = TransactionListViewController(authToken: mockToken, router: Router())
    navigate(to: viewController, with: .set, animated: false)
    
  }
  
}
