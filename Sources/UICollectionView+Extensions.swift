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
import UIKit

extension UICollectionView {
    /// Deselects all items that are selected.
    /// - Parameter animated: Whether or not to animate the deselection.
    public func deselectAllItems(animated: Bool = true) {
        self.indexPathsForSelectedItems?.forEach {
            self.deselectItem(at: $0, animated: animated)
        }
    }
}
