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
    $0.rowHeight = 80 //UITableView.automaticDimension
    $0.estimatedRowHeight = 44
    $0.allowsSelection = false
    $0.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    $0.removeEmptyCells()
    $0.separatorInset = .init(top: 0, left: 30, bottom: 0, right: 0)
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
    
    #if DEBUG
    refreshControl.title = "Getting shit done"
    #else
    refreshControl.title = "Checking for updates"
    #endif
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
          dataSource.dataList = payload.transactionList!.isEmpty ? [] : payload.transactionList!
          isReloaded ? refreshControl.endRefreshing() : hideIndicator()
          tableView.reloadData()
        default:
          isReloaded ? refreshControl.endRefreshing() : hideIndicator()
          displayAlert(message: "We couldn't retrieve your transactions")
        }
      } catch let error {
        print(error)
        isReloaded ? refreshControl.endRefreshing() : hideIndicator()
        displayAlert(message: "Looks like there was a problem. Please try again")
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

