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
    
    @IBAction func handleClearDatabaseButton(sender: AnyObject) {
        clearDatabase()
    }
    @IBAction func handleGatherButton(sender: AnyObject) {
        gather()
    }
    @IBAction func handleClearGatherButton(sender: AnyObject) {
        clearDatabase()
        gather()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let gesture = UITapGestureRecognizer(target: self, action: "refreshDirectoryLabel")
        self.lblDocumentPath.addGestureRecognizer(gesture)
        self.lblDocumentPath.userInteractionEnabled = true
        refreshDirectoryLabel()
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
    
    func clearDatabase() {
        slothRealm.delete()
    }
    func gather() {
        AssetGatherer.gather()
    }
    
    func refreshDirectoryLabel() {
        let slothPath = File.documentDirectory.combine("sloth")
        lblDocumentPath.text = slothPath.fileSystemString
        if File.exists(slothPath) {
            lblDocumentPath.textColor = UIColor.greenColor()
        }
        else {
            lblDocumentPath.textColor = UIColor.redColor()
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
