//
//  TransactionListViewController.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 06/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import UIKit

public class TransactionListViewController: UIViewController, AlertDisplayable {
  
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
    $0.separatorInset = .init(top: 0, left: 20, bottom: 0, right: 0)
  }
  
  public var didTapToSignOut: (() -> Void)?
  public var goToCreateTransactionScreen: (() -> Void)?
  
  private let dataSource = TransactionListDatasource(configure: { (cell, model) in cell.configure(with: model) })
  
  private var viewModel: TransactionListViewModel
  private let coordinator: TransactionListViewCoorinator

  public init(viewModel: TransactionListViewModel, coordinator: TransactionListViewCoorinator) {
    self.viewModel = viewModel
    self.coordinator = coordinator
    super.init(nibName: nil, bundle: nil)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    
    setUpConstraints()
    setUpNavigationBar()

    viewModel.forcedReload = { [hideIndicator, showIndicator] force in
      force ? hideIndicator() : showIndicator()
    }
    
    viewModel.transactionListOutcome = { [updateViews] outcome in updateViews(outcome) }
    
    viewModel.errorSigningOutMessage = { [displayAlert] message in displayAlert(nil, message) }
    
    viewModel.loadData()

    coordinator.newlyCreatedTransactionID = { [viewModel] transactionID in viewModel.loadData(force: false) }

  }

  private func setUpNavigationBar() {
    navigationItem.title = "Expenses"
    navigationController?.defaultBarPreference(shouldApply: true)
    
    navigationItem.backBarButtonItem = coordinator.isNavigatedTo ?
      .init(title: "Cancel", style: .plain, target: self, action: nil) : nil
    
    navigationItem.leftBarButtonItem = .init(title: "Sign Out",
                                             style: .plain,
                                             target: self,
                                             action: #selector(signOutButtonTapped))
    navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
    
    navigationItem.rightBarButtonItem = .init(image: #imageLiteral(resourceName: "add"),
                                              style: .plain,
                                              target: self,
                                              action: #selector(createTransactionButtonTapped))
    
  }
  
}

// MARK: Target/Action
private extension TransactionListViewController {
  @objc func signOutButtonTapped() {
    showIndicator()
    do {
      try viewModel.signOut()
      //delay(seconds: 5) {
        self.hideIndicator()
        self.didTapToSignOut?()
      //}
    } catch _ {
      hideIndicator()
      displayAlert(message: "There was an issue signing you out. Please try again")
    }
  }
  
  @objc func createTransactionButtonTapped() {
    goToCreateTransactionScreen?()
  }
  
  @objc func refreshTableView() {
    viewModel.loadData(force: true)
  }
}

// MARK: TransactionListOutcome
private extension TransactionListViewController {
  
  /// changes the state of views based on the sign in state
  func updateViews(for outcome: TransactionListViewModel.TransactionListOutcome) {
    switch outcome {
    case .loading:
      showIndicator()
    case .loaded(transactions: let transactions):
      dataSource.dataList = transactions
      hideIndicator()
      refreshControl.endRefreshing()
      tableView.reloadData()
    case .failed(title: let title, reason: let message):
      hideIndicator()
      refreshControl.endRefreshing()
      displayAlert(title: title, message: message)
    }
  }
  
}

// MARK: - Loading Indicator
private extension TransactionListViewController {
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
private extension TransactionListViewController {
  func setUpConstraints() {
    view.add(tableView)
    tableView.topAnchor.constraint(equalTo: topSafeArea).isActive = true
    tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    tableView.bottomAnchor.constraint(equalTo: bottomSafeArea).isActive = true
    tableView.translatesAutoresizingMaskIntoConstraints = false
  }
}
