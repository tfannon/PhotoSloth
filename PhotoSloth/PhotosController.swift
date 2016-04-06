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

extension ObservableType {
    public func filterNil() -> RxSwift.Observable<E> {
        return self.filter{ $0 != nil }
    }
}

class PhotosController: UICollectionViewController, UIGestureRecognizerDelegate {

    var thumbSize: CGSize!
    var viewModel : AssetCollectionVM!
    private let disposeBag = DisposeBag()

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
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.count;
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoCell
        
        let assetId = viewModel.getId(indexPath.row)
        cell.setup(self, assetId: assetId, imageSize: CGSize(width: 100.0, height: 100.0))
        
        return cell
    }
    
}

extension PhotosController : PinterestLayoutDelegate {
        // 1. Returns the photo height
    func collectionView(collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:NSIndexPath , withWidth width:CGFloat) -> CGFloat {
        let externalId = viewModel.getExternalId(indexPath.row)
        let photoAssetSize = PhotoAssetService.getSize(externalId)
        let boundingRect =  CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        let size = CGSize(width: photoAssetSize.width, height: photoAssetSize.height)
        let rect = AVMakeRectWithAspectRatioInsideRect(size, boundingRect)
        //print ("\(size.height)h  \(size.width)w  \(size.height/size.width) ")
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

