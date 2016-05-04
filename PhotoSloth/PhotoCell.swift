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

class PhotoCell: UICollectionViewCell, IRecyclable {
  
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
    
    // called when the user wants to choose a POI
    // the caller will call the function defined in the second argument
    //  with the value to use
    typealias PickPOIHandler = (candidates: [String]) -> Void
    private var pickPOIHandler : PickPOIHandler?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        print("Photo Cell Deinit")
    }
    
    // 
    // setup the cell - passing in the view controller, asset id and imageSize
    //
    func setup(assetId : String, imageSize : CGSize, pickPOIHandler : PickPOIHandler?) {
        
        // bind the view model to our controls
        viewModel = PhotoCellVM(assetId: assetId, imageSize: imageSize)
        viewModel.caption.bindTo(self.captionLabel.rx_text).addDisposableTo(disposeBag)
        viewModel.location.bindTo(self.locationLabel.rx_text).addDisposableTo(disposeBag)
        viewModel.isLiked.subscribeNext{ value in
            self.buttonLike.alpha = (value) ? self.alphaSelected : self.alphaNotSelected
        }.addDisposableTo(disposeBag)
        viewModel.image.bindTo(self.imageView.rx_image).addDisposableTo(disposeBag)
        viewModel.chosenPOI.bindTo(self.poiLabel.rx_text).addDisposableTo(disposeBag)
        
        self.pickPOIHandler = pickPOIHandler
        
//        // pan gesture
//        self.rx_gesture(.Pan(.Changed))
//            .subscribeNext { gesture in
//                switch gesture {
//                    case .Pan(let data):
//                        print("offset: \(data.translation)")
//                    default: break
//                }
//            }
//            .addDisposableTo(disposeBag)
        
        
        //the long press brings up the possible POIs for choosing
        let poiGesture = UILongPressGestureRecognizer()
        poiGesture.minimumPressDuration = 0.5
        poiGesture.delaysTouchesBegan = true
        self.addGestureRecognizer(poiGesture)
        poiGesture.rx_event
            .subscribeNext{ [unowned self] g in
                if (g.state == UIGestureRecognizerState.Began) {
                    self.pickPOIHandler?(candidates: self.viewModel.potentialPOIs)
                }
            }
            .addDisposableTo(disposeBag)
//
//        poiGesture.rx_event
//            .filter { g in
//                g.state == UIKit.UIGestureRecognizerState.Began
//                    && self.viewModel.potentialPOIs.any
//            }
//            .map { _ in
//                self.viewModel.potentialPOIs
//            }
//            .subscribeNext { pois in
//                self.pickPOI?(pois, { value in
//                    self.viewModel.chosenPOI.onNext(value)
//                })
//            }
//            .addDisposableTo(disposeBag)
        
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
    func recycle() {
        viewModel.dispose()
    }

    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)
        if let attributes = layoutAttributes as? PinterestLayoutAttributes {
            imageViewHeightLayoutConstraint.constant = attributes.photoHeight
        }
    }
}
