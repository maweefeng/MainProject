//
//  MainTableViewCell.swift
//  MainProject
//
//  Created by Alex wee on 2019/7/14.
//  Copyright © 2019 Alex wee. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    @IBOutlet weak var mainDisplayLabel: UILabel!
    @IBOutlet weak var backgroudView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        backgroudView.layer.cornerRadius = 10
        self.setShadow(view: self.contentView, sColor: UIColor.gray, offset: CGSize(width: 0, height: 0), opacity: 0.8, radius: 3)

    }
    func setShadow(view:UIView,sColor:UIColor,offset:CGSize,
                   opacity:Float,radius:CGFloat) {
        //设置阴影颜色
        view.layer.shadowColor = sColor.cgColor
        //设置透明度
        view.layer.shadowOpacity = opacity
        //设置阴影半径
        view.layer.shadowRadius = radius
        //设置阴影偏移量
        view.layer.shadowOffset = offset
    }
    
 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
