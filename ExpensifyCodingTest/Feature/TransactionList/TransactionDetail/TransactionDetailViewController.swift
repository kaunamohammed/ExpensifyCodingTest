//
//  TransactionDetailViewController.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 10/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import UIKit

public final class TransactionDetailViewController: UIViewController {
  
  private lazy var transactionDetailTableView: UITableView = {
    let table = UITableView(frame: .zero, style: .grouped)
    table.dataSource = self
    table.delegate = self
    table.rowHeight = UITableView.automaticDimension
    table.estimatedRowHeight = 44
    return table
  }()
  
  private let merchantNameCell: TransactionDetailTableViewCell1 = .init(style: .default, reuseIdentifier: nil)
  private let amountCell: TransactionDetailTableViewCell1 = .init(style: .default, reuseIdentifier: nil)
  private let dateCell: TransactionDetailTableViewCell1 = .init(style: .default, reuseIdentifier: nil)
  private let commentCell: TransactionDetailTableViewCell1 = .init(style: .default, reuseIdentifier: nil)
  private let reimbursableCell: TransactionDetailTableViewCell2 = .init(style: .default, reuseIdentifier: nil)
  
  private let transactionDetail: TransactionDetail
  public init(transactionDetail: TransactionDetail) {
    self.transactionDetail = transactionDetail
    super.init(nibName: nil, bundle: nil)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.title = NSLocalizedString("Expenses", comment: "expense title")
    setUpConstraints()
    configureCells()
  }
  
}

// MARK: - Configure cells
private extension TransactionDetailViewController {
  func configureCells() {
    merchantNameCell.configure(topText:  NSLocalizedString("Merchant",
                                                           comment: "title"),
                               bottomText: transactionDetail.merchant)
    amountCell.configure(topText: NSLocalizedString("Amount",
                                                    comment: "title"),
                         bottomText: transactionDetail.amount)
    dateCell.configure(topText: NSLocalizedString("Date",
                                                  comment: "title"),
                       bottomText: transactionDetail.date)
    commentCell.configure(topText: NSLocalizedString("Comment",
                                                     comment: "title"),
                          bottomText: transactionDetail.comment)
    
    reimbursableCell.configure(bottomText: NSLocalizedString("Reimbursable",
                                                             comment: "title"),
                               checkmark: transactionDetail.reimbursable)
  }
}

// MARK: - UITableViewDelegate
extension TransactionDetailViewController: UITableViewDelegate {
  
  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
}

// MARK: - UITableViewDataSource
extension TransactionDetailViewController: UITableViewDataSource {
  
  public func numberOfSections(in tableView: UITableView) -> Int {
    return TransansactionDetailSection.numberOfSections
  }
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let sec = TransansactionDetailSection(rawValue: section) else { return 0 }
    return sec.numberOfRowsInSections
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let section = TransansactionDetailSection(rawValue: indexPath.section) else { return .init() }
    
    switch section {
      
    case .detailSection:
      guard let row = TransansactionDetailSection.DetailRow(rawValue: indexPath.row) else { return .init() }
      switch row {
      case .merchant: return merchantNameCell
      case .amount: return amountCell
      case .date: return dateCell
      case .comment: return commentCell
      }
      
    case .extrasSection:
      guard let row = TransansactionDetailSection.ExtraRow(rawValue: indexPath.row) else { return .init() }
      switch row {
      case .reimbursable: return reimbursableCell
      }
      
    }
  }
}

// MARK: - Constraints
private extension TransactionDetailViewController {
  func setUpConstraints() {
    view.add(transactionDetailTableView)
    transactionDetailTableView.topAnchor.constraint(equalTo: topSafeArea).isActive = true
    transactionDetailTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    transactionDetailTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    transactionDetailTableView.bottomAnchor.constraint(equalTo: bottomSafeArea).isActive = true
    transactionDetailTableView.translatesAutoresizingMaskIntoConstraints = false
  }
}

// MARK: - TransansactionDetailSection
extension TransactionDetailViewController {
  private enum TransansactionDetailSection: Int, CaseIterable {
    case detailSection = 0
    case extrasSection
    
    static var numberOfSections: Int { return TransansactionDetailSection.allCases.count }
    
    var numberOfRowsInSections: Int {
      switch self {
      case .detailSection: return 4
      case .extrasSection: return 1
      }
    }
    
    enum DetailRow: Int {
      case merchant = 0
      case amount
      case date
      case comment
    }
    
    enum ExtraRow: Int {
      case reimbursable
    }
    
  }
}
