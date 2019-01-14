//
//  Storyboarded.swift
//  FriendZone
//
//  Created by Emin Roblack on 1/14/19.
//  Copyright © 2019 emiN Roblack. All rights reserved.
//

import UIKit

protocol Storyboarded {
  static func instantiate() -> Self
}

extension Storyboarded where Self: UIViewController {
  static func instantiate() -> Self {
    let className = String(describing: self)
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    
    return storyboard.instantiateViewController(withIdentifier: className) as! Self
  }
}
