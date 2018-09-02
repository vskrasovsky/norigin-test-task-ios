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
    
    let epgRESTService = EPGRESTService(loader: TRONWebLoader())

    var epgViewModel: EPGViewModel? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var hours: [HourCellModel] {
        return epgViewModel?.hours ?? []
    }
    
    var channels: [ChannelViewModel] {
        return epgViewModel?.channels ?? []
    }

    var timer: Timer?

    let oneHourWidth: CGFloat = 270
    let updateInterval: TimeInterval = 3
    var currentDate = Date()

    var contentWidth: CGFloat {
        guard let epgViewModel = epgViewModel else {
            return 0
        }
        return CGFloat(epgViewModel.duration) / 3600 * oneHourWidth
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = UIImageView(image: UIImage(named: "noriginLogo"))
        firstly {
            epgRESTService.epg()
        }.map(EPGViewModel.init)
        .done { [weak self] epgViewModel in
            self?.epgViewModel = epgViewModel
            let days = epgViewModel.days
            self?.daysListView.days = days
            self?.daysListView.selectedDay = days.first

        }.catch { error in
            print(error.localizedDescription)
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true, block: { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.currentDate = Date()
            if let layout = strongSelf.collectionView.collectionViewLayout as? EPGCollectionViewLayout {
                layout.invalidateLayout()
            }
        })
    }

    @IBAction func scrollToNowPressed(_ sender: UIButton) {
        let currentContentOffset = collectionView.contentOffset
        guard let epg = epgViewModel else { return }
        let ratio = (currentDate.timeIntervalSince1970 - epg.startInterval) / epg.duration
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
        guard let epg = epgViewModel else { return }
        let ratio = (max(epg.startInterval, date.timeIntervalSince1970) - epg.startInterval) / epg.duration
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
            let hourViewModel = hours[indexPath.item]
            let offset =  CGFloat(hourViewModel.startRatio * Double(contentWidth))
            return offset
        } else {
            let programViewModel = channels[indexPath.section - 1].schedules[indexPath.item - 1]
            let offset =  CGFloat(programViewModel.startRatio * Double(contentWidth))
            return offset
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, widthForItemAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            let hourViewModel = hours[indexPath.item]
            let width = CGFloat((hourViewModel.endRatio - hourViewModel.startRatio) * Double(contentWidth))
            return width
        } else {
            let programViewModel = channels[indexPath.section - 1].schedules[indexPath.item - 1]
            let width = CGFloat((programViewModel.endRatio - programViewModel.startRatio) * Double(contentWidth))
            return width
        }
    }
    
    func collectionViewXOffsetForTimePosition(_ collectionView: UICollectionView) -> CGFloat {
        guard let epg = epgViewModel else { return 0 }
        let ratio = (currentDate.timeIntervalSince1970 - epg.startInterval) / epg.duration
        let offset =  CGFloat(ratio * Double(contentWidth))
        return offset
    }
}

extension EPGViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return channels.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return hours.count
        } else {
            return channels[section - 1].schedules.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourCell", for: indexPath) as! HourCell
            let hourViewModel = hours[indexPath.item]
            cell.configure(with: hourViewModel.title)
            return cell
        } else {
            if indexPath.item == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChannelCell", for: indexPath) as! ChannelCell
                let channelViewModel = channels[indexPath.section - 1]
                cell.configure(with: channelViewModel.logoURL)
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProgramCell", for: indexPath) as! ProgramCell
                let programViewModel = channels[indexPath.section - 1].schedules[indexPath.item - 1]
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
        guard let epg = epgViewModel else { return }
        let ratio = (scrollView.contentOffset.x + (collectionView.bounds.width - 75) / 2) / contentWidth
        let interval = Double(ratio) * epg.duration + epg.startInterval
        let day = Date(timeIntervalSince1970: interval).startOfDay()
        daysListView.selectedDay = day
    }
}
