//
//  Identifier.swift
//  mercadoon
//
//  Created by brennobemoura on 21/08/19.
//  Copyright © 2019 brennobemoura. All rights reserved.
//

import Foundation

public protocol Identifier {
    var identifier: Int { get }
}

public extension Equatable where Self: Identifier {}

public func == (lhs: Identifier?, rhs: Identifier?) -> Bool {
    return lhs?.identifier == rhs?.identifier
}

public func != (lhs: Identifier?, rhs: Identifier?) -> Bool {
    return lhs?.identifier != rhs?.identifier
}
