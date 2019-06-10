//
//  NavigationController+Ext.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 10/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import UIKit

extension UINavigationController {
  func defaultBarPreference(shouldApply: Bool) {
    if shouldApply {
      navigationBar.shadowImage = nil
      navigationBar.setBackgroundImage(nil, for: .default)
      view.backgroundColor = .clear
      navigationBar.barTintColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
    } else {
      navigationBar.shadowImage = UIImage()
      navigationBar.setBackgroundImage(UIImage(), for: .default)
      view.backgroundColor = .clear
    }
  }
}
