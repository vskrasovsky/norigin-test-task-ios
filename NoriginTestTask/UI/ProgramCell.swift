//
//  ProgramCell.swift
//  NoriginTestTask
//
//  Created by user on 8/31/18.
//  Copyright © 2018 ScienceSoft. All rights reserved.
//

import UIKit

class ProgramCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeIntervalLabel: UILabel!

    func configure(with viewModel: ProgramCellViewModel) {
        titleLabel.text = viewModel.title
        timeIntervalLabel.text = viewModel.timeIntervalFormatted
    }
}
