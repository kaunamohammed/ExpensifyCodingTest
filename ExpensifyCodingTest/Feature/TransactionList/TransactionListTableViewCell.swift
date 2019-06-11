//
//  TransactionListTableViewCell.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 09/06/2019.
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
  
  override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    
    setUpConstraints()
    
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public func configure(with model: TransactionList, dateFormatter: DateFormatter) {
    
    // getting the returned created string in its format
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let date = dateFormatter.date(from: model.created.orEmpty)
    // changing it to the correct format to display in the cell
    dateFormatter.dateFormat = "E d MMM y"
    let dateString = dateFormatter.string(from: date!)
    
    leadingLabel.attributedText = AttributedStringBuilder()
      .append(model.merchant.truncate(by: 15) + "\n",
              attributes: [.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), .font: UIFont.preferredFont(forTextStyle: .headline)])
      .append(dateString,
              attributes: [.foregroundColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), .font: UIFont.preferredFont(forTextStyle: .footnote)])
      .build()
    
    let amount = NumberFormatter.currency(from: .init(string: model.currency.orEmpty),
                                          amount: abs(model.amount.asCurrency)).orEmpty
    trailingLabel.attributedText = AttributedStringBuilder()
      .append(amount + "\n",
              attributes: [.foregroundColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), .font: UIFont.preferredFont(forTextStyle: .title3)])
      .build()
  }
  
}

// MARK: - Constraints
private extension TransactionListTableViewCell {
  
  private struct Constants {
    static let leadingLabelWidth: CGFloat = 200
    static let leadingPadding: CGFloat = 20
    static let trailingPadding: CGFloat = -20
  }
  
  func setUpConstraints() {
    contentView.add(leadingLabel, trailingLabel)
    
    leadingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.leadingPadding).isActive = true
    leadingLabel.widthAnchor.constraint(equalToConstant: Constants.leadingLabelWidth).isActive = true
    leadingLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    leadingLabel.translatesAutoresizingMaskIntoConstraints = false
    
    trailingLabel.topAnchor.constraint(equalTo: leadingLabel.topAnchor).isActive = true
    trailingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.trailingPadding).isActive = true
    trailingLabel.translatesAutoresizingMaskIntoConstraints = false
    
  }
}
