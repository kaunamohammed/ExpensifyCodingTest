//
//  UIViewController+SafeAreaConstraints.swift
//  Drip
//
//  Created by Kauna Mohammed on 17/12/2018.
//  Copyright © 2018 Kauna Mohammed. All rights reserved.
//

import UIKit

public extension UIViewController {

  var topSafeArea: NSLayoutYAxisAnchor {
    if #available(iOS 11.0, *) {
      return view.safeAreaLayoutGuide.topAnchor
    } else {
      return topLayoutGuide.topAnchor
    }
  }

  var bottomSafeArea: NSLayoutYAxisAnchor {
    if #available(iOS 11.0, *) {
      return view.safeAreaLayoutGuide.bottomAnchor
    } else {
      return topLayoutGuide.bottomAnchor
    }
  }

}
