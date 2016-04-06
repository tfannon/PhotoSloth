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
import RxCocoa
import RxSwift
import RxGesture

class PhotoCell: UICollectionViewCell {
  
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var imageViewHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet private weak var captionLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var poiLabel: UILabel!
    @IBOutlet private weak var buttonLike: UIButton!
    
    private var viewModel : PhotoCellVM!
    private let disposeBag = DisposeBag()

    private let alphaSelected : CGFloat = 1.0
    private let alphaNotSelected : CGFloat = 0.2
    
    // weak reference back to the view controller
    // so we can display an alert box
    private weak var viewController : UIViewController?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(viewController : UIViewController, assetId : String, imageSize : CGSize) {
        // parent view controller
        self.viewController = viewController
        
        // bind the view model to our controls
        viewModel = PhotoCellVM(assetId: assetId, imageSize: imageSize)
        viewModel.caption.bindTo(self.captionLabel.rx_text).addDisposableTo(disposeBag)
        viewModel.location.bindTo(self.locationLabel.rx_text).addDisposableTo(disposeBag)
        viewModel.isLiked.subscribeNext{ value in
            self.buttonLike.alpha = (value) ? self.alphaSelected : self.alphaNotSelected
        }.addDisposableTo(disposeBag)
        viewModel.image.bindTo(self.imageView.rx_image).addDisposableTo(disposeBag)
        viewModel.chosenPOI.bindTo(self.poiLabel.rx_text).addDisposableTo(disposeBag)
        
        // pan gesture
        self.rx_gesture(.Pan(.Changed))
            .subscribeNext { gesture in
                switch gesture {
                    case .Pan(let data):
                        print("offset: \(data.translation)")
                    default: break
                }
            }
            .addDisposableTo(disposeBag)
        
        //the long press brings up the fetched nearby locations for choosing
        let poiGesture = UILongPressGestureRecognizer()
        poiGesture.minimumPressDuration = 0.5
        poiGesture.delaysTouchesBegan = true
        self.addGestureRecognizer(poiGesture)
        poiGesture.rx_event
            .filter { g in
                g.state == UIKit.UIGestureRecognizerState.Ended
                && self.viewModel.potentialPOIs.any
            }
            .map { _ in
                self.viewModel.potentialPOIs
            }
            .subscribeNext{ pois in
                self.pickPOI(pois)
            }
            .addDisposableTo(disposeBag)
        
        // 'like' tap gesture
        buttonLike.rx_tap.subscribeNext{ _ in
            self.viewModel.isLiked.onNext(try! !self.viewModel.isLiked.value())
        }
        .addDisposableTo(disposeBag)
        
        // enable user interaction
        self.userInteractionEnabled = true
    }
    
    // called to reset it's state to default
    // since cells are reused by the controller
    func clean() {
        viewModel = nil
    }

    //
    // alert box for picking the POI
    //
    func pickPOI(pois : [String]) {
        let alert = UIAlertController(title: "Nearby places", message: "Choose one to tag photo", preferredStyle: UIAlertControllerStyle.ActionSheet) // 1
        let maxChoices = 5
        var idx = 0
        for x in pois {
            let action = UIAlertAction(title: x, style: .Default) { (y:UIAlertAction!) in
                self.viewModel.chosenPOI.onNext(x)
            }
            alert.addAction(action)
            idx += 1
            if idx > maxChoices {
                break
            }
        }
        alert.addAction(UIAlertAction(title: "Clear tag", style: UIAlertActionStyle.Destructive, handler: { _ in
            slothRealm.write {
                self.viewModel.chosenPOI.onNext("")
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler:nil))
        self.viewController?.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)
        if let attributes = layoutAttributes as? PinterestLayoutAttributes {
            imageViewHeightLayoutConstraint.constant = attributes.photoHeight
        }
    }
}
