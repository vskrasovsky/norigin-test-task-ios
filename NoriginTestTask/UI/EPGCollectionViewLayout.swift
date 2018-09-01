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
}

class EPGCollectionViewLayout: UICollectionViewLayout {
    weak var delegate: EPGCollectionViewLayoutDelegate!
    
    fileprivate var hourHeight: CGFloat = 40
    fileprivate var sectionHeight: CGFloat = 65
    fileprivate var channelCellWidth: CGFloat = 75

    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    
    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else { return .zero }
        let contentWidth = delegate.collectionViewContentWidth(collectionView) + channelCellWidth
        let contentHeight = CGFloat(collectionView.numberOfSections) * sectionHeight
        return CGSize(width: contentWidth, height: contentHeight)
    }

    override func prepare() {
        guard let collectionView = collectionView else { return }
        cache = []
        
        for section in 0 ..< collectionView.numberOfSections {
            for item in 0 ..< collectionView.numberOfItems(inSection: section) {
                if section == 0 {
                    let indexPath = IndexPath(item: item, section: section)
                    let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                    
                    let xOffset: CGFloat
                    let width: CGFloat
                    
                    xOffset = channelCellWidth + delegate.collectionView(collectionView, xOffsetForItemAt: indexPath)
                    width = delegate.collectionView(collectionView, widthForItemAt: indexPath)
                    attributes.zIndex = 2

                    let yOffset = collectionView.contentOffset.y
                    let frame = CGRect(x: xOffset, y: yOffset, width: width, height: hourHeight)
                    attributes.frame = frame
                    cache.append(attributes)
                } else {
                    let indexPath = IndexPath(item: item, section: section)
                    let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

                    let xOffset: CGFloat
                    let width: CGFloat

                    //channel cell
                    if item == 0 {
                        xOffset = collectionView.contentOffset.x
                        width = channelCellWidth
                        attributes.zIndex = 1
                    } else {
                        xOffset = channelCellWidth + delegate.collectionView(collectionView, xOffsetForItemAt: indexPath)
                        width = delegate.collectionView(collectionView, widthForItemAt: indexPath)
                    }
                    
                    let yOffset = hourHeight + sectionHeight * CGFloat(section - 1)
                    let frame = CGRect(x: xOffset, y: yOffset, width: width, height: sectionHeight)
                    attributes.frame = frame
                    cache.append(attributes)
                }
            }
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        // Loop through the cache and look for items in the rect
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}

extension CGFloat {
    var whole: CGFloat {
        return CGFloat(Int(self))
    }
}
