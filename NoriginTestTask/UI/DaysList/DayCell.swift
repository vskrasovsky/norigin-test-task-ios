//
//  DayCell.swift
//  NoriginTestTask
//
//  Created by user on 9/1/18.
//  Copyright © 2018 ScienceSoft. All rights reserved.
//

import UIKit

class DayCell: UICollectionViewCell {
    @IBOutlet weak var dayOfWeekLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // to avoid blinking of old content while cell reusing
    override func prepareForReuse() {
        dayOfWeekLabel.text = ""
        dateLabel.text = ""
    }
    
    func configure(with viewModel: DayCellModel) {
        isSelected = viewModel.selected
        dayOfWeekLabel.text = viewModel.dayOfWeekStr
        dateLabel.text = viewModel.dateStr
    }
}
