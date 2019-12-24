//
//  Section.swift
//  mercadoon
//
//  Created by brennobemoura on 21/08/19.
//  Copyright © 2019 brennobemoura. All rights reserved.
//

import Foundation

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

#if canImport(SwiftUI)

import SwiftUI

@available(iOS 13, *)
extension SectionRow: Identifiable where IndexRow: Identifier {
    public var id: Int {
        return self.row.id
    }
}

#endif
