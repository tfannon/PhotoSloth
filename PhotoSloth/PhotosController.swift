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
    var photos: [Photo?]!

    var thumbSize: CGSize!
    var imageManager: PHCachingImageManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView!.backgroundColor = UIColor.clearColor()
        collectionView!.contentInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)

        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchResult = PHAsset.fetchAssetsWithOptions(options)
        photos = [Photo?](count: fetchResult.count, repeatedValue:nil)
        print ("\(photos.count) photos detected")
        
        imageManager = PHCachingImageManager()
        
        // Set the PinterestLayout delegate
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        /*
        let scale = UIScreen.mainScreen().scale
        let cellSize = (self.collectionViewLayout as! PinterestLayout).itemSize
        self.thumbSize = CGSize(width: cellSize.width * scale, height: cellSize.height * scale)
        */
    }

   
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResult.count;
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AnnotatedPhotoCell", forIndexPath: indexPath) as! AnnotatedPhotoCell

        let asset: PHAsset = self.fetchResult[indexPath.row] as! PHAsset
        self.imageManager.requestImageForAsset(asset, targetSize: CGSize(width: 100.0, height: 100.0), contentMode: .AspectFill, options: nil) { image,info in
            var creationDateLabel: String = ""
            
            if let creationDate = asset.creationDate {
                creationDateLabel = NSDateFormatter.localizedStringFromDate(creationDate,
                    dateStyle: .ShortStyle,
                    timeStyle: .ShortStyle
                )
            }
            //let ratio: Double = Double(asset.pixelHeight) / (Double)(asset.pixelWidth)
            //print("\(asset.pixelHeight)h  \(asset.pixelWidth)w  \(ratio)  fav:\(asset.favorite), \(asset.localIdentifier)")
            if let location = asset.location {
                //print ("\(location.coordinate.latitude),\(location.coordinate.longitude)")
                Googles.getLocationTags(location.coordinate.latitude, longitude: location.coordinate.longitude) {
                    cell.setTags($0)
                }
            }
            
            /* this retrieves all the metadata
            let options = PHContentEditingInputRequestOptions()
            options.networkAccessAllowed = true //download asset metadata from iCloud if needed
            asset.requestContentEditingInputWithOptions(options) { (contentEditingInput: PHContentEditingInput?, _) -> Void in
                let fullImage = CIImage(contentsOfURL: contentEditingInput!.fullSizeImageURL!)
                print(fullImage!.properties)
            }
            */
            
            let photo = Photo(caption: creationDateLabel, comment: "", image: image!)
            photo.liked = asset.favorite
            self.photos[indexPath.row] = photo
            cell.photo = photo
        }
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

