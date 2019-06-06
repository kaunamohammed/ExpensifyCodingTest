//
//  AlertDisplayable.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 06/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import UIKit.UIViewController

/**
 
 Displays an alert on a `UIViewController`
 
 - note:
 Here we're making the protocol only accessible to instances of `UIViewController`. For two reasons
    - To restrict the types that can display an alert
    - To give us access to properties/methods/functions available to `UIViewController`
 */
protocol AlertDisplayable: UIViewController {
  func displayAlert(title: String, message: String)
}

extension AlertDisplayable {
  func displayAlert(title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
    alertController.addAction(okAction)
    present(alertController, animated: true, completion: nil)
  }
}
