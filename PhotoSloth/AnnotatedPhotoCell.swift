//
//  AnnotatedPhotoCell.swift
//  RWDevCon
//
//  Created by Mic Pringle on 26/02/2015.
//  Copyright (c) 2015 Ray Wenderlich. All rights reserved.
//

import UIKit
import Photos

class AnnotatedPhotoCell: UICollectionViewCell {
  
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var imageViewHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet private weak var captionLabel: UILabel!
    @IBOutlet private weak var commentLabel: UILabel!
    @IBOutlet weak var buttonLike: UIButton!
    
    var asset : SLAsset!

    func setup(imageManager : PHCachingImageManager, photoAsset : PHAsset, asset : SLAsset) {
        // set the asset
        self.asset = asset
        // immediately set the image to nil so we don't see a stale photo
        self.imageView.image = nil
        // load up the image async
        imageManager.requestImageForAsset(photoAsset, targetSize: CGSize(width: 100.0, height: 100.0), contentMode: .AspectFill, options: nil) { image, info in
            self.imageView.image = image
        }
        // set the easy properties
        self.captionLabel.text = asset.caption
        self.buttonLike.alpha = asset.isLiked ? 1.0 : 0.2
        self.commentLabel.text = asset.tags.items.map { item in item.value }.joinWithSeparator(", ")
    }
    
    //invert the sloth and release the kracken!
    @IBAction func handleLikePressed(sender: AnyObject) {
        slothRealm.write {
            self.asset.isLiked = !self.asset.isLiked
        }
        self.buttonLike.alpha = (self.asset.likeStatus == .Liked) ? 1.0 : 0.2
    }
    
    func setTags(tags: [String]) {
        commentLabel.text = tags.joinWithSeparator(",")
    }
  
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)
        if let attributes = layoutAttributes as? PinterestLayoutAttributes {
            imageViewHeightLayoutConstraint.constant = attributes.photoHeight
        }
    }
}
