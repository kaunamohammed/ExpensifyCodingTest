//
//  CreateTransactionViewController.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 06/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import UIKit

class CreateTransactionViewController: UIViewController, AlertDisplayable {
  
  private lazy var activityIndicator: UIActivityIndicatorView = .init(style: .gray)
  
  private lazy var scrollView = UIScrollView {
    $0.alwaysBounceVertical = true
  }
  
  private let datePicker = UIDatePicker {
    $0.datePickerMode = .date
  }
  
  // marked lazy so i can have self available
  private lazy var merchantInputTextField = UITextField {
    $0.placeholder = "Merchant"
    $0.borderStyle = .roundedRect
    $0.delegate = self
    $0.addTarget(self, action: #selector(validateTextFieldInput), for: .editingChanged)
  }
  
  // marked lazy so i can have self available
  private lazy var amountInputTextField = UITextField {
    $0.placeholder = currencyFormatter.string(from: 0)
    $0.borderStyle = .roundedRect
    $0.keyboardType = .numberPad
    $0.delegate = self
    $0.addTarget(self, action: #selector(amountChanged(_:)), for: .editingChanged)
    $0.addTarget(self, action: #selector(validateTextFieldInput), for: .editingChanged)
  }
  
  // marked lazy so i can have self available
  private lazy var saveExpenseButton = UIButton {
    $0.setTitle("Save", for: .normal)
    $0.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
    $0.isEnabled = false
    $0.addTarget(self, action: #selector(createTransactionButtonTapped), for: .touchUpInside)
  }
  
  private let backgroundView = UIView {
    $0.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    $0.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    $0.layer.shadowRadius = 2
    $0.layer.shadowOffset = CGSize(width: 0, height: 0)
    $0.layer.shadowOpacity = 0.5
    $0.layer.cornerRadius = 10
  }
  
  private lazy var containerStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [amountInputTextField, merchantInputTextField, datePicker])
    stackView.alignment = .center
    stackView.axis = .vertical
    stackView.spacing = 20
    stackView.distribution = .fill
    return stackView
  }()
  
  public var didSuccessfullyCreateTransaction: ((String) -> Void)?
  
  var currencyFormatter: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currencyAccounting
    formatter.locale = Locale(identifier: "en_US")
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 2
    return formatter
  }

  
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
    
    title = "New Expense"
    view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    
    setUpConstraints()
    navigationController?.navigationBar.backIndicatorImage = UIImage()
    navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage()
    navigationItem.rightBarButtonItem = .init(customView: saveExpenseButton)
    
    validateTextFieldInput()

  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  @objc private func validateTextFieldInput() {
    let textfieldsNotEmpty = (!merchantInputTextField.text.orEmpty.isEmpty && !amountInputTextField.text.orEmpty.isEmpty)
    let amountGreaterThanZero = amountInputTextField.text.orEmpty != "0"
    let isValid = textfieldsNotEmpty && amountGreaterThanZero
    saveExpenseButton.alpha = isValid ? 1.0 : 0.5
    saveExpenseButton.isEnabled = isValid
    navigationItem.rightBarButtonItem?.isEnabled = isValid
  }
  
  @objc private func createTransactionButtonTapped() {
    // here i am using `orEmpty` on the textfields just to avoid having to force unwrap the text property but since I'm alreadt
    // validating the textfields input to be empty or the button to be enabled
    let amount = String(Int((amountInputTextField.text.orEmpty.replacingOccurrences(of: "$", with: "").asDouble * 1000.0)))
    createTransaction(authToken: authToken,
                      amount: amount,
                      created: datePicker.date.expensifyDateFormat,
                      merchant: merchantInputTextField.text.orEmpty)
  }
  
  @objc func amountChanged(_ textField: UITextField) {
    
    let array = textField.text.orEmpty.compactMap { Int(String($0)) }
    let num = Double(array.reduce(0, {($0 * 10 + $1)})) / 100
    
    amountInputTextField.text = currencyFormatter.string(from: NSNumber(value: num))
  }
  
}

extension CreateTransactionViewController: UITextFieldDelegate {}

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
    view.add(scrollView)
    
    scrollView.topAnchor.constraint(equalTo: topSafeArea).isActive = true
    scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    scrollView.bottomAnchor.constraint(equalTo: bottomSafeArea).isActive = true
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    
    let height = (view.frame.size.height * 0.05)
    let width = (view.frame.size.width * 0.8)
    scrollView.add(backgroundView)
    backgroundView.add(containerStackView)

    backgroundView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30).isActive = true
    backgroundView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
    backgroundView.heightAnchor.constraint(equalToConstant: 300).isActive = true
    backgroundView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.95).isActive = true
    backgroundView.translatesAutoresizingMaskIntoConstraints = false

    containerStackView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
    containerStackView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor).isActive = true
    containerStackView.translatesAutoresizingMaskIntoConstraints = false

    datePicker.heightAnchor.constraint(equalToConstant: 100).isActive = true
    datePicker.widthAnchor.constraint(equalToConstant: width).isActive = true
    datePicker.translatesAutoresizingMaskIntoConstraints = false
    
    merchantInputTextField.heightAnchor.constraint(equalToConstant: height).isActive = true
    merchantInputTextField.widthAnchor.constraint(equalToConstant: width).isActive = true
    merchantInputTextField.translatesAutoresizingMaskIntoConstraints = false

    amountInputTextField.heightAnchor.constraint(equalToConstant: height).isActive = true
    amountInputTextField.widthAnchor.constraint(equalToConstant: width).isActive = true
    amountInputTextField.translatesAutoresizingMaskIntoConstraints = false

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
      saveExpenseButton.alpha = 0.5
      saveExpenseButton.isEnabled = false
    case .uploaded:
      hideIndicator()
      saveExpenseButton.alpha = 0.5
      saveExpenseButton.isEnabled = false
    case .failure(title: let title, reason: let message):
      hideIndicator()
      saveExpenseButton.alpha = 1
      saveExpenseButton.isEnabled = true
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
          didSuccessfullyCreateTransaction?(response.transactionID.orEmpty)
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

extension Date {
  
  var expensifyDateFormat: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.string(from: self)
  }
  
}
