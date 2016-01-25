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

    var thumbSize: CGSize!
    var imageManager: PHCachingImageManager!
    var assets = [SLAsset]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView!.backgroundColor = UIColor.clearColor()
        collectionView!.contentInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)

        imageManager = PHCachingImageManager()
        assets = slothRealm.getAssets().filter { a in
            a.externalId != nil }.sort { a1, a2 in
            if let d1 = a1.dateTaken {
                if let d2 = a2.dateTaken {
                    return d1.compare(d2) == NSComparisonResult.OrderedAscending
                }
            }
            return true
        }
        
        // Set the PinterestLayout delegate
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

   
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count;
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AnnotatedPhotoCell", forIndexPath: indexPath) as! AnnotatedPhotoCell
        
        let asset = assets[indexPath.row]
        let photoAsset = getPhotoAsset(asset)
        
        imageManager.requestImageForAsset(photoAsset, targetSize: CGSize(width: 100.0, height: 100.0), contentMode: .AspectFill, options: nil) { image, info in
            cell.setImage(image)
        }
        cell.setup(asset)
        return cell
    }
    
    func getPhotoAsset(asset : SLAsset) -> PHAsset {
        let fetchResult = PHAsset.fetchAssetsWithLocalIdentifiers([asset.externalId!], options: nil)
        let photoAsset = fetchResult[0] as! PHAsset
        return photoAsset
    }
}

extension PhotosController : PinterestLayoutDelegate {
        // 1. Returns the photo height
    func collectionView(collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:NSIndexPath , withWidth width:CGFloat) -> CGFloat {
        let asset = assets[indexPath.row]
        let photoAsset = getPhotoAsset(asset)
        let boundingRect =  CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        let size = CGSize(width: photoAsset.pixelWidth, height: photoAsset.pixelHeight)
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

