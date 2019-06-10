//
//  AppDelegate.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 05/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import UIKit
import CoordinatorLibrary

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  // keeping a reference so that it lasts the entirety of the app lifecycle
  // Although I have initialized it from here, it is still possible to just keep a reference and then inherit from `AppCoordinator`
  // and start different flows based oon business logic i.e a notification or deeplink
  private lazy var appCoordinator: AppCoordinator = {
    let coordinator = ExpensifyAppCoordinator(presenter: AppdNavController(), window: window!)
    return coordinator
  }()

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
    window = UIWindow(frame: UIScreen.main.bounds)
                
    // start the navigation
    appCoordinator.start()
    
    return true
  }

}

func delay(seconds: Double, _ block: @escaping (() -> Void)) {
  DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
    block()
  }
}
