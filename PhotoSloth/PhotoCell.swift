//
//  PhotoCell.swift
//  RWDevCon
//
//  Created by Mic Pringle on 26/02/2015.
//  Copyright (c) 2015 Ray Wenderlich. All rights reserved.
//

import UIKit
import Photos
import RealmSwift
import RxSwift
import RxCocoa

class PhotoCell: UICollectionViewCell, UIGestureRecognizerDelegate {
  
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var imageViewHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet private weak var captionLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet weak var poiLabel: UILabel!
    @IBOutlet weak var buttonLike: UIButton!
    
    private var viewModel : PhotoCellVM!
    private let disposeBag = DisposeBag()
    @IBAction func handleLikePressed(sender: AnyObject) { handleLike() }

    private let alphaSelected : CGFloat = 1.0
    private let alphaNotSelected : CGFloat = 0.2
    
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
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(PhotoCell.handleGesture(_:)))
        panGestureRecognizer.minimumNumberOfTouches = 1
        panGestureRecognizer.delegate = self
        //uncomment this line to add the cell recognizer
        //self.addGestureRecognizer(panGestureRecognizer)
    }
    
    func setup(assetId : String) {
        // bind the view model to our controls
        viewModel = PhotoCellVM(assetId: assetId)
        viewModel.caption.bindTo(self.captionLabel.rx_text).addDisposableTo(disposeBag)
        viewModel.location.bindTo(self.locationLabel.rx_text).addDisposableTo(disposeBag)
        viewModel.isLiked.subscribeNext{ value in
            self.buttonLike.alpha = (value) ? self.alphaSelected : self.alphaNotSelected
        }.addDisposableTo(disposeBag)
        viewModel.image.bindTo(self.imageView.rx_image).addDisposableTo(disposeBag)
        viewModel.poi.bindTo(self.poiLabel.rx_text).addDisposableTo(disposeBag)
        
        // enable user interaction
        self.userInteractionEnabled = true
    }

    func setImage(image : UIImage?) {
        // this is done async - so this gets called when the image is available
        viewModel.setImage(image)
    }

    func handleGesture(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case UIGestureRecognizerState.Began:
            if PhotoCell.direction == .Undefined {
                let vel = sender.velocityInView(self)
                let isVertical = fabs(vel.y) > fabs(vel.x)
                if isVertical {
                    PhotoCell.direction = vel.y > 0 ? .Down : .Up
                }
                else {
                    PhotoCell.direction = vel.x > 0 ? .Right : .Left
                }
            }
        case .Changed:
            switch PhotoCell.direction {
            case .Up: print ("up")
            case .Down: print ("down")
            case .Left: print ("left")
            case .Right: print ("right")
            case.Undefined: break
            }
        case UIGestureRecognizerState.Ended: PhotoCell.direction = .Undefined
        default: break
        }
    }

    //invert the sloth and release the kracken!
    func handleLike() {
        viewModel.toggleLiked()
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)
        if let attributes = layoutAttributes as? PinterestLayoutAttributes {
            imageViewHeightLayoutConstraint.constant = attributes.photoHeight
        }
    }
}
