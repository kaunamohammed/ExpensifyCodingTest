//
//  StoryBoardSupportable.swift
//  CoordinatorLibrary
//
//  Created by Kauna Mohammed on 16/03/2019.
//

import Foundation

public protocol StoryBoardSupportable: class {
  static func instantiate(from storyboard: String, bundle: Bundle) -> Self
}

public extension StoryBoardSupportable where Self: UIViewController {
  static func instantiate(from storyboard: String, bundle: Bundle = .main) -> Self {
    let fullName = NSStringFromClass(self)
    let className = fullName.components(separatedBy: ".")[1]
    let storyboard = UIStoryboard(name: storyboard, bundle: bundle)
    return storyboard.instantiateViewController(withIdentifier: className) as! Self
  }
}
