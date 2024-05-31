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

@testable import ReactiveCollectionsKit
import XCTest

open class UnitTestCase: XCTestCase {

    private static let frame = CGRect(x: 0, y: 0, width: 320, height: 600)

    @MainActor let collectionView = FakeCollectionView(
        frame: frame,
        collectionViewLayout: FakeCollectionLayout()
    )

    @MainActor
    override open func setUp() {
        super.setUp()
        self.collectionView.layoutSubviews()
        self.collectionView.reloadData()
    }
}
