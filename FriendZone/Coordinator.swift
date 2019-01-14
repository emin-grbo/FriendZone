//
//  Coordinator.swift
//  FriendZone
//
//  Created by Emin Roblack on 1/14/19.
//  Copyright © 2019 emiN Roblack. All rights reserved.
//

import UIKit

protocol Coordinator {
  var childCoordinators: [Coordinator] { get set }
  var navigationController: UINavigationController { get set }
  
  func start()
}
