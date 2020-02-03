//
//  Identifier.swift
//  mercadoon
//
//  Created by brennobemoura on 21/08/19.
//  Copyright © 2019 brennobemoura. All rights reserved.
//

import Foundation

public protocol Identifier {
    var id: Int { get }
}

public func ==(_ left: Identifier,_ right: Identifier) -> Bool {
    left.id == right.id
}

extension Hashable where Self: Identifier {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }

    public static func ==<Right: Identifier>(_ left: Self,_ right: Right) -> Bool {
        left.id == right.id
    }
}

public extension Array where Element: Identifier & Hashable {
    var unique: [Element] {
        return Array(Set(self))
    }
}
