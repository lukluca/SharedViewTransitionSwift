//
//  ImageCollectionViewCell.swift
//  SharedViewTransitionSwift
//
//  Created by Tagliabue, L. on 08/09/2017.
//  Copyright © 2017 Tagliabue, L. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    
    static let size = CGSize(width: UIScreen.main.bounds.width/2, height: ((UIScreen.main.bounds.width/2)*CGFloat(ImageFileManager.ratio)))
    
    func setImageFor(index : Int) {
        
        image.image = ImageFileManager.sharedInstance.getImageFrom(index: index)
        
    }
    
}

