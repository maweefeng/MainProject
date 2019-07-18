//
//  DispatchQueueViewController.swift
//  MainProject
//
//  Created by Alex wee on 2019/7/14.
//  Copyright © 2019 Alex wee. All rights reserved.
//

import UIKit

class DispatchQueueViewController: UIViewController {
    var firstImageV: UIImageView!
    
    var secondImageV: UIImageView!
    
    var thirdImageV: UIImageView!
    
    let url = URL(string: "http://pic37.nipic.com/20140113/8800276_184927469000_2.png")
    let url1 = URL(string: "http://f.hiphotos.baidu.com/image/pic/item/a71ea8d3fd1f4134d244519d2b1f95cad0c85ee5.jpg")
    let url2 = URL(string: "http://f.hiphotos.baidu.com/image/pic/item/8326cffc1e178a82c4403d44f803738da877e8d2.jpg")
    var namestr: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "show Red", style: .plain, target: self, action: #selector(pushToRed))
        firstImageV = UIImageView()
        firstImageV.contentMode = .scaleAspectFit
        firstImageV.layer.masksToBounds = true
        firstImageV.translatesAutoresizingMaskIntoConstraints = false
        
        secondImageV = UIImageView()
        secondImageV.contentMode = .scaleAspectFit
        secondImageV.layer.masksToBounds = true
        secondImageV.translatesAutoresizingMaskIntoConstraints = false

        thirdImageV = UIImageView()
        thirdImageV.contentMode = .scaleAspectFit
        thirdImageV.layer.masksToBounds = true
        thirdImageV.translatesAutoresizingMaskIntoConstraints = false
    
        let stackView = UIStackView(arrangedSubviews: [firstImageV,secondImageV,thirdImageV])
        stackView.backgroundColor = .white
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        stackView.spacing = 20
        self.view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
    
        NSLayoutConstraint.activate([stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),stackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -80), stackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80),stackView.widthAnchor.constraint(equalToConstant: 300)])
        
        aysncDownloadImage()

        
    }
    func aysncDownloadImage(){
        
        
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: self.url1!)
                DispatchQueue.main.async {
                    self.secondImageV.image =  UIImage(data: data)
                    
                }
                print("2222 \(Thread.current)")
                
            } catch {
            }
            
        }
        DispatchQueue.global().async {
            
            do {
                let data = try Data(contentsOf: self.url!)
                DispatchQueue.main.async {
                    
                    self.firstImageV.image =  UIImage(data: data)
                }
                
                print("1111 \(Thread.current)")
            } catch {
            }}
        DispatchQueue.global().async {
            
            do {
                let data = try Data(contentsOf: self.url2!)
                DispatchQueue.main.async {
                    self.thirdImageV.image =  UIImage(data: data)
                }
                
                print("3333 \(Thread.current)")
                
            } catch {
            }
            
        }
        
    }
    func asyncmethod()  {
        
        DispatchQueue.global().async {
            
            DispatchQueue.main.sync {
                print("DispatchQueue.main.sync task \(Thread.current)")
                
            }
            
            print("DispatchQueue.global().async task \(Thread.current)")
        }
    }
    
    @objc func pushToRed(){
        self.navigationController?.pushViewController(RedViewController(), animated: true)
        
    }
    
    deinit {
        print("\(self) has been released")
    }
}

class Server{
    var red: RedViewController?
    
}
class RedViewController: UIViewController{
    deinit {
        print("redcontroller has be removed")
    }
    let server:Server = Server()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        server.red = self
        // Do any additional setup after loading the view.
    }
    
}
