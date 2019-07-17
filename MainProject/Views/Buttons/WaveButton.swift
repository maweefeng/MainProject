//
//  WaveButton.swift
//  MainProject
//
//  Created by Alex wee on 2019/7/15.
//  Copyright © 2019 Alex wee. All rights reserved.
//

import UIKit

class WaveButton: UIButton {
    
    let pulsingCount: NSInteger = 3;
    let animationDuration: Double = 3;
    let animationLayer = CALayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
    
    
        

    override func draw(_ rect: CGRect) {
        if !self.isSelected{
            animationLayer.removeFromSuperlayer()
            self.layer.removeAllAnimations()
            return
        }
        for i in 0...pulsingCount{
            let animationArray = self.getAnimateArr()
            let animationGroup = self.animationGroupAnimations(arr: animationArray , index: i)
            let pulsingLayer =  self.pulsingLayer(rect: rect, animation: animationGroup)
            animationLayer.addSublayer(pulsingLayer)
        }
        self.layer.insertSublayer(animationLayer, at: 0)
    }
        
    
    func getAnimateArr() -> [CAAnimation] {
        
        let scaleAni = scaleAnimation()
        let borderani = borderColorAnimation()
        let background = backgroundColorAnimation()

        return [scaleAni, borderani,background]
    }
    
    
    func animationGroupAnimations(arr:[CAAnimation],index:Int) -> CAAnimationGroup {
        
        let defaultCurve = CAMediaTimingFunction(name: .default)
        let animationGroup = CAAnimationGroup()
        
        animationGroup.fillMode = CAMediaTimingFillMode.backwards
        animationGroup.beginTime = CACurrentMediaTime() + (Double(index) * animationDuration) / Double(pulsingCount)
        animationGroup.duration = CFTimeInterval(animationDuration)
        animationGroup.repeatCount = HUGE
        animationGroup.timingFunction = defaultCurve;
        animationGroup.animations = arr
        animationGroup.isRemovedOnCompletion = false
        return animationGroup;

    }
    func pulsingLayer(rect:CGRect,animation:CAAnimationGroup) -> CALayer {
        
        let pulsingLayer = CALayer()
        
        pulsingLayer.frame = CGRect(x: rect.size.width * 0.1, y: rect.size.width * 0.1, width: rect.size.width*0.8, height: rect.size.height*0.8);
        
        pulsingLayer.backgroundColor = UIColor(displayP3Red: 226/255.0, green: 95/255.0, blue: 159/255.0, alpha: 0.5).cgColor
        pulsingLayer.borderWidth = 0.5
        
        pulsingLayer.borderColor = UIColor(displayP3Red: 226/255.0, green: 95/255.0, blue: 159/255.0, alpha: 0.5).cgColor
        
        pulsingLayer.cornerRadius = (rect.size.height * 0.8) / 2
        pulsingLayer.add(animation, forKey: "plulsing")
        return pulsingLayer
    }
    
    func scaleAnimation() -> CABasicAnimation {
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 1
        scaleAnimation.toValue = 1.2
        return scaleAnimation
    }

    
    func backgroundColorAnimation() -> CAKeyframeAnimation {
        let backgroundColorAnimation = CAKeyframeAnimation()
        backgroundColorAnimation.keyPath = "backgroundColor";
        backgroundColorAnimation.values = [UIColor(displayP3Red: 226/255.0, green: 95/255.0, blue: 159/255.0, alpha: 0.5).cgColor,
        UIColor(displayP3Red: 213/255.0, green: 114/255.0, blue: 162/255.0, alpha: 0.5).cgColor,
        UIColor(displayP3Red: 210/255.0, green: 134/255.0, blue: 171/255.0, alpha: 0.5).cgColor,
        UIColor(displayP3Red: 210/255.0, green: 134/255.0, blue: 171/255.0, alpha: 0).cgColor]
        backgroundColorAnimation.keyTimes = [0.3,0.6,0.9,1];
        return backgroundColorAnimation
    }

    func borderColorAnimation() -> CAKeyframeAnimation {
        let borderColorAnimation = CAKeyframeAnimation()
        borderColorAnimation.keyPath = "borderColor";
        borderColorAnimation.values = [UIColor(displayP3Red: 226/255.0, green: 95/255.0, blue: 159/255.0, alpha: 0.5).cgColor,
                                       UIColor(displayP3Red: 213/255.0, green: 114/255.0, blue: 162/255.0, alpha: 0.5).cgColor,
                                       UIColor(displayP3Red: 210/255.0, green: 134/255.0, blue: 171/255.0, alpha: 0.5).cgColor,
                                       UIColor(displayP3Red: 210/255.0, green: 134/255.0, blue: 171/255.0, alpha: 0).cgColor]
        borderColorAnimation.keyTimes = [0.3,0.6,0.9,1];
        return borderColorAnimation
     
    }
    


}
