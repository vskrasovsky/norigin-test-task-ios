//
//  EPGCollectionViewLayout.swift
//  NoriginTestTask
//
//  Created by user on 8/30/18.
//  Copyright © 2018 ScienceSoft. All rights reserved.
//

import UIKit

protocol EPGCollectionViewLayoutDelegate: class {
    func collectionViewContentWidth(_ collectionView: UICollectionView) -> CGFloat
    func collectionView(_ collectionView: UICollectionView, xOffsetForItemAt indexPath: IndexPath) -> CGFloat
    func collectionView(_ collectionView: UICollectionView, widthForItemAt indexPath: IndexPath) -> CGFloat
    func collectionViewXOffsetForTimePosition(_ collectionView: UICollectionView) -> CGFloat
    func collectionViewTimePositionVisible(_ collectionView: UICollectionView) -> Bool
}

class EPGCollectionViewLayout: UICollectionViewFlowLayout {
    static let timePositionViewKind = "timePositionViewKind"

    weak var delegate: EPGCollectionViewLayoutDelegate!
    
    fileprivate var hourHeight: CGFloat = 40
    fileprivate var sectionHeight: CGFloat = 65
    fileprivate var timePositionViewYOffset: CGFloat = 3
    fileprivate var timePositionViewWidth: CGFloat = 4

    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    
    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else { return .zero }
        let contentWidth = delegate.collectionViewContentWidth(collectionView)
        let contentHeight = CGFloat(collectionView.numberOfSections - 1) * sectionHeight + hourHeight
        return CGSize(width: contentWidth, height: contentHeight)
    }

    override func prepare() {
        guard let collectionView = collectionView else { return }
        cache = []
        
        //cells attributes
        for section in 0 ..< collectionView.numberOfSections {
            for item in 0 ..< collectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                if let attributes = layoutAttributesForItem(at: indexPath) {
                    cache.append(attributes)
                }
            }
        }
        
        if let timePositionViewAttributes = self.layoutAttributesForDecorationView(
            ofKind: EPGCollectionViewLayout.timePositionViewKind, at: IndexPath(item: 0, section: 0)) {
                cache.append(timePositionViewAttributes)
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let visibleLayoutAttributes = cache.filter { $0.frame.intersects(rect) }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else { return nil }
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        let xOffset = delegate.collectionView(collectionView, xOffsetForItemAt: indexPath)
        let width = delegate.collectionView(collectionView, widthForItemAt: indexPath)
        let frame: CGRect
        if indexPath.section == 0 {
            // hour cell
            attributes.zIndex = 2
            let yOffset = collectionView.contentOffset.y
            frame = CGRect(x: xOffset, y: yOffset, width: width, height: hourHeight)
        } else {
            if indexPath.item == 0 {
                //channel cell
                attributes.zIndex = 1
            }
            let yOffset = hourHeight + sectionHeight * CGFloat(indexPath.section - 1)
            frame = CGRect(x: xOffset, y: yOffset, width: width, height: sectionHeight)
        }
        attributes.frame = frame
        return attributes
    }
    
    // attributes for orange time line
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
            guard let collectionView = collectionView, elementKind == EPGCollectionViewLayout.timePositionViewKind else { return nil }
            let attributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: EPGCollectionViewLayout.timePositionViewKind, with: indexPath)
            attributes.zIndex = 3
            let xOffset = delegate.collectionViewXOffsetForTimePosition(collectionView) - timePositionViewWidth / 2
            let height: CGFloat
            // hide part of timePositionView while overlapping with channel cells
            if delegate.collectionViewTimePositionVisible(collectionView) {
                height = (hourHeight - timePositionViewYOffset) + CGFloat(collectionView.numberOfSections - 1) * sectionHeight - collectionView.contentOffset.y
            } else {
                height = hourHeight - timePositionViewYOffset
            }
            attributes.frame = CGRect(x: xOffset, y: collectionView.contentOffset.y + timePositionViewYOffset, width: timePositionViewWidth, height: height)
            return attributes
    }

}
