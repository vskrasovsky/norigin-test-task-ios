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

    weak var delegate: DaysListViewDelegate?

    @IBOutlet weak var collectionView: UICollectionView!
    
    var days: [DayCellViewModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
}

extension DaysListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCell", for: indexPath) as! DayCell
        let dayCellViewModel = days[indexPath.item]
        cell.configure(with: dayCellViewModel)
        return cell
    }
}

extension DaysListView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for i in 0 ..< days.count {
            days[i].selected = (i == indexPath.row)
        }
        let day = days[indexPath.item]
        delegate?.dayListView(self, didSelectDayWith: day.date)
    }
}
