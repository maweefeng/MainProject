//
//  RetainCycleViewController.swift
//  MainProject
//
//  Created by Alex wee on 2019/7/6.
//  Copyright © 2019 Alex wee. All rights reserved.
//

import UIKit

class Person{

    var num: Int = 8
    
    deinit {
        print("myclass will be deallocated")
    }
    
}
class RetainCycleViewController: UIViewController {
    var str = """
    override func viewDidLoad() {

        super.viewDidLoad()
        self.view.backgroundColor = .white
        var first: Person? = Person()
        var second = first
        var third = first
            
        self.person = first
            
        first = nil
        second = nil
        third = nil
    }
    """
    
    weak var person: Person?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        var first: Person? = Person()
//        let second = first
//        let third = first
        
        self.person = first
        
        first = nil

        let label = UILabel()
        label.text = str
        label.numberOfLines = 0
        self.view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        let motioneffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        motioneffect.minimumRelativeValue =  -40.0
        motioneffect.maximumRelativeValue = 40.0
        label.addMotionEffect(motioneffect)
        let constrants:[NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[label]-|", options: .alignAllCenterX, metrics: nil, views: ["label":label])
        let constrants1:[NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "V:|-80-[label]", options: .alignAllCenterY, metrics: nil, views: ["label":label])
        
        self.view.addConstraints(constrants)
        self.view.addConstraints(constrants1)

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
