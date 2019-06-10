//
//  TransactionDetailViewController.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 10/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import UIKit

public class TransactionDetailViewController: UIViewController {
  
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

  private let cardNameCell: TransactionDetailTableViewCell1 = .init(style: .default, reuseIdentifier: nil)
  private let cardNumberCell: TransactionDetailTableViewCell1 = .init(style: .default, reuseIdentifier: nil)
  private let categoryCell: TransactionDetailTableViewCell1 = .init(style: .default, reuseIdentifier: nil)
  private let commentCell: TransactionDetailTableViewCell1 = .init(style: .default, reuseIdentifier: nil)

  private let reimbursableCell: TransactionDetailTableViewCell2 = .init(style: .default, reuseIdentifier: nil)
  private let billableCell: TransactionDetailTableViewCell2 = .init(style: .default, reuseIdentifier: nil)
  private let unverifiedCell: TransactionDetailTableViewCell2 = .init(style: .default, reuseIdentifier: nil)
  
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
    
    navigationItem.title = "Details"
    setUpConstraints()

    merchantNameCell.configure(topText: "Merchant", bottomText: transactionDetail.merchant)
    amountCell.configure(topText: "Amount", bottomText: transactionDetail.amount)
    dateCell.configure(topText: "Date", bottomText: transactionDetail.date)
    
    cardNameCell.configure(topText: "Card Name", bottomText: transactionDetail.cardName)
    cardNumberCell.configure(topText: "Card Number", bottomText: transactionDetail.cardNumber)
    categoryCell.configure(topText: "Category", bottomText: transactionDetail.category)
    commentCell.configure(topText: "Comments", bottomText: transactionDetail.comment)
    
    reimbursableCell.configure(bottomText: "Reimbursable", checkmark: transactionDetail.reimbursable)
    billableCell.configure(bottomText: "Billable", checkmark: transactionDetail.billable)
    unverifiedCell.configure(bottomText: "Verified", checkmark: transactionDetail.unverified)

  }
  
  private func setUpConstraints() {
    view.add(transactionDetailTableView)
    transactionDetailTableView.topAnchor.constraint(equalTo: topSafeArea).isActive = true
    transactionDetailTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    transactionDetailTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    transactionDetailTableView.bottomAnchor.constraint(equalTo: bottomSafeArea).isActive = true
    transactionDetailTableView.translatesAutoresizingMaskIntoConstraints = false
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
    return 3
  }
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0: return 3
    case 1: return 4
    case 2: return 3
    default: fatalError("Unknown section")
    }
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      switch indexPath.row {
      case 0: return merchantNameCell
      case 1: return amountCell
      case 2: return dateCell
      default: fatalError("Unknown row in section: 0")
      }
    case 1:
      switch indexPath.row {
      case 0: return cardNameCell
      case 1: return cardNumberCell
      case 2: return categoryCell
      case 3: return commentCell
      default: fatalError("Unknown row in section: 1")
      }
    case 2:
      switch indexPath.row {
      case 0: return reimbursableCell
      case 1: return billableCell
      case 2: return unverifiedCell
      default: fatalError("Unknown row in section: 2")
      }
    default: fatalError("Unknown section")
    }
  }
  
}
