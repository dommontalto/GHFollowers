//
//  FollowerListVC.swift
//  GHFollowers
//
//  Created by Dom Montalto on 6/7/2023.
//

import UIKit

class FollowerListVC: UIViewController {
    
    var username: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    
    
        NetworkManager.shared.getFollowers(for: username, page: 1) { followers, errorMessage in
            guard let followers else {
                self.presentGFAlertOnMainThread(alertTitle: "Bad Stuff Happened", message: errorMessage!.rawValue, buttonTitle: "Ok")
                return
            }
            
            print("Followers.count \(followers.count)")
            print(followers)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
