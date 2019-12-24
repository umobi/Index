//
//  RowBindable.swift
//  mercadoon
//
//  Created by brennobemoura on 03/09/19.
//  Copyright © 2019 brennobemoura. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import UMUtils

public protocol IndexBindable: ViewModelBindable where ViewModel: IndexModel {
    /// Reload view when viewModel.indexRelay is subscribed
    func reloadViews(_ index: ViewModel.Index)
    func configure(_ index: ViewModel.Index)
    var disposeBag: DisposeBag { get }
}

public protocol IndexModel: ViewModel {
    associatedtype Index
    var indexRelay: BehaviorRelay<Index> { get }
}

public extension IndexBindable {
    func configure(_ index: ViewModel.Index) {
        self.viewModel?.indexRelay.accept(index)
    }
    
    func reloadViews(_ index: ViewModel.Index) {}
}

public extension IndexBindable {
    func bindViewModel(viewModel: ViewModel) {
        viewModel.indexRelay.asDriver().drive(onNext: { [weak self] index in
            self?.reloadViews(index)
        }).disposed(by: disposeBag)
    }
}

/// This protocol already implements bindViewModel. If you override it in any class, you should implement the bindViewModel with viewModel.rowRelay subscriber.
public protocol RowBindable: IndexBindable where ViewModel: RowModel<Item> {
    typealias Index = Row<Item>
    associatedtype Item
    
//    func reloadViews(_ row: Row<Item>)
//    func configure(_ row: Row<Item>)
}

public extension RowBindable {
    func bindViewModel(viewModel: RowModel<Item>) {
        viewModel.indexRelay.asDriver().drive(onNext: { [weak self] index in
            self?.reloadViews(index)
        }).disposed(by: disposeBag)
    }
}

open class RowModel<T>: ViewModel, IndexModel {
    public typealias Index = Row<T>
    
    public let indexRelay: BehaviorRelay<Row<T>> = .init(value: .empty)
    
    public init() {}
}

/// This protocol already implements bindViewModel. If you override it in any class, you should implement the bindViewModel with viewModel.rowRelay subscriber.
public protocol SectionRowBindable: IndexBindable where ViewModel: SectionRowModel<Section, Item> {
    typealias Index = SectionRow<Section, Item>
    associatedtype Section
    associatedtype Item
    
//    func reloadViews(_ sectionRow: SectionRow<Section, Item>)
//    func configure(_ sectionRow: SectionRow<Section, Item>)
}

public extension SectionRowBindable {
    func bindViewModel(viewModel: SectionRowModel<Section, Item>) {
        viewModel.indexRelay.asDriver().drive(onNext: { [weak self] index in
            self?.reloadViews(index)
        }).disposed(by: disposeBag)
    }
}

open class SectionRowModel<X, Y>: ViewModel, IndexModel {
    public typealias Index = SectionRow<X, Y>
    
    public let indexRelay: BehaviorRelay<SectionRow<X, Y>> = .init(value: .empty)
    
    public init() {}
}


public enum NavigateObject<E: Identifier> {
    case element(E)
    case identifier(Int)
    case empty

    public var value: Int? {
        switch self {
        case .element(let element):
            return element.identifier
        case .identifier(let identifier):
            return identifier
        case .empty:
            return nil
        }
    }

    public var item: Int {
        return self.value!
    }

    public var object: E? {
        switch self {
        case .element(let element):
            return element
        default:
            return nil
        }
    }

    public var isEmpty: Bool {
        if case .empty = self {
            return true
        }

        return false
    }
}

/// This protocol already implements bindViewModel. If you override it in any class, you should implement the bindViewModel with viewModel.rowRelay subscriber.
public protocol NavigationBindable: IndexBindable where ViewModel: NavigationModel<Item> {
    typealias Index = NavigateObject<Item>
    associatedtype Item: Identifier

//    func reloadViews(_ row: Row<Item>)
//    func configure(_ row: Row<Item>)

    func reloadIndex()
}

public extension NavigationBindable {
    func configure(_ index: ViewModel.Index) {
        self.viewModel?.indexRelay.accept(index)
        self.reloadIndex()
    }

    func reloadIndex() {
        self.viewModel?.needsReload.accept(())
    }

    func reloadViews(_ index: ViewModel.Index) {}
}

public extension NavigationBindable {
    func bindViewModel(viewModel: NavigationModel<Item>) {
        viewModel.indexRelay.asDriver().drive(onNext: { [weak self] index in
            self?.reloadViews(index)
        }).disposed(by: disposeBag)
    }
}

open class NavigationModel<T: Identifier>: ViewModel, IndexModel {
    public typealias Index = NavigateObject<T>

    public let indexRelay: BehaviorRelay<Index> = .init(value: .empty)
    fileprivate var needsReload: PublishRelay<Void> = .init()

    public var reloadIndex: Observable<Index> = .never()

    public init() {
        self.reloadIndex = self.needsReload
            .flatMapLatest { [weak self] _ -> Observable<Index> in
                return self?.indexRelay.filter { !$0.isEmpty }
                    .first()
                    .asObservable()
                    .flatMapLatest { index -> Observable<Index> in
                        guard let index = index else {
                            return .never()
                        }

                        return .just(index)
                    } ?? .never()
            }
    }
}
