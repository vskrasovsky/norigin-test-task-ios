//
//  ViewController.swift
//  NoriginTestTask
//
//  Created by user on 8/28/18.
//  Copyright © 2018 ScienceSoft. All rights reserved.
//

import PromiseKit
import UIKit

class EPGViewController: UIViewController {

    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            if let layout = collectionView?.collectionViewLayout as? EPGCollectionViewLayout {
                layout.delegate = self
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
    
    var hours: [HourCellViewModel] {
        return epgViewModel?.hours ?? []
    }

    var channels: [ChannelViewModel] {
        return epgViewModel?.channels ?? []
    }

    let oneHourWidth: CGFloat = 270
    
    var contentWidth: CGFloat {
        guard let epgViewModel = epgViewModel else {
            return 0
        }
        return CGFloat(epgViewModel.duration) / 3600 * oneHourWidth
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstly {
            epgRESTService.epg()
        }.map(EPGViewModel.init)
        .done { [weak self] epgViewModel in
            self?.epgViewModel = epgViewModel
        }.catch { error in
            print(error.localizedDescription)
        }
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
            let hourViewModel = hours[indexPath.row]
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
                cell.configure(with: programViewModel)
                return cell
            }
        }
    }
}
