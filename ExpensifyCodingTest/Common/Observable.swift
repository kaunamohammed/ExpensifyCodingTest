//
//  Observable.swift
//  ExpensifyCodingTest
//
//  Created by Kauna Mohammed on 07/06/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import Foundation

public protocol ObservableProtocol {
  associatedtype T
  var value: T { get set }
  func subscribe(observer: AnyObject, block: @escaping (_ newValue: T, _ oldValue: T) -> ())
  func unsubscribe(observer: AnyObject)
}

public final class Observable<T>: ObservableProtocol {
  
  typealias ObserverBlock = ((_ newValue: T, _ oldValue: T) -> ())
  typealias ObserverEntry = (AnyObject, ObserverBlock)

  
  public var value: T {
    didSet {
      observers.forEach { (entry: ObserverEntry) in
        let (_, block) = entry
        block(value, oldValue)
      }
    }
  }
  
  private var observers: Array<ObserverEntry>
  
  init(_ value: T) {
    self.value = value
    observers = []
  }
  
  public func subscribe(observer: AnyObject, block: @escaping (T, T) -> ()) {
    let entry: ObserverEntry = (observer: observer, block: block)
    observers.append(entry)
  }
  
  public func unsubscribe(observer: AnyObject) {
    observers = observers.filter { entry in
      let (owner, _) = entry
      return owner !== observer
    }
  }
  
}
