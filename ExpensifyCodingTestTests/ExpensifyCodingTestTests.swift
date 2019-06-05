//
//  ExpensifyCodingTestTests.swift
//  ExpensifyCodingTestTests
//
//  Created by Kauna Mohammed on 05/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import XCTest
@testable import ExpensifyCodingTest

class ExpensifyCodingTestTests: XCTestCase {
  
  static let expensifyAuthAPI = URL(string:"https://expensify.com/api?command=Authenticate&partnerName=applicant&partnerPassword=d7c3119c6cdab02d68d9&partnerUserID=expensifytest@mailinator.com&partnerUserSecret=hire_me")

  
  func testAuthEndPointDefinedCorrectly() {
    let authEndPoint = EndPoint.authenticateUser(partnerUserID: "expensifytest@mailinator.com",
                                                 partnerUserSecret: "hire_me").url

    XCTAssertTrue(authEndPoint == ExpensifyCodingTestTests.expensifyAuthAPI)
    
  }
  
  static let expensifyTransactionAPI = URL(string: "https://expensify.com/api?command=Get&authToken=fake_token&returnValueList=transactionList&&startDate&endDate&limit=50&offset")
  
  func testGetTransactionsEndPointDefinedCorrectly() {
    let transactionsEndPoint = EndPoint.getTransactions(authToken: "fake_token",
                                                        params: .init(idType: .none, limit: 50.asString)).url
    print(transactionsEndPoint!)
    XCTAssertTrue(transactionsEndPoint == ExpensifyCodingTestTests.expensifyTransactionAPI)
    
  }
  
  func testRouterRequest() {
    
    let expectation = self.expectation(description: "Network Request")
    var info: AccountInfo?

    let router = Router()
    router.request(EndPoint.authenticateUser(partnerUserID: Constants.TestUser.id, partnerUserSecret: Constants.TestUser.password)) { (result) in
      switch result {
      case .success(let data): print(data)
      do {
        let decoder = JSONDecoder()
        let accountInfo = try decoder.decode(AccountInfo.self, from: data)
        info = accountInfo
        expectation.fulfill()
      }
      catch {
        print(error.localizedDescription)
        }
      case .failure(let error):
        print(error.localizedDescription)
      }
      
    }
    
    waitForExpectations(timeout: 20, handler: nil)
    print(info)
    XCTAssertTrue(info?.email == Constants.TestUser.id)
  }
  
}
