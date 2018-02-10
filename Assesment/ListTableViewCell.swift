//
//  ListTableViewCell.swift
//  Assesment
//
//  Created by Bhavya Santhu on 10/02/18.
//  Copyright © 2018 Bhavya. All rights reserved.
//


import UIKit

class ListTableViewCell: UITableViewCell {
    
    let nameLabel = UILabel()
    let detailLabel = UILabel()
    let listImageView = UIImageView()
    
    
    // MARK: Initalizers
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        if #available(iOS 9.0, *) {
            let marginGuide = contentView.layoutMarginsGuide
            contentView.layer.borderWidth = 0.5
            contentView.layer.borderColor = UIColor.black.cgColor
            
            
            //Configure image view
            contentView.addSubview(listImageView)
            listImageView.contentMode = .scaleAspectFit
            listImageView.backgroundColor = .white
            listImageView.translatesAutoresizingMaskIntoConstraints = false
            listImageView.autoresizingMask = [.flexibleHeight,.flexibleBottomMargin,.flexibleWidth]
            listImageView.clipsToBounds = true
            listImageView.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
            listImageView.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
            listImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
            listImageView.heightAnchor.constraint(equalToConstant: self.contentView.frame.height).isActive = true
            
            // configure titleLabel
            contentView.addSubview(nameLabel)
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            nameLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
            nameLabel.leftAnchor.constraint(equalTo: listImageView.leftAnchor,constant:120).isActive = true
            nameLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
            nameLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
            nameLabel.numberOfLines = 0
            nameLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
            
            // configure authorLabel
            contentView.addSubview(detailLabel)
            detailLabel.translatesAutoresizingMaskIntoConstraints = false
            detailLabel.leftAnchor.constraint(equalTo: listImageView.leftAnchor,constant:120).isActive = true
            detailLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
            detailLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
            detailLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
            detailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
            detailLabel.numberOfLines = 0
            detailLabel.font = UIFont(name: "Avenir-Book", size: 12)
            detailLabel.textColor = UIColor.lightGray
            

        } else {
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

