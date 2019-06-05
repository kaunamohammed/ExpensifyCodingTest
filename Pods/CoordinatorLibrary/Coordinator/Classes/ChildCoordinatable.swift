//
//  ChildCoordinatable.swift
//  Pods-Coordinator_Example
//
//  Created by Kauna Mohammed on 15/03/2019.
//

/**
 `ChildCoordinatable` handles adding and removing child coordinatables from types conforming to it
 */
public protocol ChildCoordinatable: class {
  
  /// The array containing any child coordinatable
  var childCoordinators: [Coordinatable] { get set } 
  
  /**
   
   Add a child coordinatable to the parent
   
   - parameter coordinator: The coordinator to add as a child
   
   */
  func add(child coordinator: Coordinatable)
  
  /**
   
   Removes a child coordinatable from the parent
   
   - parameter coordinator: The coordinator to remove from the parent
   
   */
  func remove(child coordinator: Coordinatable)
  
  /// Removes all child coordinatables from the parent
  func removeAll()
}

// MARK: - Default Implementations
extension ChildCoordinatable {
  
  public func add(child coordinator: Coordinatable) {
    childCoordinators.append(coordinator)
  }
  
  /**
   
   Adds 0 - N children coordinatables to the parent
   
   - parameter children: The children to add
   
   */
  
  public func add(children : Coordinatable...) {
    children.forEach { childCoordinators.append($0) }
  }
  
  public func remove(child coordinator: Coordinatable) {
    childCoordinators = childCoordinators.filter { $0 !== coordinator }
  }
  
  public func removeAll() {
    childCoordinators.removeAll()
  }
  
  public func printChildCount() {
    print(childCoordinators.count)
  }
}
