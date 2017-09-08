//
//  ImageFileManager.swift
//  SharedViewTransitionSwift
//
//  Created by Tagliabue, L. on 08/09/2017.
//  Copyright © 2017 Tagliabue, L. All rights reserved.
//

import UIKit


class ImageFileManager {
    
    public static let ratio = 1/1.335
    
    public static let sharedInstance = ImageFileManager()
    
    public var imageUrls = [String]()
    
    private init() {
    
        self.imageUrls = (0..<10).map {
            Bundle.main.path(forResource: "tree\($0)", ofType: "jpeg")
            
            }.filter({$0 != nil}).map({$0!})
    }
    
    public func getImageFrom(index: Int) -> UIImage? {
        
        guard index < imageUrls.count, let image = UIImage(contentsOfFile: imageUrls[index]) else {
            return nil
        }
        
        return image
    }
}
