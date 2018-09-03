//
//  ViewController.swift
//  NoriginTestTask
//
//  Created by user on 8/28/18.
//  Copyright © 2018 ScienceSoft. All rights reserved.
//

import PromiseKit
import UIKit

let timePositionKind = "TimePositionView"

class EPGViewController: UIViewController {

    @IBOutlet weak var loadingView: UIView!

    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var favouriteView: UIView! {
        didSet {
            favouriteView.layer.shadowOffset = .zero
            favouriteView.layer.shadowRadius = 6
            favouriteView.layer.shadowOpacity = 1.0
        }
    }
    
    @IBOutlet weak var daysListView: DaysListView! {
        didSet {
            daysListView.delegate = self
        }
    }

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            if let layout = collectionView?.collectionViewLayout as? EPGCollectionViewLayout {
                layout.delegate = self
                layout.register(UINib(nibName: "TimePositionView", bundle: nil), forDecorationViewOfKind: timePositionKind)
            }
            collectionView.backgroundColor = UIColor.separator
        }
    }
    
    var viewModel: EPGViewModel! {
        didSet {
            viewModel.isLoadingChanged = { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.loadingView.isHidden = !strongSelf.viewModel.isLoading
                strongSelf.contentView.isHidden = strongSelf.viewModel.isLoading
            }
            viewModel.epgChanged = { [weak self] in
                self?.reloadData()
            }
        }
    }
    
    var timer: Timer?

    let oneHourWidth: CGFloat = 270
    let updateInterval: TimeInterval = 13
    var currentDate = Date()

    var contentWidth: CGFloat {
        return CGFloat(viewModel.duration) / 3600 * oneHourWidth
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = UIImageView(image: UIImage(named: "noriginLogo"))
        
        timer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true, block: { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.currentDate = Date()
            if let layout = strongSelf.collectionView.collectionViewLayout as? EPGCollectionViewLayout {
                layout.invalidateLayout()
            }
        })
        viewModel.loadData()
    }

    private func reloadData() {
        collectionView.reloadData()
        daysListView.days = viewModel.days
        daysListView.selectedDay = viewModel.days.first
    }
    
    @IBAction func scrollToNowPressed(_ sender: UIButton) {
        let currentContentOffset = collectionView.contentOffset
        let ratio = (currentDate.timeIntervalSince1970 - viewModel.start.timeIntervalSince1970) / viewModel.duration
        // FIX ME:
        var offset =  CGFloat(ratio * Double(contentWidth)) - (collectionView.bounds.width - 75) / 2
        offset = clip(value: offset, toRange: 0 ..< maxContentOffset())
        collectionView.setContentOffset(CGPoint(x: offset, y: currentContentOffset.y), animated: true)
    }
    
    private func maxContentOffset() -> CGFloat {
        return contentWidth + 75 - collectionView.bounds.width
    }
}

extension EPGViewController: DaysListViewDelegate {
    func dayListView(_ dayListView: DaysListView, didSelectDayWith date: Date) {
        let ratio = (max(viewModel.start.timeIntervalSince1970, date.timeIntervalSince1970) - viewModel.start.timeIntervalSince1970) / viewModel.duration
        let currentContentOffset = collectionView.contentOffset
        // FIX ME:
        var offset =  CGFloat(ratio * Double(contentWidth))
        offset = clip(value: offset, toRange: 0 ..< maxContentOffset())
        collectionView.setContentOffset(CGPoint(x: offset, y: currentContentOffset.y), animated: true)
    }
}

extension EPGViewController: EPGCollectionViewLayoutDelegate {
    func collectionViewContentWidth(_ collectionView: UICollectionView) -> CGFloat {
        return contentWidth
    }
    
    func collectionView(_ collectionView: UICollectionView, xOffsetForItemAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            let hourViewModel = viewModel.hourCellModels[indexPath.item]
            let offset =  CGFloat(hourViewModel.startRatio * Double(contentWidth))
            return offset
        } else {
            let programViewModel = viewModel.channelCellModels[indexPath.section - 1].schedules[indexPath.item - 1]
            let offset =  CGFloat(programViewModel.startRatio * Double(contentWidth))
            return offset
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, widthForItemAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            let hourViewModel = viewModel.hourCellModels[indexPath.item]
            let width = CGFloat((hourViewModel.endRatio - hourViewModel.startRatio) * Double(contentWidth))
            return width
        } else {
            let programViewModel = viewModel.channelCellModels[indexPath.section - 1].schedules[indexPath.item - 1]
            let width = CGFloat((programViewModel.endRatio - programViewModel.startRatio) * Double(contentWidth))
            return width
        }
    }
    
    func collectionViewXOffsetForTimePosition(_ collectionView: UICollectionView) -> CGFloat {
        let ratio = (currentDate.timeIntervalSince1970 - viewModel.start.timeIntervalSince1970) / viewModel.duration
        let offset =  CGFloat(ratio * Double(contentWidth))
        return offset
    }
}

extension EPGViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.channelCellModels.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.hourCellModels.count
        } else {
            return viewModel.channelCellModels[section - 1].schedules.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourCell", for: indexPath) as! HourCell
            let hourViewModel = viewModel.hourCellModels[indexPath.item]
            cell.configure(with: hourViewModel.title)
            return cell
        } else {
            if indexPath.item == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChannelCell", for: indexPath) as! ChannelCell
                let channelViewModel = viewModel.channelCellModels[indexPath.section - 1]
                cell.configure(with: channelViewModel.logoURL)
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProgramCell", for: indexPath) as! ProgramCell
                let programViewModel = viewModel.channelCellModels[indexPath.section - 1].schedules[indexPath.item - 1]
                let program = programViewModel.program
                let active = program.start <= currentDate && currentDate <= program.end
                cell.configure(with: programViewModel, active: active)
                return cell
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //handle only user dragging, not programmatically scrolling
        guard scrollView.isDragging else { return }
        //FIX ME: optimize this method
        let ratio = (scrollView.contentOffset.x + (collectionView.bounds.width - 75) / 2) / contentWidth
        let interval = Double(ratio) * viewModel.duration + viewModel.start.timeIntervalSince1970
        let day = Date(timeIntervalSince1970: interval).startOfDay()
        daysListView.selectedDay = day
    }
}
