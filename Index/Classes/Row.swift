//
//  Row.swift
//  mercadoon
//
//  Created by brennobemoura on 21/08/19.
//  Copyright © 2019 brennobemoura. All rights reserved.
//

import Foundation

public extension IndexPath {
    static var zero: IndexPath {
        return .init(row: 0, section: 0)
    }
}

public enum RowEditable<T> {
    case remove(T)
    case insert(T)
}

public protocol IndexProtocol: Equatable {
    associatedtype Index
    var value: Index? { get }
    var indexPath: IndexPath { get }
    var isSelected: Bool { get }
    
    func select(_ isSelected: Bool) -> Self
    
    init()
}

public extension Equatable where Self: IndexProtocol {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.indexPath == rhs.indexPath
    }
}

public extension IndexProtocol {
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

public final class Row<Index>: IndexProtocol {
    public let value: Index?
    public let isSelected: Bool
    
    public let indexPath: IndexPath
    
    public init(_ value: Index, indexPath: IndexPath = .zero) {
        self.value = value
        self.isSelected = false
        self.indexPath = indexPath
    }
    
    public init(selected value: Index, indexPath: IndexPath = .zero) {
        self.value = value
        self.isSelected = true
        self.indexPath = indexPath
    }
    
    public func select(_ isSelected: Bool) -> Row<Index> {
        if isSelected {
            return Row(selected: self.item, indexPath: self.indexPath)
        }
        
        return Row(self.item, indexPath: self.indexPath)
    }
    
    public init() {
        self.value = nil
        self.isSelected = false
        self.indexPath = .zero
    }
}
