//
//  Identifier.swift
//  mercadoon
//
//  Created by brennobemoura on 21/08/19.
//  Copyright © 2019 brennobemoura. All rights reserved.
//

import Foundation

open class Identifier {
    public let identifier: Int
    
    public init(_ identifier: Int) {
        self.identifier = identifier
    }
}

extension Identifier: Hashable {
    public static func == (lhs: Identifier, rhs: Identifier) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}

public extension Array where Element: Identifier {
    var unique: [Element] {
        return Array(Set(self))
    }
}

#if canImport(SwiftUI)

import SwiftUI

extension Identifier: Identifiable {
    public var id: Int {
        return self.identifier
    }
}

#endif
