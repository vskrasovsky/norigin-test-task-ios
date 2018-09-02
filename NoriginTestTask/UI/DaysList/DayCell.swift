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
        //Seems like a bug, but changing textColor out of async block have no effect
        DispatchQueue.main.async {
            let textColor: UIColor = viewModel.selected ? .white : .textGrayed
            self.dayOfWeekLabel.textColor = textColor
            self.dateLabel.textColor = textColor
            self.dayOfWeekLabel.text = viewModel.dayOfWeekStr
            self.dateLabel.text = viewModel.dateStr

        }
    }
}
