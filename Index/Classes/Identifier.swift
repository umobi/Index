//
//  Identifier.swift
//  mercadoon
//
//  Created by brennobemoura on 21/08/19.
//  Copyright © 2019 brennobemoura. All rights reserved.
//

import Foundation

protocol Identifier {
    var identifier: Int { get }
}

extension Equatable where Self: Identifier {}

func == (lhs: Identifier?, rhs: Identifier?) -> Bool {
    return lhs?.identifier == rhs?.identifier
}

func != (lhs: Identifier?, rhs: Identifier?) -> Bool {
    return lhs?.identifier != rhs?.identifier
}
