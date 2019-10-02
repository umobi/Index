//
//  Section.swift
//  mercadoon
//
//  Created by brennobemoura on 21/08/19.
//  Copyright © 2019 brennobemoura. All rights reserved.
//

import Foundation

class Section<X, Y> {
    let section: X
    let items: [Y]
    let index: Int
    
    init(_ section: X, items: [Y], section index: Int = 0) {
        self.section = section
        self.items = items
        self.index = index
    }
    
    var asSectionRows: [SectionRow<X, Y>] {
        return self.items.enumerated().compactMap { SectionRow(self, row: .init($0.1, indexPath: .init(row: $0.0, section: self.index))) }
    }
}

final class SectionRow<Index, IndexRow>: IndexProtocol {
    let value: Section<Index, IndexRow>?
    let row: Row<IndexRow>
    
    init(_ section: Section<Index, IndexRow>, row: Row<IndexRow>) {
        self.value = section
        self.row = row
    }
    
    func isSelected(_ value: Bool) -> SectionRow<Index, IndexRow> {
        return .init(self.item, row: .init(selected: self.row.item, indexPath: self.row.indexPath))
    }
    
    var indexPath: IndexPath {
        return self.row.indexPath
    }
    
    var isSelected: Bool {
        return self.row.isSelected
    }
    
    var isFirst: Bool {
        guard let first = self.item.items.first as? Identifier else {
            return self.indexPath.row == 0
        }
        
        guard let value = row.value as? Identifier else {
            return self.indexPath.row == 0
        }
        
        return first == value
    }
    
    var isLast: Bool {
        guard let last = self.item.items.last as? Identifier else {
            return self.indexPath.row == self.item.items.count - 1
        }
        
        guard let value = row.value as? Identifier else {
            return self.indexPath.row == self.item.items.count - 1
        }
        
        return last == value
    }
    
    func select(_ isSelected: Bool) -> SectionRow<Index, IndexRow> {
        return SectionRow(self.item, row: self.row.select(isSelected))
    }
    
    init() {
        self.value = nil
        self.row = .empty
    }
}

protocol SectionDataSource {
    associatedtype T
    var items: [T] { get }
    var asSection: Section<Self, T> { get }
    
    func asSection(with index: Int) -> Section<Self, T>
}

extension SectionDataSource {
    var asSection: Section<Self, T> {
        return .init(self, items: self.items)
    }
    
    func asSection(with index: Int) -> Section<Self, T> {
        return .init(self, items: self.items, section: index)
    }
}

extension Array where Element: SectionDataSource {
    func asSection() -> [Section<Element, Element.T>] {
        return self.enumerated().compactMap { $0.1.asSection(with: $0.0) }
    }
    
    func asSectionRow() -> [[SectionRow<Element, Element.T>]] {
        return self.asSection().compactMap { $0.asSectionRows }
    }
}
