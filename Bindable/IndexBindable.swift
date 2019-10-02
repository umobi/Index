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

protocol IndexBindable: ViewModelBindable where Model: IndexModel {
    /// Reload view when viewModel.indexRelay is subscribed
    func reloadViews(_ index: Model.Index)
    func configure(_ index: Model.Index)
    var disposeBag: DisposeBag { get set }
}

protocol IndexModel: ViewModel {
    associatedtype Index
    var indexRelay: BehaviorRelay<Index> { get }
}

extension IndexBindable {
    func configure(_ index: Model.Index) {
        self.viewModel?.indexRelay.accept(index)
    }
    
    func reloadViews(_ index: Model.Index) {}
}

extension IndexBindable {
    func bindViewModel(viewModel: Model) {
        viewModel.indexRelay.asDriver().drive(onNext: { [weak self] index in
            self?.reloadViews(index)
        }).disposed(by: disposeBag)
    }
}

/// This protocol already implements bindViewModel. If you override it in any class, you should implement the bindViewModel with viewModel.rowRelay subscriber.
protocol RowBindable: IndexBindable where Model: RowModel<Item> {
    typealias Index = Row<Item>
    associatedtype Item
    
//    func reloadViews(_ row: Row<Item>)
//    func configure(_ row: Row<Item>)
}

extension RowBindable {
    func bindViewModel(viewModel: RowModel<Item>) {
        viewModel.indexRelay.asDriver().drive(onNext: { [weak self] index in
            self?.reloadViews(index)
        }).disposed(by: disposeBag)
    }
}

class RowModel<T>: ViewModel, IndexModel {
    typealias Index = Row<T>
    
    let indexRelay: BehaviorRelay<Row<T>> = .init(value: .empty)
}

/// This protocol already implements bindViewModel. If you override it in any class, you should implement the bindViewModel with viewModel.rowRelay subscriber.
protocol SectionRowBindable: IndexBindable where Model: SectionRowModel<Section, Item> {
    typealias Index = SectionRow<Section, Item>
    associatedtype Section
    associatedtype Item
    
//    func reloadViews(_ sectionRow: SectionRow<Section, Item>)
//    func configure(_ sectionRow: SectionRow<Section, Item>)
}

extension SectionRowBindable {
    func bindViewModel(viewModel: SectionRowModel<Section, Item>) {
        viewModel.indexRelay.asDriver().drive(onNext: { [weak self] index in
            self?.reloadViews(index)
        }).disposed(by: disposeBag)
    }
}

class SectionRowModel<X, Y>: ViewModel, IndexModel {
    typealias Index = SectionRow<X, Y>
    
    let indexRelay: BehaviorRelay<SectionRow<X, Y>> = .init(value: .empty)
}
