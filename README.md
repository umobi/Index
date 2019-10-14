# Index

[![CI Status](https://img.shields.io/travis/brennobemoura/Index.svg?style=flat)](https://travis-ci.org/brennobemoura/Index)
[![Version](https://img.shields.io/cocoapods/v/Index.svg?style=flat)](https://cocoapods.org/pods/Index)
[![License](https://img.shields.io/cocoapods/l/Index.svg?style=flat)](https://cocoapods.org/pods/Index)
[![Platform](https://img.shields.io/cocoapods/p/Index.svg?style=flat)](https://cocoapods.org/pods/Index)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

Index is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Index'
```

### Definitions

----

#### 1. IndexProtocol

IndexProtocol is the main protocol used in derivated classes. It has methods that helps creating array for indexed elements.

- .value: Index?
- .indexPath: IndexPath
- .isSelected: Bool { get }
- .select(_ isSelected: Bool)
- .init()

#### 2. Row
The row class has the Index generic type to conforms with IndexProtocol. The main ideia in all methods specified in the parent protocol is to create a new instance from itself. To update the list of rows, for example, you need to reset the array of rows.

Here it goes some example:

```swift
class TestViewController: UIViewController {
    var cars: [Row<Car>] = []
    
    func didDownload(_ array: [Car]) {
        self.cars = array.enumerated().map {
            Row($0.element, indexPath: .init(row: $0.offset, section: 0))
        }
    }
}
```

The Row class helps collection cells or table cells to reload it state and now values as indexPath or if it is selected or not.

```swift
class TestViewCell: UITableViewCell {
    
    func reloadState(_ index: Row<Car>) {
        guard !index.isEmpty else {
            return
        }
        
        self.titleLabel.text = index.item.name
        self.priceLabel.text = index.item.price.asPrice
        
        if index.isSelected {
            self.selectedLayout()
        } else {
            self.notSelectedLayout()
        }
    }
}
```

#### 3. Section

Section has two generic types X and Y as Section class and Row.Index class. This is only a template to prepare for SectionRow class. 

The methods implement for Section are:

- .init(_ section: X, items: [Y], section index: Int = 0)
- .asSectionRows: [SectionRow]

#### 4. SectionRow

SectionRow is a wrapper for Row because it allows us to access section attributes without needing to call extra methods.

It has:

- .value: Section?
- .row: Row
- .init(_ section: Section, row: Row)
- .indexPath: IndexPath
- .isSelected: Bool
- .isFirst: Bool
- .isLast: Bool
- .select(_ isSelected: Bool)

#### 5. SectionDataSource

This helps to turn classes with .items: [T] { get } into Section class. If you have a array of [SectionDataSource] you can call .asSectionRow or .asSection getters to have a list of data ready to be used in our tableview.

#### 6. Identifier

This class implement the identifier getter and conforms with Hashable allowing you to have a unique array of these elements.

### Extra Subspecs extensions

#### 1. UIContainer

From [UIContainer](https://github.com/umobi/UIContainer "UIContainer"), this extension helps to transform an array of Index into a array of UIContainer views.

```swift
    class TestViewController: UIViewController {
        weak var carsSV: UIStackView!
        
        func reloadCars(_ rows: [Row<Car>]) {
            self.carsSV.arrangedSubviews.forEach {
                $0.removeFromSubview()
            }
            
            CarView.Container.asCells(rows, in: self)
                .forEach { container, row in
                    container.view.reloadState(row)
                    carsSV.addArrangedSubview(container)
                }
        }
    }
```

#### 2. IndexBindable

From [UMUtils](https://github.com/ramonvic/umutils-swift "UMUtils") that implements ViewModel, the IndexBindable allows to create cells more reactive using RxSwift and RxCocoa libraries.

This cames with to classes: 

- RowBindable
- SectionRowBindable

Here it goes some example:

```swift
class CarView: View, RowModel, ContainerCellDelegate {
    typealias Item = Car
    
    override func prepare() {
        super.prepare()
        
        self.titleLabel.font = UIFont(name: "RobotoFont-regular", size: 16.0)
        self.priceLabel.font = UIFont(name: "RobotoFont-bold", size: 18.0)
        
        self.viewModel = RowModel()
    }
    
    override func reloadViews(_ index: Row<Car>) {
        guard !index.isEmpty else {
            return
        }
        
        self.titleLabel.text = index.item.name
        self.priceLabel.text = index.item.price.asPrice
        
        if index.isSelected {
            self.selectedLayout()
        } else {
            self.notSelectedLayout()
        }
    }
}

extension TestView {
    class Cell: ContainerTableViewCell<TestView> {
        override func containerDidLoad() {
            super.containerDidLoad()
            self.selectionStyle = .none
        }
    }
}
```

On our view controller we need:

```swift
    extension TestViewController: UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.cars.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TestViewCellIdentifier", for: indexPath) as! TestView.Cell
            
            cell.prepareContainer(inside: self)
            cell.view.configure(row)
            
            return cell
        }
    }
```

## Author

brennobemoura, brennobemoura@outlook.com.br

## License

Index is available under the MIT license. See the LICENSE file for more info.
