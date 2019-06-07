//
//  UITableView+Ext.swift
//  Hut
//
//  Created by Kauna Mohammed on 13/12/2018.
//  Copyright © 2018 Kauna Mohammed. All rights reserved.
//

import UIKit

extension UITableView {
  func removeEmptyCells() {
    tableFooterView = UIView()
  }
  
  func add(refreshControl: UIRefreshControl) {
    if #available(iOS 10.0, *) {
      self.refreshControl = refreshControl
    } else {
      addSubview(refreshControl)
    }
  }
  
}
