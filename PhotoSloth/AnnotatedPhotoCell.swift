//
//  AnnotatedPhotoCell.swift
//  RWDevCon
//
//  Created by Mic Pringle on 26/02/2015.
//  Copyright (c) 2015 Ray Wenderlich. All rights reserved.
//

import UIKit
import Photos
import RealmSwift

class AnnotatedPhotoCell: UICollectionViewCell {
  
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var imageViewHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet private weak var captionLabel: UILabel!
    @IBOutlet private weak var commentLabel: UILabel!
    @IBOutlet weak var buttonLike: UIButton!
    
    private(set) var asset : SLAsset?
    private var realmToken : NotificationToken?
    
    let alphaSelected : CGFloat = 1.0
    let alphaNotSelected : CGFloat = 0.2
    
    deinit {
        slothRealm.removeNotificationBlock(realmToken)
    }
    
    func setup(asset : SLAsset) {
        // make sure we have a clean slate
        reset()
        
        // set the asset
        self.asset = asset
        // setup the notification
        realmToken = slothRealm.addNotificationBlock { notification, realm in
            // handle any changes to our asset
            if let a = self.asset {
                if a.invalidated {
                    self.userInteractionEnabled = false
                    self.reset()
                }
                else {
                    self.assetUpdate()
                }
            }
        }
        // immediately set the image to nil so we don't see a stale photo
        self.imageView.image = nil
        // enable user interaction
        self.userInteractionEnabled = true

        // draw the data for the asset
        self.assetUpdate()
    }
    
    var isInvalid : Bool {
        get {
            return asset?.invalidated ?? false
        }
    }
    
    private func assetUpdate() {
        // refresh UI data
        Misc.updateIfChanged(&self.captionLabel.text, source: self.asset!.caption)
        Misc.updateIfChanged(&self.buttonLike.alpha, source: self.asset!.isLiked ? self.alphaSelected : self.alphaNotSelected)
        Misc.updateIfChanged(&self.commentLabel.text, source: self.asset!.locationText)
    }
    
    private func reset() {
        slothRealm.removeNotificationBlock(self.realmToken)
        self.realmToken = nil
        self.asset = nil
        self.imageView.image = nil
        self.captionLabel.text = nil
        self.buttonLike.alpha = self.alphaNotSelected
        self.commentLabel.text = nil
    }
    
    func setImage(image : UIImage?) {
        self.imageView.image = image
    }
    
    //invert the sloth and release the kracken!
    @IBAction func handleLikePressed(sender: AnyObject) {
        if isInvalid {
            return
        }

        slothRealm.write {
            self.asset!.isLiked = !self.asset!.isLiked
        }
        self.buttonLike.alpha = (self.asset!.likeStatus == .Liked) ? alphaSelected : alphaNotSelected
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)
        if let attributes = layoutAttributes as? PinterestLayoutAttributes {
            imageViewHeightLayoutConstraint.constant = attributes.photoHeight
        }
    }
}
