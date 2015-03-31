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
    @IBOutlet weak var page:UIPageControl!
    @IBOutlet weak var level:UIView!
    
    var mananciais: NSArray!

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
                self.mananciais = NSJSONSerialization.JSONObjectWithData(dataObject!, options: nil, error: nil) as NSArray
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.page.numberOfPages = self.mananciais.count
                    self.showPage(0)
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
    
    func showPage(index:Int) {
        let manancial = Manancial(manancialDic: self.mananciais[index] as NSDictionary)
        
        self.nameLabel.text = "\(manancial.name)"
        self.volumeLabel.text = "\(manancial.volume)"
        self.dayLabel.text = "\(manancial.rainDay)"
        self.monthLabel.text = "\(manancial.rainMonth)"
        self.avgLabel.text = "\(manancial.rainAvg)"
        
        self.volumeLabel.hidden = false
        self.dayLabel.hidden = false
        self.monthLabel.hidden = false
        self.avgLabel.hidden = false
        
        (0 , 0, self.view.frame.width, self.view.frame.height * 0.7)
        
        var volume:NSDecimalNumber = NSDecimalNumber(string: manancial.volume.stringByReplacingOccurrencesOfString(" %", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil).stringByReplacingOccurrencesOfString(",", withString: ".", options: NSStringCompareOptions.LiteralSearch, range: nil))
        
        var pixel = CGFloat(volume) / 100 * self.view.frame.size.height

        let y:CGFloat = self.view.frame.size.height - pixel;
        
        NSLog("%@", pixel)
        NSLog("%@", y);

        self.level.frame.origin.y = y
        self.level.frame.size.height = pixel
    }

    @IBAction func pageChanged() {
        showPage(page.currentPage);
    }

}

