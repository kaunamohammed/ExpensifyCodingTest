//
//  NavigationBarCoordinatable.swift
//  Coordinator
//
//  Created by Kauna Mohammed on 15/03/2019.
//

import UIKit

public protocol NavigationBarCoordinatable: class {
  
  /// the presenter of the next viewcontroller
  var presenter: UINavigationController { get }
  
  /// pops the view controller from the navigator hierachy
  func popViewController(animated: Bool)
}

// MARK: - PresentationStyle
public extension NavigationBarCoordinatable {
  
  /// navigates to a `UIViewController` with a particular presentation style
  func navigate(to viewController: UIViewController, with presentationStyle: PresentationStyle, animated: Bool) {
    switch presentationStyle {
    case .present:
      presenter.present(viewController, animated: animated, completion: nil)
    case .push:
      presenter.pushViewController(viewController, animated: animated)
    case .set:
      presenter.setViewControllers([viewController], animated: animated)
    }
  }
  
  func popViewController(animated: Bool) {
    presenter.popViewController(animated: animated)
  }
  
}

public enum PresentationStyle {
  case set, push, present
}
