//
//  Created by Jesse Squires
//  https://www.jessesquires.com
//
//  Documentation
//  https://jessesquires.github.io/ReactiveCollectionsKit
//
//  GitHub
//  https://github.com/jessesquires/ReactiveCollectionsKit
//
//  Copyright © 2019-present Jesse Squires
//

import UIKit

/// Defines a view model that describes and configures a cell in the collection view.
public protocol CellViewModel: DiffableViewModel, ViewRegistrationProvider {
    associatedtype CellType: UICollectionViewCell

    var shouldHighlight: Bool { get }

    func configure(cell: CellType)

    func didSelect(with controller: UIViewController)
}

extension CellViewModel {
    public var cellClass: AnyClass { CellType.self }

    public var shouldHighlight: Bool { true }

    public var registration: ViewRegistration {
        ViewRegistration(
            viewClass: self.cellClass,
            reuseIdentifier: self.reuseIdentifier,
            nibName: self.nibName,
            nibBundle: self.nibBundle,
            type: .cell
        )
    }

    public func dequeueAndConfigureCellFor(collectionView: UICollectionView, at indexPath: IndexPath) -> CellType {
        let cell = self.registration.dequeueViewFor(collectionView: collectionView, at: indexPath) as! CellType
        self.configure(cell: cell)
        return cell
    }

    public func didSelect(with controller: UIViewController) { }
}

/// A type-erased cell view model.
public struct AnyCellViewModel: CellViewModel {
    // MARK: DiffableViewModel

    public var id: UniqueIdentifier { self._id }

    // MARK: ViewRegistrationProvider

    public var registration: ViewRegistration { self._registration }

    // MARK: CellViewModel

    public typealias CellType = UICollectionViewCell

    public var shouldHighlight: Bool { self._shouldHighlight }

    public func configure(cell: UICollectionViewCell) {
        self._configure(cell)
    }

    public func didSelect(with controller: UIViewController) {
        self._didSelect(controller)
    }

    // MARK: Private

    private let _id: UniqueIdentifier
    private let _registration: ViewRegistration
    private let _shouldHighlight: Bool
    private let _configure: (CellType) -> Void
    private let _didSelect: (UIViewController) -> Void

    // MARK: Init

    public init<T: CellViewModel>(_ viewModel: T) {
        self._id = viewModel.id
        self._registration = viewModel.registration
        self._shouldHighlight = viewModel.shouldHighlight
        self._configure = { cell in
            precondition(cell is T.CellType, "Cell must be of type \(T.CellType.self). Found \(cell.self)")
            viewModel.configure(cell: cell as! T.CellType)
        }
        self._didSelect = { controller in
            viewModel.didSelect(with: controller)
        }
    }
}
