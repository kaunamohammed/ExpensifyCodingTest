//
//  SignInViewController.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 05/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import UIKit

final class SignInViewController: UIViewController, AlertDisplayable {
  
  var activityIndicator: UIActivityIndicatorView?
  
  private let logoImageView = UIImageView {
    $0.image = #imageLiteral(resourceName: "expensify-logo")
    $0.contentMode = .scaleAspectFill
  }
  
  private lazy var emailTextField = UITextField {
    $0.placeholder = "Email"
    $0.borderStyle = .roundedRect
    $0.keyboardType = .emailAddress
    $0.autocapitalizationType = .none
    $0.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .allEditingEvents)
    //$0.delegate = self
  }
  
  private lazy var passwordTextField = UITextField {
    $0.placeholder = "Password"
    $0.isSecureTextEntry = true
    $0.borderStyle = .roundedRect
    $0.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .allEditingEvents)
    //$0.delegate = self
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
  
  // this passes a notification to the coordinator that sign in was a success and it's okay to navigate to the main screen
  // includes information about the `APIResponse`
  public var successfullySignedIn: ((APIResponse) -> Void)?
  
  private let router: NetworkRouter
  init(router: NetworkRouter) {
    self.router = router
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Sign In"
    view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    signInButton.alpha = 0.5
    signInButton.isEnabled = false
    layoutSubViews()
    
  }
  
  // FIXME: - when either textField get edited this turns the button on, need too wait for both textfields to not be empty
  @objc func textFieldEditingChanged(_ textField: UITextField) {
//    signInButton.alpha = textField.text.orEmpty.isEmpty ? 0.5 : 1.0
//    signInButton.isEnabled = !textField.text.orEmpty.isEmpty
  }
  
  @objc private func signInButtonTapped() {
    attemptSignIn(with: Credentials(id: emailTextField.text.orEmpty, password: passwordTextField.text.orEmpty))
  }
  
}

// MARK: - Networking
private extension SignInViewController {
  func attemptSignIn(with credentials: Credentials) {
    showIndicator()
    signInButton.alpha = 0.5
    signInButton.isEnabled = false
    
    // I prefer to capture objects directly rather than doing the weak/unowned self dance
    router.request(EndPoint.authenticateUser(partnerUserID: credentials.id,
                                             partnerUserSecret: credentials.password)) { [signInButton, hideIndicator, successfullySignedIn, displayAlert] (result) in
      switch result {
      case .success(let data):
        do {
          let apiResponse: APIResponse = try data.decoded()
          switch apiResponse.jsonCode {
          case 200...299:
            hideIndicator()
            signInButton.alpha = 0.5
            signInButton.isEnabled = false
            successfullySignedIn?(apiResponse)
          default:
            hideIndicator()
            displayAlert("Uh Oh", "Looks like there was a problem signing in. Please check your credentials or wait a little and try again")
          }
        } catch let error {
          hideIndicator()
          signInButton.alpha = 1
          signInButton.isEnabled = true
          displayAlert("Uh Oh", error.localizedDescription)
        }
        
      case .failure(let error):
        hideIndicator()
        signInButton.alpha = 1
        signInButton.isEnabled = true
        displayAlert("Uh Oh", error.errorDescription.orEmpty)
      }
      
    }
  }
}

// MARK: - Alerts
extension SignInViewController: LoadingDisplayable {
  func showIndicator() {
    activityIndicator = .init(style: .gray)
    view.add(activityIndicator!)
    activityIndicator!.startAnimating()
    activityIndicator!.layout {
      $0.top == signInButton.bottomAnchor + 10
      $0.centerX == signInButton.centerXAnchor
    }
  }
}

// MARK: - Layout
private extension SignInViewController {
  func layoutSubViews() {
    view.add(containerStackView)
    containerStackView.layout {
      $0.top == topSafeArea + 50
      $0.centerX == view.centerXAnchor
    }
    // I favour this approach to reduce the amount of layout code when I have the same view layout specifications
    containerStackView.arrangedSubviews
      .forEach {
        $0.layout {
          $0.height == view.heightAnchor - (view.frame.height * 0.95)
          $0.width == view.widthAnchor - (view.frame.width * 0.2)
        }
    }
    
  }
}

//
//case 401...500:
//hideActivityIndicator()
//showAlert("Uh Oh", "Looks like there was a problem signing you in")
//case 501...599:
//hideActivityIndicator()
//showAlert("Uh Oh", "We can't sign you in at this time")
