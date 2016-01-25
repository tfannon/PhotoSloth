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
    @IBOutlet weak var progress1: UIProgressView!
    @IBOutlet weak var googleMockSwitch: UISwitch!

    @IBOutlet weak var delayGatherText: UITextField!
    @IBOutlet weak var delayGatherBetweenText: UITextField!
    @IBOutlet weak var clearDatabaseButton: UIButton!
    @IBOutlet weak var clearDatabaseGatherButton: UIButton!
    // MARK: - Actions
    @IBAction func handleButton1(sender: AnyObject) {
        misc()
    }
    @IBAction func handleGoogleMockSwitch(sender: AnyObject) {
        UserSettings.mockGoogle = (sender as! UISwitch).on
    }
    
    @IBAction func handleButton2(sender: AnyObject) {
        Googles.getPlaces(29.879500, longitude:  -81.287000) { result in
            print (result.places)
        }
    }
    
    @IBAction func delayGatherHandleChanged(sender: AnyObject) {
        UserSettings.delayGather = NSNumberFormatter().numberFromString((sender as! UITextField).text ?? "")?.integerValue ?? 0
    }
    @IBAction func delayGatherBetweenHandleChanged(sender: AnyObject) {
        UserSettings.delayGatherBetween = NSNumberFormatter().numberFromString((sender as! UITextField).text ?? "")?.integerValue ?? 0
    }
    @IBAction func handleClearDatabaseButton(sender: AnyObject) {
        if !clearDatabase() {
            clearDatabaseButton.enabled = false
        }
    }
    @IBAction func handleGatherButton(sender: AnyObject) {
        gather()
    }
    @IBAction func handleClearGatherButton(sender: AnyObject) {
        deleteObjectsFromDatabase()
        gather()
    }
    @IBAction func handleDeleteObjectsButton(sender: AnyObject) {
        deleteObjectsFromDatabase()
    }

    // MARK - View
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let gesture = UITapGestureRecognizer(target: self, action: "refreshDirectoryLabel")
        self.lblDocumentPath.addGestureRecognizer(gesture)
        self.lblDocumentPath.userInteractionEnabled = true
        refreshDirectoryLabel()
        updateProgress(0, animated: false)
        self.googleMockSwitch.setOn(UserSettings.mockGoogle, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func misc() {
        let test = 10
        let total = 10
        for i in 1...test {
            let p = Float(i) / Float(total)
            updateProgress(p)
        }
    }
    
    func clearDatabase() -> Bool {
        let result = RealmBase.delete("sloth")
        if !result {
            self.alert("Test", message: "You can't clear the database because it's already been used.  Shutdown and restart the app if you need to do this.")
        }
        refreshDirectoryLabel()
        return result
    }
    func gather() {
        NSTimer.schedule(delay: 5) { _ in
            AssetGatherer.gather({ progress in self.updateProgress(progress.progress) }) {
                self.refreshDirectoryLabel()
            }
        }
    }
    func deleteObjectsFromDatabase() {
        slothRealm.deleteAll()
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
    
    func updateProgress(progress : Float, animated: Bool = true) {
        dispatch_async(dispatch_get_main_queue()) {
            print ("\tProgress callback: \(progress)")
            self.progress1.progress = progress
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
