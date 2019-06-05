//
//  AddableAndRemovabke.swift
//  Hut
//
//  Created by Kauna Mohammed on 25/11/2018.
//  Copyright © 2018 Kauna Mohammed. All rights reserved.
//

import UIKit

public protocol AddableAndRemovable {
    associatedtype Child
    func add(_ child: Child)
    func remove(_ child: Child)
}

public extension AddableAndRemovable {

    func add(_ child: Child...) {
        child.forEach(add)
    }

    func remove(_ child: Child...) {
        child.forEach(remove)
    }
}

extension UIViewController: AddableAndRemovable {
  public func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }

  public func remove(_ child: UIViewController) {
        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }
}

extension UIView: AddableAndRemovable {
  public func add(_ child: UIView) {
        addSubview(child)
    }

  public func remove(_ child: UIView) {
        child.removeFromSuperview()
    }
}
