//
//  UIView+Constraints.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 10/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import UIKit

extension UIView {
  
  func pin(to view: UIView) {
    topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
  }
  
  func pin(to viewController: UIViewController) {
    topAnchor.constraint(equalTo: viewController.topSafeArea).isActive = true
    leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor).isActive = true
    trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor).isActive = true
    bottomAnchor.constraint(equalTo: viewController.bottomSafeArea).isActive = true
  }
  
  func center(in view: UIView) {
    centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
  }
  
}
