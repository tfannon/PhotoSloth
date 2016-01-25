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

class PhotosController: UICollectionViewController, UIGestureRecognizerDelegate {

    var thumbSize: CGSize!
    var imageManager: PHCachingImageManager!
    var assets = [SLAsset]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView!.backgroundColor = UIColor.clearColor()
        collectionView!.contentInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)

        imageManager = PHCachingImageManager()
        assets = slothRealm.getAssets()
            .filter { a in a.externalId != nil }
            .sort { a1, a2 in
                if let d1 = a1.dateTaken,
                   let d2 = a2.dateTaken {
                    return d1.compare(d2) == NSComparisonResult.OrderedDescending
                }
                return true
            }
        
        // Set the PinterestLayout delegate
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        
        
        let gesture = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
        gesture.minimumPressDuration = 0.5
        gesture.delaysTouchesBegan = true
        gesture.delegate = self
        self.collectionView?.addGestureRecognizer(gesture)
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
    
    func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizerState.Ended {
            return
        }
        
        let p = gestureReconizer.locationInView(self.collectionView)
        let indexPath = self.collectionView!.indexPathForItemAtPoint(p)
        
        if let index = indexPath {
            let cell = self.collectionView!.cellForItemAtIndexPath(index) as! AnnotatedPhotoCell
            actionSheetButtonPressed(cell)
            // do stuff with your cell, for example print the indexPath
            print(index.row)
        } else {
            print("Could not find index path")
        }
    }
    
    func actionSheetButtonPressed(cell: AnnotatedPhotoCell) {
        let asset = cell.asset
        
        let alert = UIAlertController(title: "\(asset.locationText)", message: "\(asset.potentialPOI)", preferredStyle: .Alert) // 1
        let firstAction = UIAlertAction(title: "one", style: .Default) { (alert: UIAlertAction!) -> Void in
            NSLog("You pressed button one")
        } // 2
        
        let secondAction = UIAlertAction(title: "two", style: .Default) { (alert: UIAlertAction!) -> Void in
            NSLog("You pressed button two")
        } // 3
        
        alert.addAction(firstAction) // 4
        alert.addAction(secondAction) // 5
        presentViewController(alert, animated: true, completion:nil) // 6
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

