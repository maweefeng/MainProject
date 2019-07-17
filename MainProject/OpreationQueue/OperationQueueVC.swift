//
//  OperationQueueVC.swift
//  MainProject
//
//  Created by Alex wee on 2019/7/11.
//  Copyright © 2019 Alex wee. All rights reserved.
//

import UIKit

class OperationQueueVC: UIViewController {

    var str = """
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        let queue = OperationQueue()
        let op = BlockOperation {
            print("执行第1个操作 Thread.current")
        }
        let op1 = BlockOperation {
            print("执行第2个操作 Thread.current")
        }
        let op2 = BlockOperation {
            print("执行第3个操作 Thread.current")
        }
        queue.addOperations([op,op1,op2], waitUntilFinished: false)
    }

    """
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        let queue = OperationQueue()
        
        let op = BlockOperation {
            
            print("执行第1个操作 \(Thread.current)")
        }
        let op1 = BlockOperation {
            
            print("执行第2个操作 \(Thread.current)")
        }
        let op2 = BlockOperation {
            
            print("执行第3个操作 \(Thread.current)")
        }
        queue.addOperations([op,op1,op2], waitUntilFinished: false)
        
        let label = UILabel()
        label.text = str
        label.numberOfLines = 0
        self.view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        let motioneffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        motioneffect.minimumRelativeValue =  -40.0
        motioneffect.maximumRelativeValue = 40.0
        
        let motioneffect_y = UIInterpolatingMotionEffect(keyPath: "backgroundColor", type: .tiltAlongVerticalAxis)
        motioneffect_y.minimumRelativeValue = UIColor.white
        motioneffect_y.maximumRelativeValue = UIColor.init(displayP3Red: 224/255.0, green: 224/255.0, blue: 224/255.0, alpha: 1.0)

        label.addMotionEffect(motioneffect)
        label.addMotionEffect(motioneffect_y)

        let constrants:[NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[label]-|", options: .alignAllCenterX, metrics: nil, views: ["label":label])
        let constrants1:[NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "V:|-80-[label]", options: .alignAllCenterY, metrics: nil, views: ["label":label])

        self.view.addConstraints(constrants)
        self.view.addConstraints(constrants1)

        // Do any additional setup after loading the view.
    }
    
    deinit {
        print("\(self) has been released")
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
