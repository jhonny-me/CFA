//
//  SecondViewController.swift
//  CFA
//
//  Created by Johnny Gu on 9/16/16.
//  Copyright © 2016 Johnny Gu. All rights reserved.
//

import UIKit

class MapsViewController: UIViewController {
    
    @IBOutlet weak var collectView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let layout = collectView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pageChanged(_ sender: UIPageControl) {
        let index = IndexPath(row: sender.currentPage, section: 0)
        collectView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
        title = "number \(sender.currentPage + 1) floor"
    }
}

extension MapsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MapImageCell.Identifier, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        let pageIndex = pageControl.currentPage
        if index == pageIndex { return }
        pageControl.currentPage = index
        
//        title = "number \(index + 1) floor"
    }
}



class MapImageCell: UICollectionViewCell {
    
    static let Identifier = "MapImageCellIdentifier"
    
    @IBOutlet weak var imageView: UIImageView!
    
}
