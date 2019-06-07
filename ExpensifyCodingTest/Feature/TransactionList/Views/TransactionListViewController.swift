//
//  TransactionListViewController.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 06/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import UIKit

class TransactionListViewController: UIViewController, AlertDisplayable {
  
  private lazy var activityIndicator: UIActivityIndicatorView = .init(style: .gray)
  
  private lazy var refreshControl = UIRefreshControl {
    $0.attributedTitle = AttributedStringBuilder().append("Checking for updates", attributes: [.foregroundColor: #colorLiteral(red: 0.2901960784, green: 0.5647058824, blue: 0.8862745098, alpha: 1)]).build()
    $0.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
  }
  
  private lazy var tableView = UITableView {
    $0.dataSource = dataSource
    $0.rowHeight = 70
    $0.estimatedRowHeight = 80
    $0.allowsSelection = false
    $0.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    $0.removeEmptyCells()
    $0.add(refreshControl: refreshControl)
    $0.register(TransactionListTableViewCell.self)
    $0.separatorInset = .init(top: 0, left: 40, bottom: 0, right: 0)
  }
  
  public var didTapTologOut: (() -> Void)?
  public var goToCreateTransactionScreen: ((String) -> Void)?
  private let dataSource = TransactionListDatasource(configure: { (cell, model) in cell.configure(with: model) })

  private let authToken: String
  private let router: NetworkRouter
  private let coordinator: TransactionListViewCoorinator
  
  init(authToken: String, router: NetworkRouter, coordinator: TransactionListViewCoorinator) {
    self.authToken = authToken
    self.router = router
    self.coordinator = coordinator
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Transactions"
    view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    
    setUpConstraints()
    setUpNavigationItems()

    loadData()
    
    coordinator.createdTransactionID = { [loadData] transactionID in loadData(false) }
    
  }
  
  private func setUpNavigationItems() {
    navigationItem.leftBarButtonItem = .init(title: "Log Out",
                                             style: .plain,
                                             target: self,
                                             action: #selector(logOutButtonTapped))
    navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
    
    navigationItem.rightBarButtonItem = .init(title: "Create",
                                              style: .plain,
                                              target: self,
                                              action: #selector(createTransactionButtonTapped))
  }
  
}

private extension TransactionListViewController {
  @objc func logOutButtonTapped() {
    didTapTologOut?()
  }
  
  @objc func createTransactionButtonTapped() {
    goToCreateTransactionScreen?(authToken)
  }
  
  @objc func refreshTableView() {
    loadData(force: true)
  }
}

// MARK: - Loading Indicator
extension TransactionListViewController {
  func showIndicator() {
    view.add(activityIndicator)
    activityIndicator.startAnimating()
    activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
  }
  
  func hideIndicator() {
    activityIndicator.stopAnimating()
    activityIndicator.removeFromSuperview()
  }
}

// MARK: - Constraints
extension TransactionListViewController {
  func setUpConstraints() {
    view.add(tableView)
    tableView.topAnchor.constraint(equalTo: topSafeArea).isActive = true
    tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    tableView.bottomAnchor.constraint(equalTo: bottomSafeArea).isActive = true
    tableView.translatesAutoresizingMaskIntoConstraints = false
  }
}

// MARK: Networking
extension TransactionListViewController {
  private func loadData(force: Bool = false) {
    if !force { showIndicator() }
    
    router.request(EndPoint.getTransactions(authToken: authToken, params: TransactionParams(idType: .none,
                                                                                            endDate: Date.nowString(),
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
          print(dataSource.dataList.count)
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

//        case 401...500: print("Failure")
//          displayAlert(message: "We couldnt retrieve your transactions")
//        case 501...599: print("Failure")

