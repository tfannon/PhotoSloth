//
//  ViewController.swift
//  PhotoSloth
//
//  Created by Tommy Fannon on 1/23/16.
//  Copyright © 2016 StingrayDev. All rights reserved.
//

import UIKit
import Photos
import PhotosUI

class PhotosController: UICollectionViewController {
    var fetchResult: PHFetchResult!

    var thumbSize: CGSize!
    var imageManager: PHCachingImageManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView!.backgroundColor = UIColor.clearColor()
        collectionView!.contentInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)

        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchResult = PHAsset.fetchAssetsWithOptions(options)
        print ("\(fetchResult.count) photos detected")
        
        imageManager = PHCachingImageManager()
        
        // Set the PinterestLayout delegate
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

   
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResult.count;
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AnnotatedPhotoCell", forIndexPath: indexPath) as! AnnotatedPhotoCell

        let photoAsset: PHAsset = self.fetchResult[indexPath.row] as! PHAsset
        var asset = slothRealm.getAssetByExternalId(photoAsset.localIdentifier)
        if asset == nil {
            asset = SLAsset()
            asset!.longitude = photoAsset.location?.coordinate.longitude ?? 0
            asset!.latitude = photoAsset.location?.coordinate.longitude ?? 0
            asset!.dateTaken = photoAsset.creationDate
            slothRealm.addAsset(asset!)
        }
        imageManager.requestImageForAsset(photoAsset, targetSize: CGSize(width: 100.0, height: 100.0), contentMode: .AspectFill, options: nil) { image, info in
            cell.setImage(image)
        }
        if let coordinates = photoAsset.location?.coordinate {
            Googles.getLocationTags(coordinates.latitude, longitude: coordinates.longitude) { tags in
                
            }
        }
        cell.setup(asset!)
        return cell
    }
}

extension PhotosController : PinterestLayoutDelegate {
        // 1. Returns the photo height
    func collectionView(collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:NSIndexPath , withWidth width:CGFloat) -> CGFloat {
        let asset: PHAsset = self.fetchResult[indexPath.row] as! PHAsset
        let boundingRect =  CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        let size = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
        let rect = AVMakeRectWithAspectRatioInsideRect(size, boundingRect)
        //print ("\(size.height)h  \(size.width)w  \(size.height/size.width) ")
        return rect.size.height
        //return CGFloat(100)
    }
    
    // 2. Returns the annotation size based on the text
    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        return CGFloat(40)
        
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

