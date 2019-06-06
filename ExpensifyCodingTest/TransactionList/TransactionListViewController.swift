//
//  TransactionListViewController.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 06/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import UIKit

class TransactionListViewController: UIViewController, AlertDisplayable {
  
  let dataSource = TransactionListDatasource(configure: { (cell, model) in cell.configure(with: model) })
  
  private lazy var tableView = UITableView {
    $0.dataSource = dataSource
    $0.rowHeight = 50 //UITableView.automaticDimension
    $0.estimatedRowHeight = 44
    $0.allowsSelection = false
    $0.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    $0.removeEmptyCells()
  }
  
  var activityIndicator: UIActivityIndicatorView? = nil
  private lazy var refreshControl = RefreshControl(holder: tableView)
  
  private let authToken: String
  private let router: NetworkRouter
  init(authToken: String, router: NetworkRouter) {
    self.authToken = authToken
    self.router = router
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self, name: .refreshControlStartedRefreshing, object: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Transactions"
    view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    
    view.add(tableView)
    tableView.pin(to: view)
    tableView.register(TransactionListTableViewCell.self)
    
    refreshControl.title = "Checking for updates"
    refreshControl.titleColor = #colorLiteral(red: 0.2901960784, green: 0.5647058824, blue: 0.8862745098, alpha: 1)
    
    loadData()
    
    NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: .refreshControlStartedRefreshing, object: nil)
    
  }
  
  @objc private func reloadTableView(notification: NSNotification) {
    loadData(force: true)
  }
  
  private func loadData(force: Bool = false) {
    if !force { showIndicator() }
    
    router.request(EndPoint.getTransactions(authToken: authToken, params: TransactionParams(idType: .none,
                                                                                            startDate: "2008-01-01",
                                                                                            endDate: "2999-12-31",
                                                                                            limit: 100.asString)),
                   completion: { [handle] result in handle(result, force) })
  }
  
  private func handle(result: Result<Data, NetworkError>, isReloaded: Bool) {
    switch result {
    case .success(let data):
      do {
        // here i'm taking advantage of the decoded() extension on `Data`
        let payload: TransactionPayload = try data.decoded()
        switch payload.jsonCode {
        case 200...299:
          dataSource.dataList = payload.transactionList
          isReloaded ? refreshControl.endRefreshing() : hideIndicator()
          tableView.reloadData()
        default:
          isReloaded ? refreshControl.endRefreshing() : hideIndicator()
          displayAlert(message: "We couldn't retrieve your transactions")
        }
      } catch let _ {
        isReloaded ? refreshControl.endRefreshing() : hideIndicator()
        displayAlert(message: "Looks like your session has expired. Please sign in again")
      }
      
    case .failure(let error):
      isReloaded ? refreshControl.endRefreshing() : hideIndicator()
      displayAlert(message: error.errorDescription.orEmpty)
    }
  }
  
}

// MARK: - Alerts
extension TransactionListViewController: LoadingDisplayable {
  func showIndicator() {
    activityIndicator = .init(style: .gray)
    view.add(activityIndicator!)
    activityIndicator!.center(in: view)
    activityIndicator!.startAnimating()
  }
}




//        case 401...500: print("Failure")
//          displayAlert(message: "We couldnt retrieve your transactions")
//        case 501...599: print("Failure")



//let stubTransactions = [
//
//  TransactionList(amount: 100,
//                  bank: "Monzo",
//                  billable: true,
//                  cardID: 000,
//                  cardName: "Monzo",
//                  cardNumber: "000-000",
//                  category: "noCategory",
//                  comment: "",
//                  created: "2019-03-03",
//                  currency: "USD",
//                  details: "",
//                  externalID: "",
//                  inserted: "",
//                  managedCard: false,
//                  mcc: 0,
//                  merchant: "Tesco",
//                  modified: false,
//                  modifiedAmount: "",
//                  modifiedCreated: "",
//                  modifiedCurrency: "",
//                  modifiedMCC: "",
//                  modifiedMerchant: "",
//                  receiptFilename: "",
//                  receiptID: "",
//                  receiptState: "",
//                  reimbursable: true,
//                  reportID: "",
//                  tag: "",
//                  transactionHash: "",
//                  transactionID: "",
//                  nameValuePairs: NameValuePairs(comment: ""),
//                  unverified: true,
//                  convertedAmount: 50,
//                  currencyConversionRate: 2,
//                  editable: "notEditable"),
//
//  TransactionList(amount: 10,
//                  bank: "Monzo",
//                  billable: true,
//                  cardID: 000,
//                  cardName: "Monzo",
//                  cardNumber: "000-000",
//                  category: "noCategory",
//                  comment: "",
//                  created: "2019-03-03",
//                  currency: "USD",
//                  details: "",
//                  externalID: "",
//                  inserted: "",
//                  managedCard: false,
//                  mcc: 0,
//                  merchant: "Tesco",
//                  modified: false,
//                  modifiedAmount: "",
//                  modifiedCreated: "",
//                  modifiedCurrency: "",
//                  modifiedMCC: "",
//                  modifiedMerchant: "",
//                  receiptFilename: "",
//                  receiptID: "",
//                  receiptState: "",
//                  reimbursable: true,
//                  reportID: "",
//                  tag: "",
//                  transactionHash: "",
//                  transactionID: "",
//                  nameValuePairs: NameValuePairs(comment: ""),
//                  unverified: true,
//                  convertedAmount: 50,
//                  currencyConversionRate: 2,
//                  editable: "notEditable"),
//
//  TransactionList(amount: 96,
//                  bank: "Monzo",
//                  billable: true,
//                  cardID: 000,
//                  cardName: "Monzo",
//                  cardNumber: "000-000",
//                  category: "noCategory",
//                  comment: "",
//                  created: "2019-03-03",
//                  currency: "GBP",
//                  details: "",
//                  externalID: "",
//                  inserted: "",
//                  managedCard: false,
//                  mcc: 0,
//                  merchant: "Tesco",
//                  modified: false,
//                  modifiedAmount: "",
//                  modifiedCreated: "",
//                  modifiedCurrency: "",
//                  modifiedMCC: "",
//                  modifiedMerchant: "",
//                  receiptFilename: "",
//                  receiptID: "",
//                  receiptState: "",
//                  reimbursable: true,
//                  reportID: "",
//                  tag: "",
//                  transactionHash: "",
//                  transactionID: "",
//                  nameValuePairs: NameValuePairs(comment: ""),
//                  unverified: true,
//                  convertedAmount: 50,
//                  currencyConversionRate: 2,
//                  editable: "notEditable")
//
//]
