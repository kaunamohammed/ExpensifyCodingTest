//
//  CreateTransactionViewController.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 06/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import UIKit

class CreateTransactionViewController: UIViewController {
  
  private let datePicker = UIDatePicker {
    $0.datePickerMode = .date
  }
  
  // marked lazy so i can have self available
  private lazy var merchantInputTextField = UITextField {
    $0.placeholder = "Merchant"
    $0.isSecureTextEntry = true
    $0.borderStyle = .roundedRect
    //$0.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .allEditingEvents)
    //$0.delegate = self
  }
  
  // marked lazy so i can have self available
  private lazy var amountInputTextField = UITextField {
    $0.placeholder = "Amount"
    $0.borderStyle = .roundedRect
    //$0.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .allEditingEvents)
    //$0.delegate = self
  }
  
  // marked lazy so i can have self available
  private lazy var createTransactionButton = UIButton {
    $0.backgroundColor = #colorLiteral(red: 0.2901960784, green: 0.5647058824, blue: 0.8862745098, alpha: 1)
    $0.layer.cornerRadius = 5
    //$0.alpha = 0.5
    //$0.isEnabled = false
    $0.setTitle("Create Transaction", for: .normal)
    //$0.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
  }
  
  private lazy var containerStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [datePicker, merchantInputTextField, amountInputTextField, createTransactionButton])
    stackView.alignment = .center
    stackView.axis = .vertical
    stackView.spacing = 20
    stackView.distribution = .fill
    return stackView
  }()
  
  private let authToken: String
  private let router: NetworkRouter
  init(authToken: String, router: NetworkRouter) {
    self.authToken = authToken
    self.router = router
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
    layoutSubViews()
    
  }
  
}

// MARK: - Layout
private extension CreateTransactionViewController {
  func layoutSubViews() {
    view.add(containerStackView)
    containerStackView.layout {
      $0.top == topSafeArea + 20
      $0.centerX == view.centerXAnchor
    }
    
    datePicker.set(height: 100, width: view.frame.size.width * 0.8)
    
    // I favour this approach to reduce the amount of layout code when I have the same view layout specifications
    containerStackView.arrangedSubviews
      .filter { $0 is UITextField || $0 is UIButton }
      .forEach {
        $0.layout {
          $0.height == view.heightAnchor - (view.frame.height * 0.95)
          $0.width == view.widthAnchor - (view.frame.width * 0.2)
        }
    }
    
  }
}
