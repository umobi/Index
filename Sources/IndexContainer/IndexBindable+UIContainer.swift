//
// Copyright (c) 2019-Present Umobi - https://github.com/umobi
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import Foundation
import UIKit
import UIContainer

#if !COCOAPODS
import Index
import IndexBindable
#endif

public extension ContainerRepresentable where View: IndexBindable {
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
    func reloadArrangedSubviews<C: ContainerRepresentable, E>(_ container: C.Type, with elements: [E], in parentView: C.ParentView!) -> [(C, E)] where C: UIView, C.View: IndexBindable, E == C.View.ViewModel.Index {
        var containers: [C] = self.arrangedSubviews.compactMap {
            guard let container = $0 as? C else {
                $0.removeFromSuperview()
                return nil
            }

            return container
        }

        if containers.count > elements.count {
            containers[elements.count..<containers.count].forEach {
                $0.removeFromSuperview()
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
