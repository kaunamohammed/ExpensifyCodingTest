//
//  SignInViewController.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 05/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import UIKit

final class SignInViewController: UIViewController {
  
  private let emailTextField = UITextField {
    $0.placeholder = "Email"
    $0.borderStyle = .roundedRect
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private let passwordTextField = UITextField {
    $0.placeholder = "Password"
    $0.borderStyle = .roundedRect
  }
  
  private let signInButton = UIButton {
    $0.backgroundColor = #colorLiteral(red: 0.2901960784, green: 0.5647058824, blue: 0.8862745098, alpha: 1)
    $0.layer.cornerRadius = 5
    $0.setTitle("Sign In", for: .normal)
  }
  
  private lazy var containerStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, signInButton])
    stackView.alignment = .center
    stackView.axis = .vertical
    stackView.spacing = 20
    stackView.distribution = .fill
    if #available(iOS 11.0, *) {
      stackView.setCustomSpacing(30, after: passwordTextField)
    }
    return stackView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()

    title = "Sign In"
    view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    
    layoutSubViews()

  }
  
  fileprivate func layoutSubViews() {
    view.add(containerStackView)
    containerStackView.center(in: view)
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

