//
//  Constants.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 05/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import Foundation

public struct Constants {
  
  public struct Partner {
    public static let name = "applicant"
    public static let password = "d7c3119c6cdab02d68d9"
  }
  
  public struct TestUser {
    public static let id = "expensifytest@mailinator.com"
    public static let password = "hire_me"
  }
  
  public struct TestEndpoint {
    public static let expensifyAuthEndPoint = URL(string: "https://expensify.com/api?command=Authenticate&partnerName=applicant&partnerPassword=d7c3119c6cdab02d68d9&partnerUserID=expensifytest@mailinator.com&partnerUserSecret=hire_me")
    public static let expensiftGetTransactionsEndPoint = URL(string: "https://expensify.com/api?command=Get&authToken=fake_token&returnValueList=transactionList&limit=50")
    public static let expensifyCreateTransactionEndPoint = URL(string: "https://expensify.com/api?command=CreateTransaction&authToken=fake_token&amount=100&created=2019-01-01&merchant=Tesco&billable=false&reimbursable=false")
  }
  
}
