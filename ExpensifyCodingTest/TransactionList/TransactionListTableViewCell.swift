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

  private let billableImageView = UIImageView {
    $0.image = #imageLiteral(resourceName: "bill")
    $0.contentMode = .scaleAspectFit
  }
  
  private lazy var leaingStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [billableImageView, leadingLabel])
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


  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    contentView.add(leaingStackView, trailingStackView)
    backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    
    billableImageView.set(height: 20, width: 20)
    leaingStackView.layout {
      $0.leading == contentView.leadingAnchor + 10
      $0.width == contentView.widthAnchor - (contentView.frame.width * 0.6)
      $0.centerY == contentView.centerYAnchor
    }
    
    trailingStackView.layout {
      $0.top == leaingStackView.topAnchor
      $0.trailing == contentView.trailingAnchor - 20
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(with model: TransactionList) {
    
    #if DEBUG
    billableImageView.isHidden = false
    #else
    billableImageView.isHidden = !model.billable
    #endif
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    
    let date = formatter.date(from: model.created.orEmpty)
    
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
              attributes: [.foregroundColor: model.amount < 0 ? #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1) : #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), .font: UIFont.preferredFont(forTextStyle: .title3)])
      .build()
  }
  
}


