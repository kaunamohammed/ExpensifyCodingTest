//
//  SignInViewController.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 05/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import UIKit

final class SignInViewController: UIViewController, AlertDisplayable {
  
  lazy var activityIndicator: UIActivityIndicatorView = .init(style: .gray)
  
  private let logoImageView = UIImageView {
    $0.image = #imageLiteral(resourceName: "expensify-logo")
    $0.contentMode = .scaleAspectFit
    $0.clipsToBounds = true
  }
  
  // marked lazy so i can have self available
  private lazy var emailTextField = UITextField {
    $0.placeholder = "Email"
    $0.borderStyle = .roundedRect
    $0.keyboardType = .emailAddress
    $0.autocapitalizationType = .none
    $0.delegate = self
    $0.addTarget(self, action: #selector(validateTextFieldInput), for: .editingChanged)
  }
  
  // marked lazy so i can have self available
  private lazy var passwordTextField = UITextField {
    $0.placeholder = "Password"
    $0.isSecureTextEntry = true
    $0.borderStyle = .roundedRect
    $0.delegate = self
    $0.addTarget(self, action: #selector(validateTextFieldInput), for: .editingChanged)
  }
  
  // marked lazy so i can have self available
  private lazy var signInButton = UIButton {
    $0.backgroundColor = #colorLiteral(red: 0.2901960784, green: 0.5647058824, blue: 0.8862745098, alpha: 1)
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
      stackView.setCustomSpacing(50, after: logoImageView)
      stackView.setCustomSpacing(30, after: passwordTextField)
    }
    return stackView
  }()
  
  public var successfullySignedIn: ((APIResponse) -> Void)?
  
  private var viewModel: SignInViewModel
  init(viewModel: SignInViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "Sign In"

    view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    setUpConstraints()
    
    #if DEBUG
    emailTextField.text = "expensifytest@mailinator.com"
    passwordTextField.text = "hire_me"
    #endif
    
    validateTextFieldInput()
    
    viewModel.signInStateChanged = { [updateViews] state in updateViews(state) }
    
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    view.endEditing(true)
  }

}

// MARK: - UITextFieldDelegate
extension SignInViewController: UITextFieldDelegate {}

// MARK: - Target/Action
private extension SignInViewController {
  
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
      signInButton.alpha = 0.5
      signInButton.isEnabled = false
    case .signedIn(response: let response):
      hideIndicator()
      signInButton.alpha = 0.5
      signInButton.isEnabled = false
      successfullySignedIn?(response)
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
    view.add(activityIndicator)
    activityIndicator.startAnimating()
    activityIndicator.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 10).isActive = true
    activityIndicator.centerXAnchor.constraint(equalTo: signInButton.centerXAnchor).isActive = true
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
    view.add(containerStackView)
    
    containerStackView.topAnchor.constraint(equalTo: topSafeArea, constant: 30).isActive = true
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
    signInButton.widthAnchor.constraint(equalToConstant: width).isActive = true
    signInButton.translatesAutoresizingMaskIntoConstraints = false
    
    
  }
}
