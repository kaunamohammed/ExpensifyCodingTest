//
//  TransactionListTableViewCell.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 06/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import UIKit

public class TransactionListTableViewCell: UITableViewCell {
  
  private let leadingLabel = UILabel {
    $0.numberOfLines = 2
    $0.textAlignment = .left
  }
  
  private let trailingLabel = UILabel {
    $0.numberOfLines = 2
    $0.textAlignment = .center
  }

  private lazy var leaingStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [leadingLabel])
    stackView.alignment = .center
    stackView.axis = .horizontal
    stackView.spacing = 10
    stackView.distribution = .fill
    return stackView
  }()
  
  private lazy var trailingStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [trailingLabel])
    stackView.alignment = .center
    stackView.axis = .vertical
    stackView.spacing = 15
    stackView.distribution = .fill
    return stackView
  }()
  
  override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    
    setUpConstraints()

  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public func configure(with model: TransactionList) {
    
    let formatter = DateFormatter()
    // getting the returned created string in its format
    formatter.dateFormat = "yyyy-MM-dd"
    let date = formatter.date(from: model.created.orEmpty)
    // changing it to the correct format to display in the cell
    formatter.dateFormat = "E d MMM y"
    let dateString = formatter.string(from: date!)
    
    leadingLabel.attributedText = AttributedStringBuilder()
      .append(model.merchant.truncate(by: 15) + "\n",
              attributes: [.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), .font: UIFont.preferredFont(forTextStyle: .headline)])
      .append(dateString,
              attributes: [.foregroundColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), .font: UIFont.preferredFont(forTextStyle: .footnote)])
      .build()
  
    let amount = NumberFormatter.currency(from: .init(string: model.currency.orEmpty), amount: abs(model.amount.asCurrency)).orEmpty
    trailingLabel.attributedText = AttributedStringBuilder()
      .append(amount + "\n",
              attributes: [.foregroundColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), .font: UIFont.preferredFont(forTextStyle: .title3)])
      .build()
  }
  
}

// MARK: - Constraints
private extension TransactionListTableViewCell {
  func setUpConstraints() {
    contentView.add(leaingStackView, trailingStackView)

    leaingStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
    leaingStackView.widthAnchor.constraint(equalToConstant: 200).isActive = true
    leaingStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    leaingStackView.translatesAutoresizingMaskIntoConstraints = false

    trailingStackView.topAnchor.constraint(equalTo: leaingStackView.topAnchor).isActive = true
    trailingStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
    trailingStackView.translatesAutoresizingMaskIntoConstraints = false

  }
}
