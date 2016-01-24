//
//  AnnotatedPhotoCell.swift
//  RWDevCon
//
//  Created by Mic Pringle on 26/02/2015.
//  Copyright (c) 2015 Ray Wenderlich. All rights reserved.
//

import UIKit

class AnnotatedPhotoCell: UICollectionViewCell {
  
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var imageViewHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet private weak var captionLabel: UILabel!
    @IBOutlet private weak var commentLabel: UILabel!
    @IBOutlet weak var buttonLike: UIButton!
    
    //invert the sloth  -- temporary.  it will disappear when it rolls off screen
    @IBAction func handleLikePressed(sender: AnyObject) {
        buttonLike.alpha = buttonLike.alpha == 1.0 ? 0.2 : 1.0
    }
    
    var photo: Photo! {
        didSet {
            imageView.image = photo.image
            captionLabel.text = photo.caption
            //commentLabel.text = photo.comment
            buttonLike.alpha = photo.liked ? 1.0 : 0.2
        }
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
