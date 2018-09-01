//
//  ChannelCell.swift
//  NoriginTestTask
//
//  Created by user on 8/31/18.
//  Copyright © 2018 ScienceSoft. All rights reserved.
//

import Kingfisher
import UIKit

class ChannelCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func configure(with imageURL: String) {
        let url = URL(string: imageURL)
        imageView.kf.setImage(with: url, options: [.keepCurrentImageWhileLoading])
    }
}
