//
//  ChildCoordinator.swift
//  Pods-Coordinator_Example
//
//  Created by Kauna Mohammed on 15/03/2019.
//

/// a convenience class to allow ommiting the `ChildCoordinatable` protocol requirement
/// while still having the benefit of `ChildCoordinatable`
open class ChildCoordinator<T: UIViewController>: NavigationCoordinator<T>, ChildCoordinatable  {
  
  public lazy var childCoordinators: [Coordinatable] = []
  
  open override func start() {
    fatalError("Subclass should implement")
  }
  
}
