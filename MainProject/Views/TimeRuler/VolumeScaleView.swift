//
//  VolumeScaleView.swift
//  MainProject
//
//  Created by Alex wee on 2019/7/16.
//  Copyright © 2019 Alex wee. All rights reserved.
//

import UIKit

class VolumeScaleView: UIView {
    var equalHeight: CGFloat = 0.0
    let equalWidth:CGFloat = 30
    let numArr = [0,-1,-2,-3,-5,-7,-10,-10,-7,-5,-3,-2,-1,0]
    override init(frame: CGRect) {
        super.init(frame: frame)
        equalHeight = frame.size.height / CGFloat(numArr.count)
        configUI()
    }

    func configUI()  {
        for (index,num) in numArr.enumerated() {
            let y = CGFloat(index) * equalHeight
            let label = UILabel(frame: CGRect(x: 0, y: y, width: equalWidth, height: equalHeight))
            label.text = "\(num)"
            label.textColor = .white
            label.textAlignment = .right
            label.font = UIFont.systemFont(ofSize: 9)
            self.addSubview(label)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
