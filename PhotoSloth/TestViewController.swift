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
        Googles.getPlaces(29.879500, longitude:  -81.287000) { result in
            print (result.places)
        }
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
        let dir = File.documentDirectory.combine("sloth")
        print (File.exists(dir))
        
        AssetGatherer.gather()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
