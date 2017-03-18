//
//  MemeCollectionViewCell.swift
//  Memerizor
//
//  Created by Kirill Kudymov on 2017-03-07.
//  Copyright © 2017 Kirill Kudymov. All rights reserved.
//

import UIKit

class MemeCircularCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var memeCellImageView: UIImageView?
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        let circularLayoutAttributes = layoutAttributes as! CircularCollectionViewLayoutAttributes
        self.layer.anchorPoint = circularLayoutAttributes.anchorPoint
        self.center.y += (circularLayoutAttributes.anchorPoint.y - 0.5) * self.bounds.height
    }
    
    
}
