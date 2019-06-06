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
  
  func testNumberFormatterConvertsToExpectedCurrency() {
    let str = NumberFormatter.currency(from: "USD", amount: 900.99)
    XCTAssertTrue(str == "$900.99")
  }
  
  func testQueryItemsRemovesNilValues() {
    let item1 = URLQueryItem(name: "q", value: nil)
    let item2 = URLQueryItem(name: "sort", value: "getting_shit_done")
    let items = [item1, item2]
    
    XCTAssertFalse(items.removeNilValues().contains(item1), "Did not remove nil values") 
  }
  
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
