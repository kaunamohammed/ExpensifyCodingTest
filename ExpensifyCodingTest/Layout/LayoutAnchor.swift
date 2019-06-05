//
//  LayoutAnchor.swift
//  PREND
//
//  Created by Kauna Mohammed on 14/10/2018.
//  Copyright © 2018 Kauna Mohammed. All rights reserved.
//

import UIKit.NSLayoutConstraint

public protocol LayoutAnchor {
    func constraint(equalTo anchor: Self, constant: CGFloat) -> NSLayoutConstraint
    func constraint(greaterThanOrEqualTo anchor: Self, constant: CGFloat) -> NSLayoutConstraint
    func constraint(lessThanOrEqualTo anchor: Self, constant: CGFloat) -> NSLayoutConstraint
}

extension NSLayoutAnchor: LayoutAnchor {}
