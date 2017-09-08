//
//  ParentViewController.swift
//  SharedViewTransitionSwift
//
//  Created by Pasini, Nicolò on 06/09/2017.
//  Copyright © 2017 Tagliabue, L. All rights reserved.
//

import UIKit

class ParentViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: ImageCollectionViewCell.self))
        
    }
}

extension ParentViewController: UICollectionViewDelegate {
    
}

extension ParentViewController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ImageFileManager.sharedInstance.imageUrls.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell: UICollectionViewCell
        
        if let cellVar = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ImageCollectionViewCell.self), for: indexPath) as? ImageCollectionViewCell {
            cell = cellVar
        } else {
            cell = UICollectionViewCell()
        }
        
        return cell        
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
}
