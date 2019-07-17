//
//  VoiceCollectionViewCell.swift
//  MainProject
//
//  Created by Alex wee on 2019/7/15.
//  Copyright © 2019 Alex wee. All rights reserved.
//

import UIKit

class VoiceCollectionViewCell: UICollectionViewCell {
    var height: Float!
    /// 声音表数组
    var soundMeters: [Float]! {
        
        didSet{
        }
        willSet{
            setNeedsDisplay()
        }
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    override func draw(_ rect: CGRect) {

        if soundMeters != nil && soundMeters.count > 0 {
            guard  let context = UIGraphicsGetCurrentContext()else{
                return
            }
            let soundMeter: Float = Float(soundMeters![0])
            let path = CGMutablePath()
            let noVoice: Float = -46.0     // 该值代表低于-46.0的声音都认为无声音
            let maxVolume: Float = 55.0    // 该值代表最高声音为55.0
//          print("当前的音量为：\(soundMeter)")
            if soundMeter < noVoice{
                height = 1
            }else{
                let ratio = (Float(soundMeter) - Float(noVoice)) / (maxVolume - noVoice)    //通过当前声音表计算应该显示的声音表高度
                let viewheight = 300
                height = Float(viewheight) * Float(ratio)
            }
            
            context.setLineWidth(2)
            path.move(to: CGPoint(x: rect.size.width*0.5, y: rect.size.height*0.5))
            path.addLine(to: CGPoint(x:
                rect.size.width*0.5, y:
                rect.size.height*0.5 - CGFloat(height)))
            path.addLine(to: CGPoint(x:
                rect.size.width*0.5, y:
                rect.size.height*0.5 + CGFloat(height)))
            context.addPath(path)
            context.setLineCap(.round)
            context.setLineJoin(.round)
            context.setStrokeColor(UIColor(displayP3Red: 255/255.0, green: 0/255.0, blue: 117/255.0, alpha: 1.0).cgColor)
            context.strokePath()
        }
    }

   

}
