//
//  CreateTransactionViewController.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 06/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import UIKit

class CreateTransactionViewController: UIViewController, AlertDisplayable {
  
  lazy var activityIndicator: UIActivityIndicatorView = .init(style: .gray)

  private let datePicker = UIDatePicker {
    $0.datePickerMode = .date
  }
  
  // marked lazy so i can have self available
  private lazy var merchantInputTextField = UITextField {
    $0.placeholder = "Merchant"
    $0.borderStyle = .roundedRect
  }
  
  // marked lazy so i can have self available
  private lazy var amountInputTextField = UITextField {
    $0.placeholder = "Amount"
    $0.borderStyle = .roundedRect
    $0.keyboardType = .numberPad
  }
  
  // marked lazy so i can have self available
  private lazy var createTransactionButton = UIButton {
    $0.backgroundColor = #colorLiteral(red: 0.2901960784, green: 0.5647058824, blue: 0.8862745098, alpha: 1)
    $0.layer.cornerRadius = 5
    $0.setTitle("Create Transaction", for: .normal)
    $0.addTarget(self, action: #selector(createTransactionButtonTapped), for: .touchUpInside)
  }
  
  private lazy var containerStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [datePicker, merchantInputTextField, amountInputTextField, createTransactionButton])
    stackView.alignment = .center
    stackView.axis = .vertical
    stackView.spacing = 20
    stackView.distribution = .fill
    return stackView
  }()
  
  public var uploadedTransaction: (() -> Void)?
  
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
    
    setUpConstraints()
    
  }
  
  @objc private func createTransactionButtonTapped() {
    if amountInputTextField.text!.isEmpty && merchantInputTextField.text!.isEmpty {
      displayAlert(message: "Please fill in the details of your receipt")
    } else {
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd"
      let date = datePicker.date
      let dateString = formatter.string(from: date)
      createTransaction(authToken: authToken,
                        amount: amountInputTextField.text!,
                        created: dateString,
                        merchant: merchantInputTextField.text!)
    }
  }
  
}

// MARK: - Loading Indicator
extension CreateTransactionViewController {
  func showIndicator() {
    view.add(activityIndicator)
    activityIndicator.startAnimating()
    activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
  }
  
  func hideIndicator() {
    activityIndicator.stopAnimating()
    activityIndicator.removeFromSuperview()
  }
}

// MARK: - Constraints
private extension CreateTransactionViewController {
  func setUpConstraints() {
    view.add(containerStackView)
    containerStackView.topAnchor.constraint(equalTo: topSafeArea, constant: 20).isActive = true
    containerStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    
    datePicker.heightAnchor.constraint(equalToConstant: 100).isActive = true
    datePicker.widthAnchor.constraint(equalToConstant: (view.frame.size.width * 0.8)).isActive = true
    
    // I favour this approach to reduce the amount of layout code when I have the same view layout specifications
    containerStackView.arrangedSubviews
      .filter { $0 is UITextField || $0 is UIButton }
      .forEach {
        $0.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: (view.frame.height * 0.95))
        $0.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: (view.frame.width * 0.2))
    }
  }
  
}

// MARK: Networking
private extension CreateTransactionViewController {
  func createTransaction(authToken: String, amount: String, created: String, merchant: String) {
    router.request(EndPoint.createTransaction(authToken: authToken,
                                              params: CreateTransactionParams(amount: amount, 
                                                                              created: created,
                                                                              merchant: merchant)),
                   completion: { [handle] result in handle(result) })
  }
  
  private enum UploadState {
    case uploading
    case uploaded
    case failure(title: String?, reason: String?)
  }
  
  /// changes the state of views based on the sign in state
  private func updateViews(for state: UploadState) {
    switch state {
    case .uploading:
      showIndicator()
      createTransactionButton.alpha = 0.5
      createTransactionButton.isEnabled = false
    case .uploaded:
      hideIndicator()
      createTransactionButton.alpha = 0.5
      createTransactionButton.isEnabled = false
    case .failure(title: let title, reason: let message):
      hideIndicator()
      createTransactionButton.alpha = 1
      createTransactionButton.isEnabled = true
      displayAlert(title: title, message: message)
    }
  }
  
  private func handle(result: Result<Data, NetworkError>) {
    updateViews(for: .uploading)
    switch result {
    case .success(let data):
      do {
        // here i'm taking advantage of the decoded() extension on `Data`
        let response: APIResponse = try data.decoded()
        switch response.jsonCode {
        case 200...299:
          updateViews(for: .uploaded)
          NotificationCenter.default.post(name: .createdTansaction,
                                          object: nil,
                                          userInfo: ["transactionID": response.transactionID.orEmpty])
          uploadedTransaction?()
        default:
          updateViews(for: .failure(title: nil, reason: "We couldn't upload your transaction. Please try again"))
        }
      } catch let error {
        print(error)
        updateViews(for: .failure(title: nil, reason: "Looks like there was a problem. Please try again"))
      }
      
    case .failure(let error):
      updateViews(for: .failure(title: nil, reason: error.errorDescription.orEmpty))
    }
  }
}
