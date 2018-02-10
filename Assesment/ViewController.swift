//
//  ViewController.swift
//  Assesment
//
//  Created by Bhavya Santhu on 10/02/18.
//  Copyright © 2018 Bhavya. All rights reserved.
//


import UIKit
import Kingfisher

class ViewController: UIViewController {
    
    fileprivate let listCell = "ListCell"
    var bookList = [Book]()
    
    //URL to retrieve data
    let base_Url = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
    
    fileprivate let tableview = UITableView()
    
    var boxView  = UIView()
    
    private let refreshControl = UIRefreshControl()
    
    fileprivate var navBar: UINavigationBar = UINavigationBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "About"
        NotificationCenter.default.addObserver(self, selector: #selector(removeBox), name:NSNotification.Name(rawValue: "removeBoxView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(update), name:NSNotification.Name(rawValue: "updateTableView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTitle), name:NSNotification.Name(rawValue: "updateTitle"), object: nil)
        self.getJSonData()
        configureTableView()
        
    }
    
    //Table view update
    @objc func update(notification: Notification){
        let data = notification.object as! [Book]
        self.refreshControl.endRefreshing()
        if bookList.count > 0 {
            bookList.removeAll()
        }
        self.bookList = data
        
        if bookList.count == 0 {
            self.tableview.removeFromSuperview()
            let textLabel = UILabel(frame: CGRect(x: 50, y: 285, width: 300, height: 40))
            textLabel.textColor = UIColor.blue
            textLabel.textAlignment = .center
            textLabel.font = UIFont(name: textLabel.font.fontName, size: 13)
            textLabel.text = "No content to display"
            self.view.addSubview(textLabel)
        }
        else{
            self.tableview.reloadData()
        }
    }
    
    //Update title
    @objc func updateTitle(notification: Notification){
        let data = notification.object
        let navItem:UINavigationItem = UINavigationItem(title: data as! String)
        self.navBar.setItems([navItem], animated: false)
    }
    
    //
    @objc func removeBox(notification: Notification){
        self.boxView.removeFromSuperview()
    }
    func configureTableView() {
        
        tableview.dataSource = self
        tableview.delegate = self
        
        if #available(iOS 10.0, *) {
            tableview.refreshControl = refreshControl
        } else {
            tableview.addSubview(refreshControl)
            
        }
        
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshTable(_:)), for: .valueChanged)
        tableview.reloadData()
        tableview.register(ListTableViewCell.self, forCellReuseIdentifier: listCell)
        
        view.addSubview(tableview)
        tableview.translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 9.0, *) {
            self.navBar =  UINavigationBar(frame: CGRect(x: 0, y: 20, width: self.view.frame.width, height: 44))
            self.view.addSubview(navBar)
            tableview.topAnchor.constraint(equalTo: navBar.bottomAnchor).isActive = true
            tableview.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            tableview.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            tableview.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    @objc private func refreshTable(_ sender: Any) {
        // Fetch  Data
        getJSonData()
    }
    
    func getJSonData(){
        tableview.separatorStyle = .none
        boxView = UIView(frame: CGRect(x: 138, y: 285, width: 80, height: 80))
        boxView.center = self.view.center
        boxView.backgroundColor = UIColor.darkGray
        boxView.alpha = 0.9
        boxView.layer.cornerRadius = 10
        
        // Spin config:
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        activityView.frame = CGRect(x: 20, y: 12, width: 40, height: 40)
        activityView.startAnimating()
        
        // Activate:....
        boxView.addSubview(activityView)
        self.tableview.addSubview(boxView)
        let  netWorkController = NetworkController()
        netWorkController.getJSON(urlString: base_Url)
        
    }
}


extension ViewController : UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: listCell, for: indexPath) as! ListTableViewCell
        let book = bookList[(indexPath as NSIndexPath).row]
        print(book.name)
        print(book.details)
        cell.nameLabel.text = book.name
        cell.detailLabel.text = book.details
        
        
        if book.thumbnail != nil && book.thumbnail != ""{
            cell.listImageView.setRemoteImage(book.thumbnail, defaultImage: UIImage(named:"Unknown"), backgroundColor:.white )
        }else{
            cell.listImageView.image = UIImage(named:"No_Image")
        }
        
        return cell
    }
}
extension UIImageView {
    
    func setRemoteImage(_ image: String?, defaultImage: UIImage?, backgroundColor: UIColor, completionHandler: ((_ image: UIImage?, _ error: NSError?) -> Void)? = nil) {
        if image != nil && image!.characters.count > 0
        {
            let url = URL(string: image!)!
            self.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, imageURL) in
                completionHandler?(image, error)
                if (error != nil){
                    self.image = UIImage(named:"No_Image_Found")
                    self.backgroundColor = backgroundColor
                }
            })
            self.backgroundColor = backgroundColor
        }
        else {
            self.image = defaultImage
            self.backgroundColor = backgroundColor
        }
    }
    
}



struct Book{
    var name: String!
    var details: String!
    var thumbnail:String!
    
}




