//
//  VoicesamplingCollectionView.swift
//  MainProject
//
//  Created by Alex wee on 2019/7/15.
//  Copyright © 2019 Alex wee. All rights reserved.
//

import UIKit

class VoicesamplingCollectionView: UICollectionView {


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    

    override func draw(_ rect: CGRect) {
        
        guard  let context = UIGraphicsGetCurrentContext()else{
            return
        }
        let path = CGMutablePath()
        context.setLineWidth(0.5)
        path.move(to: CGPoint(x: 0, y: rect.size.height*0.5))
        path.addLine(to: CGPoint(x:
            rect.size.width, y:
            rect.size.height*0.5))
        context.addPath(path)
        context.setLineCap(.round)
        context.setLineJoin(.round)
        context.setStrokeColor(UIColor.white.cgColor)
        context.strokePath()
    }
 
}
