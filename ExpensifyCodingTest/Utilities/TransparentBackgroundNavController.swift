//
//  TransparentBackgroundNavController.swift
//  Common
//
//  Created by Kauna Mohammed on 25/04/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import UIKit

public class AppdNavController: UINavigationController {
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationBar.shadowImage = UIImage()
    view.backgroundColor = .clear
    navigationBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
  }
  
  override public var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  
}
