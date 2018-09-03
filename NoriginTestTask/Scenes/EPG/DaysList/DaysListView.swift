//
//  DaysListView.swift
//  NoriginTestTask
//
//  Created by user on 9/1/18.
//  Copyright © 2018 ScienceSoft. All rights reserved.
//

import UIKit

protocol DaysListViewDelegate: class {
    func dayListView(_ dayListView: DaysListView, didSelectDayWith date: Date)
}

class DaysListView: UIView {
    @IBOutlet weak var collectionView: UICollectionView!

    weak var delegate: DaysListViewDelegate?
    
    var dayCellModels: [DayCellModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
}

extension DaysListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dayCellModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCell", for: indexPath) as! DayCell
        let dayViewModel = dayCellModels[indexPath.item]
        cell.configure(with: dayViewModel)
        return cell
    }
}

extension DaysListView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.dayListView(self, didSelectDayWith: dayCellModels[indexPath.row].day)
    }
}
