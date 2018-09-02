//
//  UIStoryboard.swift
//  NoriginTestTask
//
//  Created by user on 9/3/18.
//  Copyright © 2018 ScienceSoft. All rights reserved.
//

import UIKit

extension UIStoryboard {
    static func instantiate<A>(_ controllerClass: A.Type,
                               from storyboardName: String = "Main",
                               bundle: Bundle? = nil) -> A where A: UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        let controllerID = String(describing: controllerClass)
        
        guard let result = storyboard.instantiateViewController(withIdentifier: controllerID) as? A else {
            fatalError()
        }
        
        return result
    }
}
