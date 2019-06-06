//
//  AttributedStringBuilder.swift
//  OutNow
//
//  Created by Kauna Mohammed on 29/05/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import Foundation

class AttributedStringBuilder {
  
  typealias Attributes = [NSAttributedString.Key: Any]
  
  private let string = NSMutableAttributedString(string: "")
  
  @discardableResult
  func append(_ str: String, attributes: Attributes) -> AttributedStringBuilder {
    let addedString = NSAttributedString(string: str, attributes: attributes)
    string.append(addedString)
    return self
  }
  
  func build() -> NSAttributedString {
    return NSAttributedString(attributedString: string)
  }
  
}
