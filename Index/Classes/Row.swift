//
//  Row.swift
//  mercadoon
//
//  Created by brennobemoura on 21/08/19.
//  Copyright © 2019 brennobemoura. All rights reserved.
//

import Foundation

extension IndexPath {
    static var zero: IndexPath {
        return .init(row: 0, section: 0)
    }
}

enum RowEditable<T> {
    case remove(T)
    case insert(T)
}

protocol IndexProtocol {
    associatedtype Index
    var value: Index? { get }
    var indexPath: IndexPath { get }
    var isSelected: Bool { get }
    
    func select(_ isSelected: Bool) -> Self
    
    init()
}

extension Array where Element: IndexProtocol {
    func uniqued() -> [Element] {
        return reduce(into: []) { result, element in
            if !result.contains(where: { $0.indexPath == element.indexPath }) {
                result.append(element)
            }
        }
    }
}

extension IndexProtocol {
    var item: Index {
        return self.value!
    }
    
    var isEmpty: Bool {
        return self.value == nil
    }
    
    static var empty: Self {
        return .init()
    }
}

final class Row<Index>: IndexProtocol {
    let value: Index?
    let isSelected: Bool
    
    let indexPath: IndexPath
    
    init(_ value: Index, indexPath: IndexPath = .zero) {
        self.value = value
        self.isSelected = false
        self.indexPath = indexPath
    }
    
    init(selected value: Index, indexPath: IndexPath = .zero) {
        self.value = value
        self.isSelected = true
        self.indexPath = indexPath
    }
    
    func select(_ isSelected: Bool) -> Row<Index> {
        if isSelected {
            return Row(selected: self.item, indexPath: self.indexPath)
        }
        
        return Row(self.item, indexPath: self.indexPath)
    }
    
//    func isFirst<X: SectionDataSource, Y: Identifier>(_ section: Section<X, Y>) -> Bool where X.T == Identifier, Index == Identifier {
//        return section.item.items.first == self.item
//    }
    
    internal init() {
        self.value = nil
        self.isSelected = false
        self.indexPath = .zero
    }
}
