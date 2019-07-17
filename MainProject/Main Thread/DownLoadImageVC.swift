//
//  DownLoadImageVC.swift
//  MainProject
//
//  Created by Alex wee on 2019/7/2.
//  Copyright © 2019 Alex wee. All rights reserved.
//

import UIKit

class DownLoadImageVC: UIViewController {
    
    
    @IBOutlet weak var progress: UIProgressView!
    var task: URLSessionDownloadTask!
    var totalBytesBeWritten: Int64 = 0
    
    let configuration = URLSessionConfiguration.background(withIdentifier: "com.background.session")
    
    let url = URL(string: "https://developer.apple.com/library/content/samplecode/SceneKit_Slides_WWDC2013/SceneKit_Slides_WWDC2013.zip")!

    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
   


    @IBAction func startDownloadAction(_ sender: UIButton) {
        
        let session = URLSession(configuration:configuration , delegate: self, delegateQueue: OperationQueue.main)
//        task = session.downloadTask(with: url, completionHandler: { (url, response, error) in
//
//
//        })
        task = session.downloadTask(with: url)
        task.resume()
        
    
    }
    override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
        guard (task != nil) else {
            return
        }
        task.cancel()
    }
    
    deinit {
        print("\(self) has been released")
        guard (task != nil) else {
            return
        }
        task.cancel()
    }
 
}

extension DownLoadImageVC: URLSessionDownloadDelegate{
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("done")
    }
    
  
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64){
        totalBytesBeWritten += bytesWritten
        let progressvalue = Float(Double(totalBytesBeWritten) / Double(totalBytesExpectedToWrite))
        print(progressvalue)
        self.progress.progress = progressvalue

    
    }
    
    
    
    
    
    
    
    
    
}
