//
//  ChildViewController.swift
//  SharedViewTransitionSwift
//
//  Created by Tagliabue, L. on 08/09/2017.
//  Copyright © 2017 Tagliabue, L. All rights reserved.
//

import UIKit

class ChildViewController: UIViewController {

    @IBOutlet weak var imageContainerView: UIView!
    
    var index:Int?

    override func viewDidLoad() {
        navigationItem.title = "Detail Image!"
        
        edgesForExtendedLayout = []
        
        if let ind = index {
            loadImageAt(index: ind)
        }
    }
    
    private func loadImageAt(index: Int) {
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.width*CGFloat(ImageFileManager.ratio))))
        
        imageView.image = ImageFileManager.sharedInstance.getImageFrom(index: index)
        
        imageContainerView.addSubview(imageView)
    }

}
