//
//  ProgramCell.swift
//  NoriginTestTask
//
//  Created by user on 8/31/18.
//  Copyright © 2018 ScienceSoft. All rights reserved.
//

import UIKit

class ProgramCell: UICollectionViewCell {
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeIntervalLabel: UILabel!

    func configure(with cellModel: ProgramCellModel, active: Bool) {
        titleLabel.text = cellModel.title
        timeIntervalLabel.text = cellModel.timeIntervalFormatted
        view.backgroundColor = active ? .programActive : .programBackground
    }
}
