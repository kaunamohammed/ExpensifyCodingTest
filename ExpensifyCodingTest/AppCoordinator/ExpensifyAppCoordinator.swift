//
//  ExpensifyAppCoordinator.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 05/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import CoordinatorLibrary

/**
 'AppCoordinator' is similar to the 'AppDelegate' class in the sense that it launches all other coordinators used in the app
 
 It inherits from the `ChildCoordinator` base class which encapsulates the implementation details having to do with navigation and child coordinator management i.e adding/removing a child coordinator
 
 I could mark this class as `final` but incase I want to kick of a different navigation flow based on business logic I'll like to inherit from this class
 */
class ExpensifyAppCoordinator: AppCoordinator {
  
  var signInViewCoordinator: SignInViewCoordinator!
  
  override func start() {
    
    signInViewCoordinator = SignInViewCoordinator(presenter: presenter,
                                                  removeCoordinator: remove)
    
    // adding the signInViewCoordinator to the Coordinator Hierachy
    add(child: signInViewCoordinator)
    
    // calling start to trigger the navigation to signInViewCoordinator
    signInViewCoordinator.start()
    
  }
  
}

