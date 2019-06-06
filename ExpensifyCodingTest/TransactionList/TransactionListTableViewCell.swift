//
//  TransactionListTableViewCell.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 06/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import UIKit

class TransactionListTableViewCell: UITableViewCell {
  
  private let leadingLabel = UILabel {
    $0.numberOfLines = 2
    $0.textAlignment = .left
  }
  
  private let trailingLabel = UILabel {
    $0.numberOfLines = 2
    $0.textAlignment = .right
  }


  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    contentView.add(leadingLabel, trailingLabel)
    backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

    leadingLabel.layout {
      $0.leading == contentView.leadingAnchor + 20
      $0.width == contentView.widthAnchor - (contentView.frame.width * 0.6)
      $0.centerY == contentView.centerYAnchor
    }
    trailingLabel.layout {
      $0.trailing == contentView.trailingAnchor - 20
      $0.centerY == contentView.centerYAnchor
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(with model: TransactionList) {
    leadingLabel.attributedText = AttributedStringBuilder()
      .append(model.merchant.truncate(by: 15) + "\n",
              attributes: [.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), .font: UIFont.preferredFont(forTextStyle: .headline)])
      .append(model.created.orEmpty,
              attributes: [.foregroundColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), .font: UIFont.preferredFont(forTextStyle: .subheadline)])
      .build()
    
    trailingLabel.attributedText = AttributedStringBuilder()
      .append("\(model.currency.orEmpty) \(model.amount)", attributes: [.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), .font: UIFont.preferredFont(forTextStyle: .headline)])
      .append("\n", attributes: [:])
      .append(model.bank.orEmpty, attributes: [.foregroundColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), .font: UIFont.preferredFont(forTextStyle: .subheadline)])
      .build()
  }
  
}


