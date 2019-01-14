//
//  ViewController.swift
//  FriendZone
//
//  Created by Emin Roblack on 1/14/19.
//  Copyright © 2019 emiN Roblack. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
  
  var friends = [Friend]()
  var selectedFriend: Int? = nil

  override func viewDidLoad() {
    super.viewDidLoad()
    
    loadData()
    
    title = "FriendZone"
    
    // Adding the "Add Friend" button
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                        target: self,
                                                        action: #selector(addFriend))
    
  }
  
  //MARK:- Table Delegate Methods ------------------------------------------------
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return friends.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    let friend = friends[indexPath.row]
    
    cell.textLabel?.text = friend.name
    
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = friend.timezone
    dateFormatter.timeStyle = .short

    cell.detailTextLabel?.text = dateFormatter.string(from: Date())
    
    return cell
  }
  
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    configureFriend(friend: friends[indexPath.row], position: indexPath.row)
  }
  
  //------------------------------------------------------------------------
  
  
  
  //MARK:- UserDefaults save/load data ------------------------------------------------
  func loadData() {
    
    let defaults = UserDefaults.standard
    guard let savedData = defaults.data(forKey: "Friends") else {return}
    
    let decoder = JSONDecoder()
    guard let loadedData = try? decoder.decode([Friend].self, from: savedData) else {return}
    
    friends = loadedData
  }
  
  
  
  func saveData() {
    let defaults = UserDefaults.standard
    let encoder = JSONEncoder()
    
    guard let savedData = try? encoder.encode(friends) else { fatalError("Could not save") }
    
    defaults.set(savedData, forKey: "Friends")
  }
  //------------------------------------------------------------------------
  
  
  
  @objc func addFriend() {
    
    let newFriend = Friend()
    friends.append(newFriend)
    
    saveData()
    tableView.reloadData()
    
    configureFriend(friend: newFriend, position: friends.count - 1)
  }
  
  
  func configureFriend(friend: Friend, position: Int) {
    guard let vc = storyboard?.instantiateViewController(withIdentifier: "FriendViewController") as? FriendViewController else {return}
    
    selectedFriend = position
    vc.delegate = self
    vc.friend = friend
    
    navigationController?.pushViewController(vc, animated: true)
  }
  
  func update(friend: Friend) {
    guard let selectedFriend = selectedFriend else {return}
    
    friends[selectedFriend] = friend
    tableView.reloadData()
    saveData()
  }
  
  
  
  
  
  
}

