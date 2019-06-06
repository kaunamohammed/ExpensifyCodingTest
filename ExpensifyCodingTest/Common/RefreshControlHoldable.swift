//
//  RefreshControlHoldable.swift
//  OutNow
//
//  Created by Kauna Mohammed on 28/05/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import UIKit

protocol RefreshControlHoldable {
  func add(_ refreshControl: UIRefreshControl)
}

extension RefreshControlHoldable where Self: UIScrollView {
  func add(_ refreshControl: UIRefreshControl) {
    if #available(iOS 10.0, *) {
      self.refreshControl = refreshControl
    } else {
      addSubview(refreshControl)
    }
  }
}

extension UIScrollView: RefreshControlHoldable {}
