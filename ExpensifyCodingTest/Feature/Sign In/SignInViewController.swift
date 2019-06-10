//
//  SignInViewController.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 05/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import UIKit

public final class SignInViewController: UIViewController, AlertDisplayable {
  
  private lazy var activityIndicator: UIActivityIndicatorView = .init(style: .gray)
  
  private let backgroundImageView = UIImageView {
    $0.image = #imageLiteral(resourceName: "expensifythis-6")
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
  }
  
  private let backgroundView = UIView {
    $0.alpha = 0.4
    $0.backgroundColor = #colorLiteral(red: 0.06274509804, green: 0.05882352941, blue: 0.05882352941, alpha: 1)
  }
  
  private let logoImageView = UIImageView {
    $0.image = #imageLiteral(resourceName: "expensify-logo")
    $0.contentMode = .scaleAspectFit
    $0.clipsToBounds = true
  }
  
  private lazy var emailTextField = UITextField {
    $0.placeholder = "Email"
    $0.borderStyle = .roundedRect
    $0.keyboardType = .emailAddress
    $0.autocapitalizationType = .none
    $0.delegate = self
    $0.addTarget(self, action: #selector(validateTextFieldInput), for: .editingChanged)
  }
  
  private lazy var passwordTextField = UITextField {
    $0.placeholder = "Password"
    $0.isSecureTextEntry = true
    $0.borderStyle = .roundedRect
    $0.delegate = self
    $0.addTarget(self, action: #selector(validateTextFieldInput), for: .editingChanged)
  }
  
  private lazy var signInButton = UIButton {
    $0.backgroundColor = #colorLiteral(red: 0.2901960784, green: 0.5647058824, blue: 0.8862745098, alpha: 1)
    $0.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    $0.layer.shadowRadius = 1
    $0.layer.shadowOffset = CGSize(width: 0, height: 0)
    $0.layer.shadowOpacity = 0.95
    $0.layer.cornerRadius = 5
    $0.setTitle("Sign In", for: .normal)
    $0.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
  }
  
  private lazy var containerStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [logoImageView, emailTextField, passwordTextField, signInButton])
    stackView.alignment = .center
    stackView.axis = .vertical
    stackView.spacing = 20
    stackView.distribution = .fill
    if #available(iOS 11.0, *) {
      stackView.setCustomSpacing(30, after: logoImageView)
      stackView.setCustomSpacing(25, after: passwordTextField)
    }
    return stackView
  }()
  
  /// callback to receive success sign in notification
  public var successfullySignedIn: (() -> Void)?
  
  private var viewModel: SignInViewModel
  public init(viewModel: SignInViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override public func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    
    setUpConstraints()
    validateTextFieldInput()
    
    viewModel.authStateChanged = { [updateViews] state in updateViews(state) }
    
  }
  
  override public func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    navigationController?.defaultBarPreference(shouldApply: false)
  }
  
  override public func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    emailTextField.text = ""
    passwordTextField.text = ""
  }
  
  override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    view.endEditing(true)
  }

}

// MARK: - UITextFieldDelegate
extension SignInViewController: UITextFieldDelegate {}

// MARK: - Target/Action
private extension SignInViewController {
  
  /// validates the input from the textFields
  @objc func validateTextFieldInput() {
    let isValid = (!emailTextField.text.orEmpty.isEmpty && !passwordTextField.text.orEmpty.isEmpty)
    signInButton.alpha = isValid ? 1.0 : 0.5
    signInButton.isEnabled = isValid
  }
  
  @objc func signInButtonTapped() {
    viewModel.attemptSignIn(with: Credentials(id: emailTextField.text.orEmpty, password: passwordTextField.text.orEmpty))
  }
  
}

// MARK: - SignInState
private extension SignInViewController {
  
  /// changes the state of views based on the sign in state
  private func updateViews(for state: SignInViewModel.SignInState) {
    switch state {
    case .signingIn:
      showIndicator()
      signInButton.alpha = 0.7
      signInButton.isEnabled = false
    case .signedIn:
      hideIndicator()
      signInButton.alpha = 0.7
      signInButton.isEnabled = false
      successfullySignedIn?()
    case .failed(title: let title, reason: let message):
      hideIndicator()
      signInButton.alpha = 1
      signInButton.isEnabled = true
      displayAlert(title: title, message: message)
    }
  }
  
}

// MARK: - Loading Indicator
extension SignInViewController {
  func showIndicator() {
    signInButton.add(activityIndicator)
    activityIndicator.startAnimating()
    activityIndicator.trailingAnchor.constraint(equalTo: signInButton.trailingAnchor, constant: -10).isActive = true
    activityIndicator.centerYAnchor.constraint(equalTo: signInButton.centerYAnchor).isActive = true
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
  }
  
  func hideIndicator() {
    activityIndicator.stopAnimating()
    activityIndicator.removeFromSuperview()
  }
}

// MARK: - Constraints
private extension SignInViewController {
  
  func setUpConstraints() {
    view.add(backgroundImageView, backgroundView, containerStackView)
    
    backgroundImageView.pin(to: view)
    backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
    
    backgroundView.pin(to: backgroundImageView)
    backgroundView.translatesAutoresizingMaskIntoConstraints = false
    
    containerStackView.topAnchor.constraint(equalTo: topSafeArea, constant: 15).isActive = true
    containerStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    containerStackView.translatesAutoresizingMaskIntoConstraints = false
    
    let height = view.frame.size.height * 0.06
    let width = view.frame.size.width * 0.95
    
    logoImageView.heightAnchor.constraint(equalToConstant: height).isActive = true
    logoImageView.widthAnchor.constraint(equalToConstant: width).isActive = true
    logoImageView.translatesAutoresizingMaskIntoConstraints = false
    
    emailTextField.heightAnchor.constraint(equalToConstant: height).isActive = true
    emailTextField.widthAnchor.constraint(equalToConstant: width).isActive = true
    emailTextField.translatesAutoresizingMaskIntoConstraints = false
    
    passwordTextField.heightAnchor.constraint(equalToConstant: height).isActive = true
    passwordTextField.widthAnchor.constraint(equalToConstant: width).isActive = true
    passwordTextField.translatesAutoresizingMaskIntoConstraints = false
    
    signInButton.heightAnchor.constraint(equalToConstant: height).isActive = true
    signInButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
    signInButton.translatesAutoresizingMaskIntoConstraints = false
    
  }
}
