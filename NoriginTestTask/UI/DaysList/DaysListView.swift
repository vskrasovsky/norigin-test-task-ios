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
    
    var days: [Date] = [] {
        didSet {
            updateDayModels()
        }
    }
    var selectedDay: Date? {
        didSet {
            if selectedDay != oldValue {
//                print(oldValue, selectedDay)
                updateDayModels()
            }
        }
    }
    
    var dayCellModels: [DayCellModel] = [] {
        didSet {
            collectionView.reloadData()
            print(dayCellModels)
        }
    }
    
    private func updateDayModels() {
        dayCellModels = days.map({ day -> DayCellModel in
            let dayOfWeekStr = DateFormatter.dayOfWeekFormatter.string(from: day)
            let dateStr = DateFormatter.dayMonthDateFormatter.string(from: day)
            return DayCellModel(dayOfWeekStr: dayOfWeekStr,
                                dateStr: dateStr,
                                selected: day == selectedDay)
        })
    }
    
}

extension DaysListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count
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
        selectedDay = days[indexPath.row]
        delegate?.dayListView(self, didSelectDayWith: days[indexPath.row])
    }
}
