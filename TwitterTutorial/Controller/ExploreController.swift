//
//  ExploreController.swift
//  TwitterTutorial
//
//  Created by Nikolas Gianoglou Coelho on 28/03/22.
//

import UIKit

private let reuseIdentifer = "UserCell"
class ExploreController: UITableViewController {
  
  //MARK: - Properties
  private var users = [User](){
    didSet{
      tableView.reloadData()
    }
  }
  
  private var filteredUsers = [User](){
    didSet{
      tableView.reloadData()
    }
  }
  
  private var inSearchMode: Bool{
    return searchController.isActive && !searchController.searchBar.text!.isEmpty
  }
  
  private let searchController = UISearchController(searchResultsController: nil)
  
  //MARK: - Lifecycle

    override func viewDidLoad() {
      super.viewDidLoad()
      configureUI()
      fetchUsers()
      configureSearchController()
    }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    navigationController?.navigationBar.barStyle = .default
    navigationController?.navigationBar.isHidden = false
  }
    
  //MARK: - API
  func fetchUsers(){
    UserService.shared.fetchUsers { users in
      self.users = users
      users.forEach { user in
        print("DEBUG: - USER is \(user.username)")
      }
    }
  }

    //MARK: - Helpers
  func configureUI(){
    searchController.searchResultsUpdater = self
    view.backgroundColor = .white
    navigationItem.title = "Explore"
    tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifer)
    tableView.rowHeight = 60
    tableView.separatorStyle = .none
  }
  

  func configureSearchController(){
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.searchBar.placeholder = "Search for a user"
    navigationItem.searchController = searchController
    definesPresentationContext = false
  }

}
//MARK: - UITableViewDelegate/DataSource
extension ExploreController{
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return inSearchMode ? filteredUsers.count : users.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath) as! UserCell
    let user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
    cell.user = user
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
    let controller = ProfileController(user: user)
    navigationController?.pushViewController(controller, animated: true)
  }
}

extension ExploreController: UISearchResultsUpdating{
  func updateSearchResults(for searchController: UISearchController) {
    guard let searchText = searchController.searchBar.text?.lowercased() else { return }
    filteredUsers = users.filter({$0.username.contains(searchText)})
  }
  
  
}
