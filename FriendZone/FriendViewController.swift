// 
//  FriendViewController.swift
//  FriendZone
//
//  Created by Emin Roblack on 1/14/19.
//  Copyright © 2019 emiN Roblack. All rights reserved.
//

import UIKit

class FriendViewController: UITableViewController {
  
  weak var delegate: ViewController?
  var friend: Friend!
  
  var timeZones = [TimeZone]()
  var selectedTimeZone = 0
  
  var nameEditingCell: TextTableViewCell? {
    let indexPath = IndexPath(row: 0, section: 0)
    return tableView.cellForRow(at: indexPath) as? TextTableViewCell
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let identifiers = TimeZone.knownTimeZoneIdentifiers
    
    for identifier in identifiers {
      if let timeZone = TimeZone(identifier: identifier) {
        timeZones.append(timeZone)
      }
    }
    
    let now = Date()
    
    self.timeZones.sort {
      let ourDifference = $0.secondsFromGMT(for: now)
      let otherDifference = $1.secondsFromGMT(for: now)
      
      if ourDifference == otherDifference {
        return $0.identifier < $1.identifier
      } else {
        return ourDifference < otherDifference
      }
    }
    
    selectedTimeZone = timeZones.index(of: friend.timezone) ?? 0
    
  }
  
  
  //MARK:- Table Delegate Methods ------------------------------------------------
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return 1
    } else {
      return timeZones.count
    }
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section == 0 {
      return "Name your friend"
    } else {
      return "Select their timezone"
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
    // User name cell, first section
    if indexPath.section == 0 {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell", for: indexPath) as? TextTableViewCell else {
        fatalError("Could not find a name")
      }
      cell.textField.text = friend.name
      return cell
    } else {
      // Second section cells
      let cell = tableView.dequeueReusableCell(withIdentifier: "TimezoneCell", for: indexPath)
      let timeZone = timeZones[indexPath.row]
      
      cell.textLabel?.text = timeZone.identifier.replacingOccurrences(of: "_", with: " ")
      
      let timeDifference = timeZone.secondsFromGMT(for: Date())
      cell.detailTextLabel?.text = timeDifference.timeString()
      
      if indexPath.row == selectedTimeZone {
        cell.accessoryType = .checkmark
      } else {
        cell.accessoryType = .none
      }
      
      return cell
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 0 {
      startEditingNameCell()
    } else {
      selectRow(at: indexPath)
    }
  }
  
  //------------------------------------------------------------------------
  
  func startEditingNameCell() {
    nameEditingCell?.textField.becomeFirstResponder()
  }
  func selectRow(at indexPath: IndexPath){
    nameEditingCell?.textField.resignFirstResponder()
    
    for cell in tableView.visibleCells {
      cell.accessoryType = .none
    }
    
    selectedTimeZone = indexPath.row
    friend.timezone = timeZones[indexPath.row]
    
    let selected = tableView.cellForRow(at: indexPath)
    selected?.accessoryType = .checkmark
    
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    delegate?.update(friend: friend)
  }
  
  
  
  @IBAction func nameChanged(_ sender: UITextField) {
    friend.name = sender.text ?? ""
  }
  
}
