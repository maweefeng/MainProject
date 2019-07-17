//
//  ViewController.swift
//  MainProject
//
//  Created by Alex wee on 2019/7/2.
//  Copyright © 2019 Alex wee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var backcolorArr:[UIColor] = [UIColor.red,UIColor.gray,UIColor.green,UIColor.lightGray,UIColor.blue,UIColor.cyan,UIColor.magenta,UIColor.orange,UIColor.purple,UIColor.brown,UIColor.darkGray]

    lazy var dataArr :[String] = ["Main Thread Tracker","Closure","Retain Cycle","OpreationQueue","DispatchQueue","VoiceSampling"]
    @IBOutlet weak var tableView: UITableView!
    let refreshView = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "测试程序"
        tableView.register(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: "cellid")
        refreshView.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshView)
        self.navigationController?.navigationBar.barTintColor =
            UIColor(red: 42/255.0, green: 43/255.0, blue: 47/255.0, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let image = createImageWithColor(.init(displayP3Red: 42/255.0, green: 43/255.0, blue: 47/255.0, alpha: 1.0),
                                         frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        self.navigationController?.navigationBar.setBackgroundImage(image, for: .default)

    }
    
    //生成一个指定颜色的图片
    func createImageWithColor(_ color: UIColor, frame: CGRect) -> UIImage? {
        // 开始绘图
        UIGraphicsBeginImageContext(frame.size)
        
        // 获取绘图上下文
        let context = UIGraphicsGetCurrentContext()
        // 设置填充颜色
        context?.setFillColor(color.cgColor)
        // 使用填充颜色填充区域
        context?.fill(frame)
        
        // 获取绘制的图像
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        // 结束绘图
        UIGraphicsEndImageContext()
        return image
    }
    
    @objc func refresh(){
       
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 2.0) {[weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.refreshView.endRefreshing()
            }
        }
        
        
    }


}

extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellid", for: indexPath) as! MainTableViewCell
        cell.selectionStyle = .none
        let count:UInt32 =  UInt32(backcolorArr.count - 1)
        let temp = Int(arc4random()%count)
        cell.backgroudView.backgroundColor = backcolorArr[temp]
        cell.mainDisplayLabel.text = dataArr[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        switch indexPath.row {
        case 0:
            let vc = DownLoadImageVC()
            self.navigationController?.pushViewController(vc, animated: true)
            break

        case 1:
            let vc = BlockViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            break
          
        case 2:
            let vc = RetainCycleViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            break
        
        case 3:
            let vc = OperationQueueVC()
            self.navigationController?.pushViewController(vc, animated: true)
            break
        
        case 4:
            let vc = DispatchQueueViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
        case 5:
            let vc = VoiceSampleViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            break
        default:
            break
            
        }

    }
    
    
}

