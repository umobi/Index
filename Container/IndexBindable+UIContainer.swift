//
//  IndexBindable+UIContainer.swift
//  mercadoon
//
//  Created by brennobemoura on 06/09/19.
//  Copyright © 2019 brennobemoura. All rights reserved.
//

import Foundation
import UIContainer

public extension UIContainer where View: IndexBindable {
    /// This method should be used when you have a limited number of views that will repeat only because you have an array that will configure your view
    static func asCells<E>(_ elements: [E], in parentView: ParentView!) -> [(Self, E)] where E == View.ViewModel.Index {
        return elements.map {
            let container = self.init(in: parentView, loadHandler: nil)
            container.view.configure($0)
            return (container, $0)
        }
    }
}

public extension UIStackView {
    @discardableResult
    func reloadArrangedSubviews<C: UIContainer, E>(_ container: C.Type, with elements: [E], in parentView: C.ParentView!) -> [(C, E)] where C: UIView, C.View: IndexBindable, E == C.View.ViewModel.Index {
        var containers: [C] = self.arrangedSubviews.compactMap {
            guard let container = $0 as? C else {
                $0.removeFromSuperview()
                return nil
            }

            return container
        }

        if containers.count > elements.count {
            containers[elements.count..<containers.count].forEach {
                $0.removeContainer()
            }
            containers = Array(containers[0..<elements.count])

        } else if elements.count > containers.count {
            containers = containers + (containers.count..<elements.count).map { _ in
                return C.init(in: parentView, loadHandler: nil)
            }
        }

        return elements.enumerated().map {
            containers[$0.offset].view.configure($0.element)
            if containers[$0.offset].superview == nil {
                self.addArrangedSubview(containers[$0.offset])
            }
            return (containers[$0.offset], $0.element)
        }
    }
}
