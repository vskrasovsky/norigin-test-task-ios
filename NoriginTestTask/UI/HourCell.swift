//
//  HourCell.swift
//  NoriginTestTask
//
//  Created by user on 9/1/18.
//  Copyright © 2018 ScienceSoft. All rights reserved.
//

import UIKit

class HourCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!

    func configure(with title: String) {
        titleLabel.text = title
    }
}
