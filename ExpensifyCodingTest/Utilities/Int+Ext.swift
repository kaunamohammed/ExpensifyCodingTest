//
//  Int+Ext.swift
//  OutNow
//
//  Created by Kauna Mohammed on 29/05/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//


extension Int {
  
  var asString: String {
    return String(self)
  }
  
  var asDouble: Double {
    return Double(self)
  }
  
  var asCurrency: Double {
    return Double(self / 1000)
  }
  
}

