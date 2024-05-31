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

import Foundation
@testable import ReactiveCollectionsKit
import UIKit
import XCTest

struct FakeCollectionCellViewModel: CellViewModel {
    let text: String
    let didSelectExpectation: XCTestExpectation?
    let didConfigureExpectation: XCTestExpectation?

    // MARK: CellViewModel

    nonisolated var id: UniqueIdentifier { self.text }

    func configure(cell: FakeCollectionCell) {
        self.didConfigureExpectation?.fulfill()
    }

    func didSelect(with coordinator: CellEventCoordinator?) {
        self.didSelectExpectation?.fulfill()
    }
}

extension XCTestCase {
    @MainActor
    func makeCollectionViewModel(numSections: Int = 3,
                                 numCells: Int = 5,
                                 includeExpectations: Bool = false) -> CollectionViewModel {
        let sections = (0..<numSections).map { _ in
            self.makeCollectionSectionViewModel(numCells: numCells, includeExpectations: includeExpectations)
        }
        return CollectionViewModel(id: "test_model", sections: sections)
    }

    @MainActor
    func makeCollectionSectionViewModel(name: String = .random,
                                        numCells: Int = 5,
                                        includeExpectations: Bool = false) -> SectionViewModel {
        let cellModels = (0..<numCells).map { _ in
            self.makeCollectionCellViewModel(includeExpectations: includeExpectations)
        }
        return SectionViewModel(id: "section_\(name)", cells: cellModels)
    }

    @MainActor
    func makeCollectionCellViewModel(text: String = .random,
                                     includeExpectations: Bool = false) -> FakeCollectionCellViewModel {
        FakeCollectionCellViewModel(
            text: text,
            didSelectExpectation: includeExpectations ? self.expectation(description: "didSelect_\(text)") : nil,
            didConfigureExpectation: includeExpectations ? self.expectation(description: "apply_\(text)") : nil
        )
    }
}
