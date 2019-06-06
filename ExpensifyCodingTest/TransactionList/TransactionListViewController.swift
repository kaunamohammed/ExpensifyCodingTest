//
//  TransactionListViewController.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 06/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import UIKit

class TransactionListViewController: UIViewController {
  
  let dataSource = TransactionListDatasource(configure: { (cell, model) in cell.configure(with: model) })
  
  private lazy var tableView = UITableView {
    $0.dataSource = dataSource
    $0.rowHeight = 50 //UITableView.automaticDimension
    $0.estimatedRowHeight = 44
    $0.allowsSelection = false
    $0.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    $0.removeEmptyCells()
  }
  
  private lazy var refreshControl = RefreshControl(holder: tableView)
  
  private let authToken: String
  init(authToken: String) {
    self.authToken = authToken
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Transactions"

    view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    view.add(tableView)
    tableView.pin(to: view)
    tableView.register(TransactionListTableViewCell.self)
    dataSource.dataList = stubTransactions
    refreshControl.isRefreshing = false
  }
  
}

let stubTransactions = [

  TransactionList(amount: 100,
                  bank: "Monzo",
                  billable: true,
                  cardID: 000,
                  cardName: "Monzo",
                  cardNumber: "000-000",
                  category: "noCategory",
                  comment: "",
                  created: "2019-03-03",
                  currency: "USD",
                  details: "",
                  externalID: "",
                  inserted: "",
                  managedCard: false,
                  mcc: 0,
                  merchant: "Tesco",
                  modified: false,
                  modifiedAmount: "",
                  modifiedCreated: "",
                  modifiedCurrency: "",
                  modifiedMCC: "",
                  modifiedMerchant: "",
                  receiptFilename: "",
                  receiptID: "",
                  receiptState: "",
                  reimbursable: true,
                  reportID: "",
                  tag: "",
                  transactionHash: "",
                  transactionID: "",
                  nameValuePairs: NameValuePairs(comment: ""),
                  unverified: true,
                  convertedAmount: 50,
                  currencyConversionRate: 2,
                  editable: "notEditable"),
  
  TransactionList(amount: 10,
                  bank: "Monzo",
                  billable: true,
                  cardID: 000,
                  cardName: "Monzo",
                  cardNumber: "000-000",
                  category: "noCategory",
                  comment: "",
                  created: "2019-03-03",
                  currency: "USD",
                  details: "",
                  externalID: "",
                  inserted: "",
                  managedCard: false,
                  mcc: 0,
                  merchant: "Tesco",
                  modified: false,
                  modifiedAmount: "",
                  modifiedCreated: "",
                  modifiedCurrency: "",
                  modifiedMCC: "",
                  modifiedMerchant: "",
                  receiptFilename: "",
                  receiptID: "",
                  receiptState: "",
                  reimbursable: true,
                  reportID: "",
                  tag: "",
                  transactionHash: "",
                  transactionID: "",
                  nameValuePairs: NameValuePairs(comment: ""),
                  unverified: true,
                  convertedAmount: 50,
                  currencyConversionRate: 2,
                  editable: "notEditable"),
  
  TransactionList(amount: 96,
                  bank: "Monzo",
                  billable: true,
                  cardID: 000,
                  cardName: "Monzo",
                  cardNumber: "000-000",
                  category: "noCategory",
                  comment: "",
                  created: "2019-03-03",
                  currency: "GBP",
                  details: "",
                  externalID: "",
                  inserted: "",
                  managedCard: false,
                  mcc: 0,
                  merchant: "Tesco",
                  modified: false,
                  modifiedAmount: "",
                  modifiedCreated: "",
                  modifiedCurrency: "",
                  modifiedMCC: "",
                  modifiedMerchant: "",
                  receiptFilename: "",
                  receiptID: "",
                  receiptState: "",
                  reimbursable: true,
                  reportID: "",
                  tag: "",
                  transactionHash: "",
                  transactionID: "",
                  nameValuePairs: NameValuePairs(comment: ""),
                  unverified: true,
                  convertedAmount: 50,
                  currencyConversionRate: 2,
                  editable: "notEditable")

]
