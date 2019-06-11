//
//  TransactionDetailTableViewCell1.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 10/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import UIKit

public class TransactionDetailTableViewCell1: UITableViewCell {
  
  private struct Constants {
    static let topPadding: CGFloat = 10
    static let bottomPadding: CGFloat = -5
    static let leadingPadding: CGFloat = 20
    static let trailingPadding: CGFloat = -20
  }

  let label = UILabel {
    $0.textAlignment = .left
    $0.numberOfLines = 4
  }
  
  override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    contentView.add(label)
    
    label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.topPadding).isActive = true
    label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.leadingPadding).isActive = true
    label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.trailingPadding).isActive = true
    label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Constants.bottomPadding).isActive = true
    label.translatesAutoresizingMaskIntoConstraints = false
    
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public func configure(topText: String? = nil, bottomText: String? = nil) {
    label.attributedText = AttributedStringBuilder()
      .append(topText.orEmpty, attributes: [.font: UIFont.italicSystemFont(ofSize: 10), .foregroundColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)])
      .append("\n", attributes: [:])
      .append(bottomText.orEmpty, attributes: [.font: UIFont.preferredFont(forTextStyle: .headline), .foregroundColor: #colorLiteral(red: 0.06274509804, green: 0.05882352941, blue: 0.05882352941, alpha: 1)])
      .build()
    
  }
  
}

public class TransactionDetailTableViewCell2: TransactionDetailTableViewCell1 {
  
  private struct Constants {
    static let width: CGFloat = 15
    static let height: CGFloat = 15
    static let trailingPadding: CGFloat = -20
    static let topPadding: CGFloat = 30
    static let backgroundViewMultiplier: CGFloat = 0.95
  }
  
  private let checkmarkImageView = UIImageView {
    $0.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    $0.contentMode = .scaleAspectFit
    $0.clipsToBounds = true
  }
  
  override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    contentView.add(checkmarkImageView)
    checkmarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.trailingPadding).isActive = true
    checkmarkImageView.bottomAnchor.constraint(equalTo: label.bottomAnchor).isActive = true
    checkmarkImageView.heightAnchor.constraint(equalToConstant: Constants.height).isActive = true
    checkmarkImageView.widthAnchor.constraint(equalToConstant: Constants.width).isActive = true
    checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public func configure(bottomText: String, checkmark: Bool) {
    configure(topText: nil, bottomText: bottomText)
    checkmarkImageView.image = checkmark ?  #imageLiteral(resourceName: "verification-checkmark-symbol") : #imageLiteral(resourceName: "cancel")
  }
  
}

