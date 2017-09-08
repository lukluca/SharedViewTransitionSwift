//
//  ImageFileManager.swift
//  SharedViewTransitionSwift
//
//  Created by Tagliabue, L. on 08/09/2017.
//  Copyright © 2017 Tagliabue, L. All rights reserved.
//

import UIKit


class ImageFileManager {
    
    public static let sharedInstance = ImageFileManager()
    
    public var imageUrls = [URL]()
    
    private init() {
        
        for number in 0..<10 {
            let fileName = "tree\(number).jpeg"
            if let dirUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let path = dirUrl.appendingPathComponent(fileName)
                imageUrls.append(path)
            }
        }
    }
    
    public func getImageFrom(index: Int) -> UIImage? {
        
        guard index < imageUrls.count, let image = UIImage(contentsOfFile: imageUrls[index].path) else {
            return nil
        }
        
        return image
    }
}
