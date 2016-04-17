//
//  ViewController.swift
//  PhotoSloth
//
//  Created by Tommy Fannon on 1/23/16.
//  Copyright © 2016 StingrayDev. All rights reserved.
//

import UIKit
import PhotosUI
import RxSwift

class PhotosController: UICollectionViewController, UIGestureRecognizerDelegate {
    
    // MARK: - Properties
    let cellIdentifier = "PhotoCell"
    var viewModel : AssetCollectionVM!
    private let disposeBag = DisposeBag()
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = AssetCollectionVM()
        
        collectionView!.backgroundColor = UIColor.clearColor()
        collectionView!.contentInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        
        // Set the PinterestLayout delegate
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
    }
    
    // MARK: - CollectionView
    
    //
    // numberOfItemsInSection
    //
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.count;
    }
    
    //
    // cellForItemAtIndexPath
    //
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! PhotoCell
        
        return cell
    }
    
    //
    // willDisplayCell
    //
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        if let photoCell = cell as? PhotoCell {
            // get the asset id
            let assetId = viewModel.getId(indexPath.row)
            // setup the cell
            photoCell.setup(self, assetId: assetId, imageSize: CGSize(width: 100.0, height: 100.0))
        }
    }
    
    //
    // didEndDisplayingCell
    //
    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if let photoCell = cell as? PhotoCell {
            // clean the cell
            photoCell.recycle()
        }
    }
}

extension PhotosController : PinterestLayoutDelegate {
    // 1. Returns the photo height
    func collectionView(collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:NSIndexPath , withWidth width:CGFloat) -> CGFloat {
        let photoAssetSize = viewModel.getPhotoAssetSize(indexPath.row)
        let boundingRect =  CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        let size = CGSize(width: photoAssetSize.width, height: photoAssetSize.height)
        let rect = AVMakeRectWithAspectRatioInsideRect(size, boundingRect)
        print ("\(size.height)h  \(size.width)w  \(size.height/size.width) ")
        return rect.size.height
        //return CGFloat(100)
    }
    
    // 2. Returns the annotation size based on the text
    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        return CGFloat(50)
        
        //        let annotationPadding = CGFloat(4)
        //        let annotationHeaderHeight = CGFloat(17)
        //
        //        let photo = photos[indexPath.item]!
        //        let font = UIFont(name: "AvenirNext-Regular", size: 10)!
        //        let commentHeight = photo.heightForComment(font, width: width)
        //        let height = annotationPadding + annotationHeaderHeight + commentHeight + annotationPadding
        //        return height
    }
}

