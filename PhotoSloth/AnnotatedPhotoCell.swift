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

class AnnotatedPhotoCell: UICollectionViewCell, UIGestureRecognizerDelegate {
  
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var imageViewHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet private weak var captionLabel: UILabel!
    @IBOutlet private weak var commentLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var buttonLike: UIButton!
    
    @IBAction func handleLikePressed(sender: AnyObject) { handleLike() }
    
    var asset : SLAsset!
    var realmToken : NotificationToken?

    let alphaSelected : CGFloat = 1.0
    let alphaNotSelected : CGFloat = 0.2
    
    var panGestureRecognizer: UIPanGestureRecognizer!
    enum Direction {
        case Undefined
        case Up
        case Down
        case Left
        case Right
    }
    static var direction = Direction.Undefined
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handleGesture:")
        panGestureRecognizer.minimumNumberOfTouches = 1
        panGestureRecognizer.delegate = self
        //uncomment this line to add the cell recognizer
        //self.addGestureRecognizer(panGestureRecognizer)
    }
    
    deinit {
        slothRealm.removeNotificationBlock(realmToken)
    }
    
    func setup(asset : SLAsset) {
        recycle()
        
        // set the asset
        self.asset = asset
        // setup the notification 
        realmToken = slothRealm.addNotificationBlock { notification, realm in
            // re-get the asset
            self.handleRealmUpdate()
        }
        // immediately set the image to nil so we don't see a stale photo
        self.imageView.image = nil
        handleRealmUpdate()
    }
    
    private func handleRealmUpdate() {
        if asset.invalidated {
            recycle()
        }
        else {
            self.captionLabel.text = asset.caption
            self.buttonLike.alpha = asset.isLiked ? alphaSelected : alphaNotSelected
            self.commentLabel.text = asset.locationText
            self.tagLabel.text = asset.chosenPOI != nil ? asset.chosenPOI! : ""
        }
    }
    
    func recycle() {
        slothRealm.removeNotificationBlock(realmToken)
        
        self.asset = nil
        self.imageView.image = nil
        self.captionLabel.text = nil
        self.buttonLike.alpha = alphaNotSelected
        self.commentLabel.text = nil
    }
    
    func setImage(image : UIImage?) {
        self.imageView.image = image
    }
    
    func handleGesture(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case UIGestureRecognizerState.Began:
            if AnnotatedPhotoCell.direction == .Undefined {
                let vel = sender.velocityInView(self)
                let isVertical = fabs(vel.y) > fabs(vel.x)
                if isVertical {
                    AnnotatedPhotoCell.direction = vel.y > 0 ? .Down : .Up
                }
                else {
                    AnnotatedPhotoCell.direction = vel.x > 0 ? .Right : .Left
                }
            }
        case .Changed:
            switch AnnotatedPhotoCell.direction {
            case .Up: print ("up")
            case .Down: print ("down")
            case .Left: print ("left")
            case .Right: print ("right")
            case.Undefined: break
            }
        case UIGestureRecognizerState.Ended: AnnotatedPhotoCell.direction = .Undefined
        default: break
        }
    }

    //invert the sloth and release the kracken!
    func handleLike() {
        slothRealm.write {
            self.asset.isLiked = !self.asset.isLiked
        }
        self.buttonLike.alpha = (self.asset.likeStatus == .Liked) ? 1.0 : 0.2
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)
        if let attributes = layoutAttributes as? PinterestLayoutAttributes {
            imageViewHeightLayoutConstraint.constant = attributes.photoHeight
        }
    }
}
