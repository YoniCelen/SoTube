//
//  MusicCollectionViewController.swift
//  SoTube
//
//  Created by VDAB Cursist on 09/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

import UIKit

class MusicCollectionViewController: MyMusicTabBarViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var data = ["a"]
    let reuseIdentifier = "MusicCell"
    
    
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var musicCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width
        var widthPerItem: CGFloat
        var heightPerItem: CGFloat
        
        if availableWidth <= 375 {
            //For iPhone 7 or smaller
            let itemsPerRow: CGFloat = 2
            widthPerItem = availableWidth / itemsPerRow - collectionViewFlowLayout.sectionInset.left - collectionViewFlowLayout.minimumInteritemSpacing / 2
        } else {
            //For anything bigger than iPhone 7
            //107.5 because we want to fit 3 into an iPhone 7+ screen
            widthPerItem = 107.5
        }
        
        heightPerItem = widthPerItem + 50
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
    
}
