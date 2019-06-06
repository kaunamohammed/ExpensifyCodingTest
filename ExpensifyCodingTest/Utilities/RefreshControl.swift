//
//  RefreshControl.swift
//  OutNow
//
//  Created by Kauna Mohammed on 25/05/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import UIKit.UIRefreshControl

class RefreshControl: NSObject {
  
  var isRefreshing = false
  private let refreshControl = UIRefreshControl()
  
  init(holder: RefreshControlHoldable) {
    super.init()
    
    holder.add(refreshControl)
    refreshControl.addTarget(self, action: #selector(refreshControlDidRefresh), for: .valueChanged)
    
  }
  
  @objc private func refreshControlDidRefresh(_ control: UIRefreshControl) {
    startRefreshing()
  }
  
  func startRefreshing() {
    isRefreshing = true
    refreshControl.beginRefreshing()
  }
  
  func endRefreshing() {
    isRefreshing = false
    refreshControl.endRefreshing()
  }
  
}
