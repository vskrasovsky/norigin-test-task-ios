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
    
    func configure(with viewModel: DayCellViewModel) {
        dayOfWeekLabel.text = viewModel.dayOfWeekStr
        dateLabel.text = viewModel.dateStr
    }
}
