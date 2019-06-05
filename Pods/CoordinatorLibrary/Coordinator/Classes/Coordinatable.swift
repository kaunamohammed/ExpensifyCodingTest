//
//  Coordinatable.swift
//  Coordinator
//
//  Created by Kauna Mohammed on 15/03/2019.
//

import UIKit

public typealias TabFlowCoordinator = NavigationBarCoordinatable & TabBarType
public typealias NavigationFlowCoordinator = Coordinatable & NavigationBarCoordinatable

/**
 `Coordinatable` starts the flow of the app by abstracting away the handling of navigation from the `UIViewController` and delegating that responsibility to a type that conforms to it
 */
public protocol Coordinatable: class {
  
  /// starts the navigation from one view controller to the next
  func start()
  
}

// MARK: - Default Implementations
public extension Coordinatable {
  func start() {
    fatalError("Use a concrete implementation")
  }
  
}


