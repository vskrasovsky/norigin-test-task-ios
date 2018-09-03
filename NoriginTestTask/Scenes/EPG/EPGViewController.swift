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
        }
    }
    
    var viewModel: EPGViewModel! {
        didSet {
            setupBindings()
        }
    }

    let channelColumnWidth: CGFloat = 75
    let oneHourWidth: CGFloat = 270

    //points per sec
    var scale: Double {
        return Double(oneHourWidth) / 3600
    }
    
    var collectionViewContentWidth: CGFloat {
        return CGFloat(viewModel.duration * scale) + channelColumnWidth
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = UIImageView(image: UIImage(named: "noriginLogo"))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadData()
    }

    private func setupBindings() {
        viewModel.isLoadingChanged = { [weak self] in
            guard let viewModel = self?.viewModel else { return }
            self?.loadingView.isHidden = !viewModel.isLoading
            self?.contentView.isHidden = viewModel.isLoading
        }
        viewModel.epgChanged = { [weak self] in
            guard let viewModel = self?.viewModel else { return }
            self?.collectionView.reloadData()
            self?.daysListView.days = viewModel.days
            self?.daysListView.selectedDay = viewModel.days.first
        }
        viewModel.currentDateChanged = { [weak self] in
            if let layout = self?.collectionView.collectionViewLayout as? EPGCollectionViewLayout {
                layout.invalidateLayout()
            }
        }
        viewModel.activeProgramsChanged = { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    @IBAction func scrollToNowPressed(_ sender: UIButton) {
        let desiredOffset = CGFloat((viewModel.currentDate.timeInterval - viewModel.epgStart) * scale) - (collectionView.bounds.width - channelColumnWidth) / 2
        scrollToXOffsetIfPossible(desiredOffset)
        daysListView.selectedDay = viewModel.currentDate.startOfDay()
    }

    private func scrollToXOffsetIfPossible(_ xOffset: CGFloat) {
        let currentContentOffset = collectionView.contentOffset
        let maxContentOffset = collectionViewContentWidth - collectionView.bounds.width
        let offset = clip(value: xOffset, toRange: 0 ..< maxContentOffset)
        collectionView.setContentOffset(CGPoint(x: offset, y: currentContentOffset.y), animated: true)
    }
}

extension EPGViewController: DaysListViewDelegate {
    func dayListView(_ dayListView: DaysListView, didSelectDayWith date: Date) {
        let desiredOffset = CGFloat((date.timeInterval - viewModel.epgStart) * scale)
        scrollToXOffsetIfPossible(desiredOffset)
    }
}

extension EPGViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.channelViewModels.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.hourCellModels.count
        } else {
            return viewModel.channelViewModels[section - 1].programs.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            // hour cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourCell", for: indexPath) as! HourCell
            let hourViewModel = viewModel.hourCellModels[indexPath.item]
            cell.configure(with: hourViewModel.title)
            return cell
        } else {
            if indexPath.item == 0 {
                // channel cell
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChannelCell", for: indexPath) as! ChannelCell
                let channelViewModel = viewModel.channelViewModels[indexPath.section - 1]
                cell.configure(with: channelViewModel.logoURL)
                return cell
            } else {
                // program cell
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProgramCell", for: indexPath) as! ProgramCell
                let programViewModel = viewModel.channelViewModels[indexPath.section - 1].programs[indexPath.item - 1]
                let active = viewModel.activePrograms.contains(programViewModel.program)
                cell.configure(with: programViewModel, active: active)
                return cell
            }
        }
    }
}

extension EPGViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //handle only user dragging, not programmatically scrolling
        guard scrollView.isDragging else { return }
        let centerOfScreenOffset = (scrollView.contentOffset.x + (collectionView.bounds.width - channelColumnWidth) / 2)
        let centerOfScreenSecondsOffset = Double(centerOfScreenOffset) / scale
        let centerOfScreenDate = (viewModel.epgStart + centerOfScreenSecondsOffset).date
        daysListView.selectedDay = centerOfScreenDate.startOfDay()
    }
}

extension EPGViewController: EPGCollectionViewLayoutDelegate {
    func collectionViewContentWidth(_ collectionView: UICollectionView) -> CGFloat {
        return collectionViewContentWidth
    }
    
    func collectionView(_ collectionView: UICollectionView, xOffsetForItemAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            // hour cell
            let start = viewModel.hourCellModels[indexPath.item].start
            return channelColumnWidth + CGFloat(start * scale)
        } else {
            if indexPath.item == 0 {
                // channel cell
                return collectionView.contentOffset.x
            } else {
                // program cell
                let start = viewModel.channelViewModels[indexPath.section - 1].programs[indexPath.item - 1].start
                return channelColumnWidth + CGFloat(start * scale)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, widthForItemAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            // hour cell
            let hourViewModel = viewModel.hourCellModels[indexPath.item]
            return CGFloat((hourViewModel.end - hourViewModel.start) * scale)
        } else {
            if indexPath.item == 0 {
                // channel cell
                return channelColumnWidth
            } else {
                // program cell
                let programViewModel = viewModel.channelViewModels[indexPath.section - 1].programs[indexPath.item - 1]
                return CGFloat((programViewModel.end - programViewModel.start) * scale)
            }
        }
    }
    
    func collectionViewXOffsetForTimePosition(_ collectionView: UICollectionView) -> CGFloat {
        return channelColumnWidth + CGFloat((viewModel.currentDate.timeInterval - viewModel.epgStart) * scale)
    }
    
    func collectionViewTimePositionVisible(_ collectionView: UICollectionView) -> Bool {
        let xOffset = CGFloat((viewModel.currentDate.timeInterval - viewModel.epgStart) * scale)
        return collectionView.contentOffset.x < xOffset
    }
}
