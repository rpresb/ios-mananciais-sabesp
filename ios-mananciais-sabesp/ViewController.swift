//
//  ViewController.swift
//  ios-mananciais-sabesp
//
//  Created by Rodrigo Presbiteris on 30/03/15.
//  Copyright (c) 2015 Rodrigo Presbiteris. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var avgLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = "Carregando..."
        volumeLabel.hidden = true
        dayLabel.hidden = true
        monthLabel.hidden = true
        avgLabel.hidden = true

        loadData();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData() {
        let baseURL = NSURL(string: "https://sabesp-api.herokuapp.com/")
        let sharedSession = NSURLSession.sharedSession()
        let downloadTask: NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(baseURL!, completionHandler: { (location: NSURL!, response:NSURLResponse!, error: NSError!) -> Void in
            if (error == nil) {
                let dataObject = NSData(contentsOfURL: location)
                let mananciais: NSArray = NSJSONSerialization.JSONObjectWithData(dataObject!, options: nil, error: nil) as NSArray
                
                let manancial = Manancial(manancialDic: mananciais[0] as NSDictionary)

                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.nameLabel.text = "\(manancial.name)"
                    self.volumeLabel.text = "\(manancial.volume)"
                    self.dayLabel.text = "\(manancial.rainDay)"
                    self.monthLabel.text = "\(manancial.rainMonth)"
                    self.avgLabel.text = "\(manancial.rainAvg)"
                    
                    self.volumeLabel.hidden = false
                    self.dayLabel.hidden = false
                    self.monthLabel.hidden = false
                    self.avgLabel.hidden = false
                })
            } else {
                NSLog("%@", error)
                let networkIssueController = UIAlertController(title: "Error", message: "Unable to load data. Connectivity error!", preferredStyle: .Alert)
                let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
                networkIssueController.addAction(okButton)
                self.presentViewController(networkIssueController, animated: true, completion: nil)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    self.refreshActivityIndicatior.hidden = true
//                    self.refreshActivityIndicatior.stopAnimating()
//                    self.refreshButton.hidden = false
                })
            }
        })
        
        downloadTask.resume()
    }


}

