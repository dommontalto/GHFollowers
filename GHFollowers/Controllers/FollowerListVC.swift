//
//  FollowerListVC.swift
//  GHFollowers
//
//  Created by Dom Montalto on 6/7/2023.
//

import UIKit

class FollowerListVC: GFDataLoadingVC {
    
    enum Section { case main }
    
    var username: String!
    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    var page = 1
    var hasMoreFollowers = true
    var isSearching = false
    var isLoadingMoreFollowers = false
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    
    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        self.username = username
        title = username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        configureSearchController()
        getFollowers(username: username, page: page)
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a username"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func getFollowers(username: String, page: Int) {
        showLoadingView()
        isLoadingMoreFollowers = true
        
        // Old way
        
//        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
//            guard let self else { return }
//            self.dismissLoadingView()
//
//            switch result {
//            case .success(let followers):
//                self.updateUI(with: followers)
//
//            case .failure(let error):
//                self.presentGFAlertOnMainThread(title: "Bad Stuff Happened", message: error.rawValue, buttonTitle: "Ok")
//            }
//
//            self.isLoadingMoreFollowers = false
//        }
        
        // New way
        
        Task {
            do {
                let followers = try await NetworkManager.shared.getFollowers(for: username, page: page)
                updateUI(with: followers)
                dismissLoadingView()
            } catch {
                if let gfError = error as? GFError {
                    presentGFAlert(title: "Bad Stuff Happened", message: gfError.rawValue, buttonTitle: "Ok")
                } else {
                    presentDefaultError()
                }
                dismissLoadingView()
            }
        }
        
        // If only default errors
        
//        Task {
//            guard let followers = try? await NetworkManager.shared.getFollowers(for: username, page: page) else {
//                presentDefaultError()
//                return
//            }
//
//            updateUI(with: followers)
//            dismissLoadingView()
//        }
    }
    
    func updateUI(with followers: [Follower]) {
        if followers.count < 100 { self.hasMoreFollowers = false }
        self.followers.append(contentsOf: followers)
        
        if self.followers.isEmpty {
            let message = "This user doesn't have any followers. Go follow them 😀."
            DispatchQueue.main.async { self.showEmptyStateView(with: message, in: self.view) }
            return
        }
        
        self.updateData(on: followers)
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section,Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            return cell
        })
    }
    
    func updateData(on followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filteredFollowers : followers
        let follower = activeArray[indexPath.item]
        
        let destVC = UserInfoVC()
        destVC.username = follower.login
        destVC.delegate = self
        let navController = UINavigationController(rootViewController: destVC)
        present(navController, animated: true)
    }
    
    @objc func addButtonTapped() {
        showLoadingView()
        
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self else { return }
            self.dismissLoadingView()
            
            switch result {
            case .success(let user):
                self.addFavouritesToUser(user: user)
                
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    func addFavouritesToUser(user: User) {
        let favourite = Follower(login: user.login, avatarUrl: user.avatarUrl)
        PersistenceManager.updateWith(favourite: favourite, actionType: .add) { [weak self] error in
            guard let self else { return }
            
            guard let error else {
                self.presentGFAlertOnMainThread(title: "Success", message: "You have successfully favourited this user 🎉.", buttonTitle: "Hooray!")
                return
            }
            
            self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
        }
    }
}

extension FollowerListVC: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard hasMoreFollowers, !isLoadingMoreFollowers else { return }
            page += 1
            getFollowers(username: username, page: page)
        }
    }
}

extension FollowerListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            filteredFollowers.removeAll()
            updateData(on: followers)
            isSearching = false
            return
        }
        isSearching = true
        filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredFollowers)
    }
}

extension FollowerListVC: UserInfoVCDelegate {
    func didRequestFollowers(for username: String) {
        self.username = username
        title = username
        page = 1
        
        followers.removeAll()
        filteredFollowers.removeAll()
        collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        getFollowers(username: username, page: page)
    }
}
