//
//  UITableView+Ext.swift
//  Hut
//
//  Created by Kauna Mohammed on 13/12/2018.
//  Copyright © 2018 Kauna Mohammed. All rights reserved.
//

import UIKit.UITableView

extension UITableView {
  func removeEmptyCells() {
    tableFooterView = UIView()
  }
}
