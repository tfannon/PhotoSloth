//
//  TestViewController.swift
//  PhotoDeclutter_1
//
//  Created by Adam Rothberg on 1/23/16.
//  Copyright © 2016 Adam Rothberg. All rights reserved.
//

import UIKit
import Realm


class TestViewController: UIViewController {

    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var lblDocumentPath: UILabel!

    // MARK: - Actions
    @IBAction func handleButton1(sender: AnyObject) {
        testDataModel()
    }
    
    @IBAction func handleButton2(sender: AnyObject) {
//        let tagObject = TagObject()
//        Googles.getPlaces(tagObject: tagObject) { result in
//            print (result)
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lblDocumentPath.text = File.documentDirectory.fileSystemString
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func testDataModel() {
        RealmSloth.delete("sloth")
        
        let asset = SLAsset()
        asset.isLiked = true
        slothRealm.addAsset(asset, tagValues: "whatever1", "whatever2", "whatever2")
        
        let asset2 = SLAsset()
        slothRealm.addAsset(asset2, tagValues: "whatever1")
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
