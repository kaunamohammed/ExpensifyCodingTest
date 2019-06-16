//
//  TransactionListViewController.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 06/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import UIKit

public final class TransactionListViewController: UIViewController, AlertDisplayable {
  
  private lazy var activityIndicator: UIActivityIndicatorView = .init(style: .gray)
  
  private lazy var refreshControl = UIRefreshControl {
    $0.attributedTitle = AttributedStringBuilder()
      .append(NSLocalizedString("Checking for updates", comment: "refresh control title"), attributes: [.foregroundColor: #colorLiteral(red: 0.2901960784, green: 0.5647058824, blue: 0.8862745098, alpha: 1)]).build()
    $0.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
  }
  
  private lazy var tableView = UITableView {
    $0.delegate = self
    $0.dataSource = self
    $0.rowHeight = 70
    $0.estimatedRowHeight = 80
    $0.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    $0.removeEmptyCells()
    $0.add(refreshControl: refreshControl)
    $0.register(TransactionListTableViewCell.self)
    $0.separatorInset = .init(top: 0, left: 20, bottom: 0, right: 0)
  }
  
  /// notifies the coordinator when the sign out button was tapped
  public var didTapToSignOut: (() -> Void)?
  
  /// notifies the coordinator to go to the create transation screen
  public var goToCreateTransactionScreen: (() -> Void)?
  
  /// notifies the coordinator to go to the transation detail screen
  public var goToTransactionDetailScreen: ((TransactionDetail) -> Void)?
  
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

    viewModel.forcedReload = { [weak self] force in force ? self?.hideIndicator() : self?.showIndicator() }
    
    viewModel.transactionListOutcome = { [weak self] outcome in self?.updateViews(for: outcome) }
    
    viewModel.errorSigningOutMessage = { [weak self] message in self?.displayAlert(title: nil, message: message) }
    
    viewModel.loadData()
    
    coordinator.transactionNewlyCreated = { [weak self] in self?.viewModel.loadData(isInitialLoad: false) }
    
  }

  private func setUpNavigationBar() {
    navigationItem.title = NSLocalizedString("Expenses", comment: "title")
    navigationController?.defaultBarPreference(shouldApply: true)
    
    navigationItem.leftBarButtonItem = .init(title: NSLocalizedString("Sign Out", comment: "sign out"),
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

// MARK: - UITableViewDatasource
extension TransactionListViewController: UITableViewDataSource {
  
  public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return viewModel.title(for: section)
  }
  
  public func numberOfSections(in tableView: UITableView) -> Int {
    return viewModel.numberOfSections()
  }
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfRows(for: section) 
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell: TransactionListTableViewCell = tableView.dequeueReusableCell(for: indexPath)
    let item = viewModel.item(for: indexPath)
    
    cell.configure(with: item, dateFormatter: viewModel.dateFormatter)
    
    return cell
  }
  
}


// MARK: - UITableViewDelegate
extension TransactionListViewController: UITableViewDelegate {
  
  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    let item = viewModel.item(for: indexPath)
    let detail = TransactionDetail(merchant: item.merchant,
                                   amount: viewModel.currency(from: .init(string: item.currency.orEmpty),
                                                              amount: abs(item.amount).asDouble.asMainUnitCurrency).orEmpty,
                                   date: item.created.orEmpty,
                                   comment: item.comment.orEmpty,
                                   reimbursable: item.reimbursable)
    goToTransactionDetailScreen?(detail)
  }
  
}

// MARK: Target/Action
private extension TransactionListViewController {
  @objc func signOutButtonTapped() {
    showIndicator()
    do {
      try viewModel.signOut()
        hideIndicator()
        didTapToSignOut?()
    } catch _ {
      hideIndicator()
      displayAlert(message: "There was an issue signing you out. Please try again")
    }
  }
  
  @objc func createTransactionButtonTapped() {
    goToCreateTransactionScreen?()
  }
  
  @objc func refreshTableView() {
    viewModel.loadData(isInitialLoad: true)
  }
}

// MARK: TransactionListOutcome
private extension TransactionListViewController {
  
  /// changes the state of views based on the sign in state
  func updateViews(for outcome: TransactionListViewModel.TransactionListOutcome) {
    switch outcome {
    case .loading:
      showIndicator()
    case .loaded:
      hideIndicator()
      refreshControl.endRefreshing()
      tableView.reloadData()
    case .failed(title: let title, message: let message):
      hideIndicator()
      refreshControl.endRefreshing()
      tableView.reloadData()
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
    tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    tableView.translatesAutoresizingMaskIntoConstraints = false
  }
}
