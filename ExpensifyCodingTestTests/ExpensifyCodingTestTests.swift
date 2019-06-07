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
  
  func testConversionOfTodaysDateToString() {
    XCTAssertTrue(Date.nowString() == "2019-06-07")
  }
  
  func testNumberFormatterConvertsToExpectedCurrency() {
    let amount = NumberFormatter.currency(from: "USD", amount: 900.99)
    XCTAssertTrue(amount == "$900.99")
  }
  
  func testQueryItemsRemovesNilValues() {
    let item1 = URLQueryItem(name: "q", value: nil)
    let item2 = URLQueryItem(name: "sort", value: "getting_shit_done")
    let items = [item1, item2]
    
    XCTAssertFalse(items.removeNilValues().contains(item1), "Did not remove nil values") 
  }
  
  func testAuthEndPointDefinedCorrectly() {
    let authEndPoint = EndPoint.authenticateUser(partnerUserID: Constants.TestUser.id,
                                                 partnerUserSecret: Constants.TestUser.password).url

    XCTAssertTrue(authEndPoint == Constants.TestEndpoint.expensifyAuthEndPoint)
    
  }
  
  func testGetTransactionsEndPointDefinedCorrectly() {
    let transactionsEndPoint = EndPoint.getTransactions(authToken: "fake_token",
                                                        params: .init(idType: .none, limit: 50.asString)).url
    XCTAssertTrue(transactionsEndPoint == Constants.TestEndpoint.expensiftGetTransactionsEndPoint)
    
  }
  
  func testCreateTransactionEndPointDefinedCorrectly() {
    
    let endPoint = EndPoint.createTransaction(authToken: "fake_token",
                                              params: CreateTransactionParams(amount: 100,
                                                                              created: "2019-01-01",
                                                                              merchant: "Tesco")).url
    XCTAssertTrue(endPoint == Constants.TestEndpoint.expensifyCreateTransactionEndPoint)
  }
  
  func testNetworkRouterRequest() {
    
    let expectation = self.expectation(description: "Making Network Request")
    var response: APIResponse!

    let router = Router()
    router.request(EndPoint.authenticateUser(partnerUserID: Constants.TestUser.id, partnerUserSecret: Constants.TestUser.password)) { (result) in
      switch result {
      case .success(let data):
      do {
        response = try data.decoded()
        expectation.fulfill()
      }
      catch let error {
        print(error.localizedDescription)
        }
      case .failure(let error):
        print(error.localizedDescription)
      }
      
    }
    
    waitForExpectations(timeout: 20, handler: nil)
    switch response.jsonCode {
    case 200...299: print("success authenticating")
    case 401...500: print("error authenticating")
    case 501...599: print("bad request")
    default: print("failiure")
    }

    XCTAssertTrue(response.email == Constants.TestUser.id)
  }
  
}
