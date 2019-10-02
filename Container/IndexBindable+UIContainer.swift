//
//  IndexBindable+UIContainer.swift
//  mercadoon
//
//  Created by brennobemoura on 06/09/19.
//  Copyright © 2019 brennobemoura. All rights reserved.
//

import Foundation
import UIContainer

extension UIContainer where View: IndexBindable {
    /// This method should be used when you have a limited number of views that will repeat only because you have an array that will configure your view
    static func asCells<E>(_ elements: [E], in parentView: ParentView!) -> [(Self, E)] where E == View.Model.Index {
        return elements.map {
            let container = self.init(in: parentView, loadHandler: nil)
            container.view.configure($0)
            return (container, $0)
        }
    }
}
