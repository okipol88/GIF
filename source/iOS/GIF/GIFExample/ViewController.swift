//
//  ViewController.swift
//  GIFExample
//
//  Created by Błażej Szajrych on 17.09.2016.
//  Copyright © 2016 Błażej Szajrych. All rights reserved.
//

import UIKit
import GIF

class ViewController: UIViewController {

    private let kGIFCatGifImagesFolderName = "cat_gif";
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startConversion(sender: AnyObject) {
        guard let button = sender as? UIButton else { return }
        
        button.hidden = true
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let paths = self.allFrameImages()
            [self .encodeFrames(paths)]
            
            dispatch_async(dispatch_get_main_queue(), {
                button.hidden = false
            })
        }
    }
    
    func encodeFrames(paths: [String]) -> String {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        var encoder: GIFEncoder? = nil
        let gifName = "\(NSUUID().UUIDString).gif"
        let gifPath = "\(documentsPath)\(gifName)"
        
        dispatch_async(dispatch_get_main_queue(), {self.progressBar.setProgress(0.0, animated: false) })
        let count = paths.count
        
        for path in paths.enumerate() {
            guard let image = UIImage(contentsOfFile: path.element) else {
                print("Could not acquire image at path \(path.element)")
                continue
            }
            if encoder == nil {
                encoder = GIFEncoder(mode: .NormalLowMemory, width: UInt(image.size.width), height: UInt(image.size.height), filePath: gifPath)
            }
            do {
                try encoder?.encodeFrame(image, frameDelay: 250)
            } catch {
                print("Could not create frame for image at path \(path.element)")
            }
            let progress = Float(path.index) / Float(count)
            
            dispatch_async(dispatch_get_main_queue(), {self.progressBar.setProgress(progress, animated: true) })
        }
        
        encoder?.closeGif()
        
        dispatch_async(dispatch_get_main_queue(), {
            self.progressBar.setProgress(0.0, animated: false)
            let alert = UIAlertView(title: "File created", message: "GIF file created in documents with name \(gifName)", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "OK")
            alert.show()
        })
        
        
        return documentsPath
    }
    
    func allFrameImages() -> [String] {
        var imagePaths:[String] = []
      
        let contents = NSBundle.mainBundle().pathsForResourcesOfType("jpeg", inDirectory: kGIFCatGifImagesFolderName)
        for path in contents {
            imagePaths.append("\(path)")
        }

        return imagePaths
    }

}

