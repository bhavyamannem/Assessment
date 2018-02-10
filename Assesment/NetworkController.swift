//
//  NetworkController.swift
//  Assesment
//
//  Created by Bhavya Santhu on 10/02/18.
//  Copyright © 2018 Bhavya. All rights reserved.
//

import UIKit

class NetworkController: UIViewController {
    var bookList = [Book]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    //Function to parse JSON
    func getJSON(urlString:String)
    {
        
        let result = [String:AnyObject]()
        if let postData = try? JSONSerialization.data(withJSONObject: result, options: JSONSerialization.WritingOptions.prettyPrinted) {
            
            let url = NSURL(string: urlString)!
            print("url::",url)
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = postData
            print(postData)
            let task = URLSession.shared.dataTask(with: request as URLRequest){ data,response,error in
                if error != nil{
                    print(error?.localizedDescription ?? "")
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title:"Error",
                                                      message:error?.localizedDescription,
                                                      preferredStyle:.alert)
                        let okAction = UIAlertAction(title:"Ok",
                                                     style:.default,
                                                     handler:nil)
                        alert.addAction(okAction)
                        
                        self.present(alert,
                                     animated: true,
                                     completion: nil)
                        let nc = NotificationCenter.default
                        nc.post(name: Notification.Name("removeBoxView"), object: nil)
                        //                        self.boxView.removeFromSuperview()
                    }
                    return
                }
                do {
                    var error: Error?
                    let string = try? String(contentsOf: URL(string: urlString)!, encoding: .isoLatin1)
                    let resData: Data? = string?.data(using: .utf8)
                    let json = try? JSONSerialization.jsonObject(with: resData ?? Data(), options: .mutableContainers) as? NSDictionary
                    if error != nil {
                        //Error handling
                    }
                    else {
                        //use your json object
                        _ = json!!["rows"] as? [Any]
                        if let parseJSON = json {
                            let title = json!!["title"] as! String
                            DispatchQueue.main.async(execute: {
                                self.navigationItem.title = title
                            })
                            
                            let queue = DispatchQueue.global(qos: .userInitiated)
                            queue.async {
                                if let serviceList = parseJSON!["rows"] as? Array<Dictionary<String, Any>>{
                                    for res in serviceList{
                                        var list = Book()
                                        list.name = res["title"] as? String ?? "N/A"
                                        list.details = res["description"] as? String ?? "N/A"
                                        let thumbnail = res["imageHref"] as? String
                                        if  thumbnail != "null" || thumbnail != nil{
                                            list.thumbnail = thumbnail
                                        }
                                        self.bookList.append(list)
                                    }
                                    DispatchQueue.main.async {
                                        
                                        let nc = NotificationCenter.default
                                        nc.post(name: Notification.Name("updateTitle"), object: title)
                                        nc.post(name: Notification.Name("updateTableView"), object: self.bookList)
                                        
                                    }
                                }
                            }
                            
                            DispatchQueue.main.async {
                                let nc = NotificationCenter.default
                                nc.post(name: Notification.Name("removeBoxView"), object: nil)
                            }
                        }
                    }
                } catch let error as NSError {
                    print(error)
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title:"Error",
                                                      message:error.localizedDescription,
                                                      preferredStyle:.alert)
                        let okAction = UIAlertAction(title:"Ok",
                                                     style:UIAlertActionStyle.default,
                                                     handler:nil)
                        alert.addAction(okAction)
                        self.present(alert,
                                     animated: true,
                                     completion: nil)
                        let nc = NotificationCenter.default
                        nc.post(name: Notification.Name("removeBoxView"), object: nil)
                    }
                    
                }
            }
            task.resume()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
