//
//  LoadingDisplayable.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 06/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import UIKit.UIViewController

protocol LoadingDisplayable: UIViewController {
  var activityIndicator: UIActivityIndicatorView? { get set }
  func showIndicator()
  func hideIndicator()
}

extension LoadingDisplayable {
  func showIndicator() {
    activityIndicator = .init(style: .gray)
    view.add(activityIndicator!)
    activityIndicator!.startAnimating()
  }
  func hideIndicator() {
    activityIndicator?.stopAnimating()
    activityIndicator?.removeFromSuperview()
  }
}

