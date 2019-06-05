//
//  NavigationCoordinator.swift
//  Coordinator
//
//  Created by Kauna Mohammed on 15/03/2019.
//

import UIKit

/**
 
 `NavigationCoordinator` is a base class for subclasses wanting to provide a navigation flow
 
 */
open class NavigationCoordinator<T: UIViewController>: NSObject, UINavigationControllerDelegate, NavigationFlowCoordinator { 
  
  public let presenter: UINavigationController
  
  /// The `UIViewController` associated with the class
  public var viewController: T!
  
  /// Removes the `Coordinatable` instance when the `UINavigationController` dismisses the `UIViewController`
  var removeCoordinator: ((Coordinatable) -> ())
  
  public init(presenter: UINavigationController = .init(), removeCoordinator: @escaping ((Coordinatable) -> ())) {
    self.presenter = presenter
    self.removeCoordinator = removeCoordinator
    super.init()
    presenter.delegate = self
  }
  
  // MARK: - NavigationFlowCoordinator
  open func start() {
    fatalError("Subclass must provide implementation")
  }
  
  public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
    
    
    guard let viewController = navigationController.transitionCoordinator?.viewController(forKey: .from), !navigationController.viewControllers.contains(viewController) else { return }
    
    if viewController is T  {
      removeCoordinator(self)
    }
    
  }
  
}
