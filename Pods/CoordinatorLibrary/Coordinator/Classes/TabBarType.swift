//
//  TabBarCoordinatable.swift
//  Coordinator
//
//  Created by Kauna Mohammed on 15/03/2019.
//

import UIKit

/**
 
 `TabBarType` allows access to a tab bar item
 
 */
public protocol TabBarType: class {
  /// The tab bar item to apply to the root controller
  var tabBarItem: UITabBarItem { get }
}

public extension Array where Element == Coordinatable {
  func convertToTabCoordinator() -> [TabFlowCoordinator] {
    return filter { ($0 is TabFlowCoordinator) }.map { $0 as! TabFlowCoordinator }
  }
}


