//
//  CreateTransactionViewController.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 06/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import UIKit

public class CreateTransactionViewController: UIViewController, AlertDisplayable {
  
  private lazy var activityIndicator: UIActivityIndicatorView = .init(style: .gray)
  
  private lazy var scrollView = UIScrollView {
    $0.alwaysBounceVertical = true
  }
  
  private let datePicker = UIDatePicker {
    $0.datePickerMode = .date
  }
  
  // marked lazy so i can have self available
  private lazy var merchantInputTextField = UITextField {
    $0.placeholder = NSLocalizedString("Merchant", comment: "merchant title")
    $0.borderStyle = .roundedRect
    $0.addTarget(self, action: #selector(validateTextFieldInput), for: .editingChanged)
  }
  
  private lazy var amountInputTextField = UITextField {
    $0.placeholder = currencyFormatter.string(from: 0)
    $0.borderStyle = .roundedRect
    $0.keyboardType = .numberPad
    $0.delegate = self
    $0.addTarget(self, action: #selector(amountChanged(_:)), for: .editingChanged)
    $0.addTarget(self, action: #selector(validateTextFieldInput), for: .editingChanged)
  }
  
  private lazy var saveExpenseButton = UIButton {
    $0.setTitle(NSLocalizedString("Save", comment: "save button title"), for: .normal)
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
  
  /// notifies the coordinator that the transaction was successfully created
  public var didSuccessfullyCreateTransaction: (() -> Void)?
  
  private var currencyFormatter: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currencyAccounting
    formatter.locale = Locale(identifier: "en_US")
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 2
    return formatter
  }
  
  private var viewModel: CreateTransactionViewModel
  public init(viewModel: CreateTransactionViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.title = NSLocalizedString("New Expense", comment: "expense title")
    navigationItem.rightBarButtonItem = .init(customView: saveExpenseButton)

    view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    
    setUpConstraints()
    validateTextFieldInput()
    
    viewModel.transactionOutcome = { [weak self] outcome in self?.updateViews(for: outcome) }

  }
  
  public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    view.endEditing(true)
  }
  
}

// MARK: - UITextFieldDelegate
extension CreateTransactionViewController: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let stringRange = Range(range, in: textField.text.orEmpty) else { return false }
        
        let updatedText = textField.text.orEmpty.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count < 20
        
    }
    
}

// MARK: Target/Action
private extension CreateTransactionViewController {
  
  @objc func validateTextFieldInput() {
    let textfieldsNotEmpty = (!merchantInputTextField.text.orEmpty.isEmpty && !amountInputTextField.text.orEmpty.isEmpty)
    let amountGreaterThanZero = amountInputTextField.text.orEmpty != "0.00"
    let isValid = textfieldsNotEmpty && amountGreaterThanZero
    saveExpenseButton.alpha = isValid ? 1.0 : 0.5
    saveExpenseButton.isEnabled = isValid
    navigationItem.rightBarButtonItem?.isEnabled = isValid
  }
  
  @objc func createTransactionButtonTapped() {
    // here i am using `orEmpty` on the textfields just to avoid having to force unwrap the text property but since I'm already validating the textfields input to be empty or the button to be enabled
    
    viewModel.createTransaction(amount: amountInputTextField.text.orEmpty,
                                created: datePicker.date.expensifyDateFormat,
                                merchant: merchantInputTextField.text.orEmpty)
  }
  
  @objc func amountChanged(_ textField: UITextField) {
    
    let array = textField.text.orEmpty.compactMap { Int(String($0)) }
    let num = Double(array.reduce(0, {($0 * 10 + $1)})) / 100
    
    amountInputTextField.text = currencyFormatter.string(from: NSNumber(value: num))
  }
  
}

// MARK: CreateTransactionOutcome
private extension CreateTransactionViewController {
  
  /// changes the state of views based on the sign in state
  private func updateViews(for outcome: CreateTransactionViewModel.CreateTransactionOutcome) {
    switch outcome {
    case .none:
      saveExpenseButton.alpha = 1
      saveExpenseButton.isEnabled = true
    case .creating:
      showIndicator()
      saveExpenseButton.alpha = 0.5
      saveExpenseButton.isEnabled = false
    case .success:
      hideIndicator()
      saveExpenseButton.alpha = 0.5
      saveExpenseButton.isEnabled = false
      didSuccessfullyCreateTransaction?()
    case .failed(title: let title, reason: let message):
      hideIndicator()
      saveExpenseButton.alpha = 1
      saveExpenseButton.isEnabled = true
      displayAlert(title: title, message: message)
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
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
  }
  
  func hideIndicator() {
    activityIndicator.stopAnimating()
    activityIndicator.removeFromSuperview()
  }
}

// MARK: - Constraints
private extension CreateTransactionViewController {
  
  private struct Constants {
    static let width: CGFloat = 300
    static let height: CGFloat = 40
    static let datePickerHeight: CGFloat = 100
    static let topPadding: CGFloat = 30
    static let backgroundViewMultiplier: CGFloat = 0.95
  }
  
  func setUpConstraints() {
    view.add(scrollView)
    
    scrollView.pin(to: self)
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    
    scrollView.add(backgroundView)
    backgroundView.add(containerStackView)

    backgroundView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: Constants.topPadding).isActive = true
    backgroundView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
    backgroundView.heightAnchor.constraint(equalToConstant: Constants.width).isActive = true
    backgroundView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: Constants.backgroundViewMultiplier).isActive = true
    backgroundView.translatesAutoresizingMaskIntoConstraints = false

    containerStackView.center(in: backgroundView)
    containerStackView.translatesAutoresizingMaskIntoConstraints = false

    datePicker.heightAnchor.constraint(equalToConstant: Constants.datePickerHeight).isActive = true
    datePicker.widthAnchor.constraint(equalToConstant: Constants.width).isActive = true
    datePicker.translatesAutoresizingMaskIntoConstraints = false
    
    merchantInputTextField.heightAnchor.constraint(equalToConstant: Constants.height).isActive = true
    merchantInputTextField.widthAnchor.constraint(equalToConstant: Constants.width).isActive = true
    merchantInputTextField.translatesAutoresizingMaskIntoConstraints = false

    amountInputTextField.heightAnchor.constraint(equalToConstant: Constants.height).isActive = true
    amountInputTextField.widthAnchor.constraint(equalToConstant: Constants.width).isActive = true
    amountInputTextField.translatesAutoresizingMaskIntoConstraints = false

  }
  
}

