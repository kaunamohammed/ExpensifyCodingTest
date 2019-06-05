//
//  InitConfigurable.swift
//  Collabo
//
//  Created by Kauna Mohammed on 02/02/2019.
//  Copyright © 2019 Kauna Mohammed. All rights reserved.
//

import Foundation

public protocol InitConfigurable {
    init()
}

public extension InitConfigurable {
    init(configure: (Self) -> Void) {
        self.init()
        configure(self)
    }
}

extension NSObject: InitConfigurable {}
