//
//  UIViewControllerExtensions.swift
//  PhotoSloth
//
//  Created by Adam Rothberg on 1/24/16.
//  Copyright © 2016 StingrayDev. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    // Works around a bug in Swift where pushing the ViewController the normal way
    //  (via a NavigationController)
    //  doesn't initialize the cell templates in a UITableView
    static func getViewController<T : UIViewController>(
        storyboardName : String,
        viewIdentifier: String) -> T
    {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier(viewIdentifier) as! T
        return vc
    }

    func alert(title : String?, message : String?) {
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
