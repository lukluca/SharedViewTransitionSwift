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
    
    weak var delegate: SharedViewTransitionProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Shared View Transition!!!!"
    
        collectionView.delegate = self
        collectionView.dataSource = self
    
        let cellNib = UINib(nibName: "ImageCollectionViewCell", bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: String(describing: ImageCollectionViewCell.self))
        
    }
}

extension ParentViewController: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let child = ChildViewController(nibName: String(describing: ChildViewController.self), bundle: nil)
        
        child.index = indexPath.row
        
        navigationController?.pushViewController(child, animated: true)
    }
        
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
        
        if let imageCell = cell as? ImageCollectionViewCell {
            imageCell.setImageFor(index: indexPath.row)
        }
        
        return cell        
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension ParentViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return ImageCollectionViewCell.size
    }
    
}
