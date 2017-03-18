//
//  CircularCollectionViewLayout.swift
//  Memerizor
//
//  Created by Kirill Kudymov on 2017-03-12.
//  Copyright © 2017 Kirill Kudymov. All rights reserved.
//

import UIKit

class CircularCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    
    var anchorPoint = CGPoint(x: 0.5, y: 0.5)
    var angle: CGFloat = 0 {
        didSet {
            zIndex = Int(angle * 1000000)
            transform = CGAffineTransform(rotationAngle: angle)
        }
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copiedAttributes: CircularCollectionViewLayoutAttributes = super.copy(with: zone) as! CircularCollectionViewLayoutAttributes
        copiedAttributes.anchorPoint = self.anchorPoint
        copiedAttributes.angle = self.angle
        return copiedAttributes
    }
}


class CircularCollectionViewLayout: UICollectionViewLayout {
    
    
    // MARK: - Properties
    
    let itemSize = CGSize(width: 250, height: 250)
    
    var angleAtExtreme: CGFloat {
        return collectionView!.numberOfItems(inSection: 0) > 0 ?
        -CGFloat(collectionView!.numberOfItems(inSection: 0) - 1) * anglePerItem : 0
    }
    
    var angle: CGFloat {
        return angleAtExtreme * collectionView!.contentOffset.x / (collectionViewContentSize.width - collectionView!.bounds.width)
    }
    
    var radius: CGFloat = 500 {
        didSet {
            invalidateLayout()
        }
    }
    
    var anglePerItem: CGFloat {
        return atan(itemSize.width / radius)
    }
    
    var attributesList = [CircularCollectionViewLayoutAttributes]()
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: (CGFloat(collectionView!.numberOfItems(inSection: 0)) * itemSize.width), height:  collectionView!.bounds.height)
    }
    
    override class var layoutAttributesClass: AnyClass {
        return CircularCollectionViewLayoutAttributes.self
    }
    
    override func prepare() {
        super.prepare()
        
        let centerX = collectionView!.contentOffset.x + collectionView!.bounds.width / 2.0
        let anchorPointY = ((itemSize.height / 2.0) + radius) / itemSize.height
        attributesList = (0..<collectionView!.numberOfItems(inSection: 0)).map{(i) -> CircularCollectionViewLayoutAttributes in
            // Create an instance of CircularCollectionViewLayoutAttributes for each index path, and then set its size.
            let attributes = CircularCollectionViewLayoutAttributes(forCellWith: IndexPath(item: i, section: 0))
            attributes.size = self.itemSize
            // Position each item at the center of the screen.
            attributes.center = CGPoint(x: centerX, y: self.collectionView!.bounds.midY)
            // Rotate each item by the amount anglePerItem * i, in radians.
            attributes.angle = self.angle + (self.anglePerItem * CGFloat(i))
            attributes.anchorPoint = CGPoint(x: 0.5, y: anchorPointY)
            return attributes
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesList
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributesList[indexPath.row]
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

}
