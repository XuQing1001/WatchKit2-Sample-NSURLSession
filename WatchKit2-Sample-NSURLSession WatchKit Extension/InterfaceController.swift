//
//  InterfaceController.swift
//  WatchKit2-Sample-NSURLSession WatchKit Extension
//
//  Created by XuQing on 15/7/19.
//  Copyright © 2015年 XuQing1001. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet var image: WKInterfaceImage!
    
    var task: NSURLSessionDataTask?
    var isActive: Bool = false
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
    }
    
    override func willActivate() {
        super.willActivate()
        self.isActive = true
    }
    
    override func didDeactivate() {
        super.didDeactivate()
        self.isActive = false
        if let t = self.task {
            if t.state == NSURLSessionTaskState.Running {
                t.cancel()
            }
        }
    }
    
    @IBAction func getImageBtnTapped() {
        
        /* 设置网络图片的URL */
        let url = NSURL(string:"https://devimages.apple.com.edgekey.net/assets/elements/icons/128x128/watchos-2_2x.png")!// 此图片链接仅供测试使用，请更换图片链接
        
        /* 获得一个NSURLSessionConfiguration对象 */
        let conf = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        /* 利用上面的Configuration对象创建一个NSURLSession */
        let session = NSURLSession(configuration: conf)
        
        /* 向指定url发送一个GET请求，在请求完成时执行后续处理：打印错误信息或显示图片 */
        self.task = session.dataTaskWithURL(url) { (data, res, error) -> Void in
            /* 发生错误时 */
            if let e = error {
                print("下载图片失败: \(e.debugDescription)")
                return
            }
            /* 成功获得请求数据时 */
            if let d = data {
                let image = UIImage(data: d)// 创建图片对象
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if self.isActive {
                        self.image.setImage(image)// 显示图片
                    }
                })
            }
        }
        task!.resume()
    }
}