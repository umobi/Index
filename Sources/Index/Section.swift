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

public class Section<X, Y> {
    public let section: X
    public let items: [Y]
    public let index: Int
    
    public init(_ section: X, items: [Y], section index: Int = 0) {
        self.section = section
        self.items = items
        self.index = index
    }
    
    public var asSectionRows: [SectionRow<X, Y>] {
        return self.items.enumerated().compactMap { SectionRow(self, row: .init($0.1, indexPath: .init(row: $0.0, section: self.index))) }
    }
}

final public class SectionRow<Index, IndexRow>: IndexProtocol {
    public let value: Section<Index, IndexRow>?
    public let row: Row<IndexRow>
    
    public init(_ section: Section<Index, IndexRow>, row: Row<IndexRow>) {
        self.value = section
        self.row = row
    }
    
    public var indexPath: IndexPath {
        return self.row.indexPath
    }
    
    public var isSelected: Bool {
        return self.row.isSelected
    }
    
    public var isFirst: Bool {
        guard let first = self.item.items.first as? Identifier else {
            return self.indexPath.row == 0
        }
        
        guard let value = row.value as? Identifier else {
            return self.indexPath.row == 0
        }
        
        return first == value
    }
    
    public var isLast: Bool {
        guard let last = self.item.items.last as? Identifier else {
            return self.indexPath.row == self.item.items.count - 1
        }
        
        guard let value = row.value as? Identifier else {
            return self.indexPath.row == self.item.items.count - 1
        }
        
        return last == value
    }
    
    public func select(_ isSelected: Bool) -> SectionRow<Index, IndexRow> {
        return SectionRow(self.item, row: self.row.select(isSelected))
    }
    
    public init() {
        self.value = nil
        self.row = .empty
    }
}

public protocol SectionDataSource {
    associatedtype T
    var items: [T] { get }
    var asSection: Section<Self, T> { get }
    
    func asSection(with index: Int) -> Section<Self, T>
}

public extension SectionDataSource {
    var asSection: Section<Self, T> {
        return .init(self, items: self.items)
    }
    
    func asSection(with index: Int) -> Section<Self, T> {
        return .init(self, items: self.items, section: index)
    }
}

public extension Array where Element: SectionDataSource {
    func asSection() -> [Section<Element, Element.T>] {
        return self.enumerated().compactMap { $0.1.asSection(with: $0.0) }
    }
    
    func asSectionRow() -> [[SectionRow<Element, Element.T>]] {
        return self.asSection().compactMap { $0.asSectionRows }
    }
}
