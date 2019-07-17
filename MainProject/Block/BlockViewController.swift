//
//  BlockViewController.swift
//  MainProject
//
//  Created by Alex wee on 2019/7/4.
//  Copyright © 2019 Alex wee. All rights reserved.
//

import UIKit

class BlockViewController: UIViewController {

    var closure: ((Int,Int) -> Int)?
    
    var name = "xiaopi"
    
    let btn = UIButton(type: .custom)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(btn)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .lightGray
        btn.setTitle("Activate", for: .normal)
        btn.titleLabel?.textColor = .black
        btn.addTarget(self, action: #selector(activate), for: .touchUpInside)
        NSLayoutConstraint.activate([btn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),btn.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),btn.widthAnchor.constraint(equalToConstant: 200),btn.heightAnchor.constraint(equalToConstant: 80)])


        closure = {[weak self]  (a,b) -> Int in
            self?.printLog()
            return a+b
        }
        
        guard let addClosure = closure else {
            return
        }
        
        let deadline: DispatchTime = DispatchTime.now() + DispatchTimeInterval.seconds(5)
        
        DispatchQueue.global().asyncAfter(deadline:  deadline) {
            let num = addClosure(1,3)
            print(num)
        }

        
    }
    @objc func activate(){

    }
    func printLog() {
        print("LOG")
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
