//
//  ViewController.swift
//  CoolNaviDemo_Swift
//
//  Created by ian on 15/11/26.
//  Copyright © 2015年 ian. All rights reserved.
//

import UIKit

let kWindowHeight: CGFloat = 205.0

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView?
    var headerView: CoolNavi?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.hidden = true
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        tableView = UITableView()
        tableView!.backgroundColor = UIColor.clearColor()
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView?.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        self.view.addSubview(tableView!)
        
        headerView = CoolNavi()
        headerView!.myInit(CGRectMake(0,0,self.view.frame.size.width,kWindowHeight), backImageName: "background", headerImageURL: "http://d.hiphotos.baidu.com/image/pic/item/0ff41bd5ad6eddc4f263b0fc3adbb6fd52663334.jpg", title: "妹子!", subTitle: "个性签名, 啦啦啦!")
        headerView?.scrollView = tableView
        headerView?.initWithClosure({ () -> Void in
            print("headerImageAction")
        })
        self.view.addSubview(headerView!)
      
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel!.text = String(format: "%i", indexPath.row + 1)
        return cell
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

