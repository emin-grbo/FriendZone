//
//  TimeFormatter_Int.swift
//  FriendZone
//
//  Created by Emin Roblack on 1/14/19.
//  Copyright © 2019 emiN Roblack. All rights reserved.
//

import Foundation

extension Int {
  func timeString() -> String {
    
     let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.hour, .minute]
    formatter.unitsStyle = .positional
    
    let formattedString = formatter.string(from: TimeInterval(self)) ?? "0"
    
    if formattedString == "0" {
      return "GMT"
    } else {
      if formattedString.hasPrefix("-"){
        return "GMT\(formattedString)"
      } else {
        return "GMT+\(formattedString)"
      }
    }
  }
  
  
}
