//
//  RefreshControl.swift
//  OutNow
//
//  Created by Kauna Mohammed on 25/05/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import UIKit.UIRefreshControl

public final class RefreshControl: NSObject {
  
  public var isRefreshing = false
  
  public var title: String? = nil
  public var titleColor: UIColor = .clear {
    didSet {
      refreshControl.attributedTitle = AttributedStringBuilder().append(title.orEmpty, attributes: [.foregroundColor: titleColor]).build()
    }
  }
  
  private let refreshControl = UIRefreshControl()
  
  public init(holder: RefreshControlHoldable) {
    super.init()
    
    holder.add(refreshControl)
    isRefreshing = false
    refreshControl.addTarget(self, action: #selector(refreshControlDidRefresh), for: .valueChanged)
  }
  
  @objc private func refreshControlDidRefresh(_ control: UIRefreshControl) {
    startRefreshing()
  }
  
  @objc public func startRefreshing() {
    isRefreshing = true
    refreshControl.beginRefreshing()
    NotificationCenter.default.post(name: .refreshControlStartedRefreshing, object: nil)
  }
  
  public func endRefreshing() {
    isRefreshing = false
    refreshControl.endRefreshing()
  }
  
}

extension Notification.Name {
  static let refreshControlStartedRefreshing = Notification.Name(rawValue: "refreshControlStartedRefreshing")
}

//NotificationCenter.default.addObserver(self, selector: #selector(startRefreshing), name: .refreshControlStartedRefreshing, object: nil)
