//
//  UIView+Constraints.swift
//  Drip
//
//  Created by Kauna Mohammed on 17/12/2018.
//  Copyright © 2018 Kauna Mohammed. All rights reserved.
//

import UIKit

public extension UIView {
  func center(in view: UIView) {
    layout {
      $0.centerX == view.centerXAnchor
      $0.centerY == view.centerYAnchor
    }
  }

  func pin(to view: UIView) {
    layout {
      $0.top == view.topAnchor
      $0.leading == view.leadingAnchor
      $0.trailing == view.trailingAnchor
      $0.bottom == view.bottomAnchor
    }
  }
  
  func pin(to viewController: UIViewController) {
    layout {
      $0.top == viewController.topSafeArea
      $0.leading == viewController.view.leadingAnchor
      $0.trailing == viewController.view.trailingAnchor
      $0.bottom == viewController.bottomSafeArea
    }
  }

  func set(height: CGFloat, width: CGFloat) {
    translatesAutoresizingMaskIntoConstraints = false
    heightAnchor.constraint(equalToConstant: height).isActive = true
    widthAnchor.constraint(equalToConstant: width).isActive = true
  }

}
