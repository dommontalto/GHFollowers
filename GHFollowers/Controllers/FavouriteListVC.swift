//
//  FavouriteListVC.swift
//  GHFollowers
//
//  Created by Dom Montalto on 5/7/2023.
//

import UIKit

class FavouriteListVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        PersistenceManager.retrieveFavourites { result in
            switch result {
                
            case .success(let favourites):
                print(favourites)
            case .failure(let erorr):
                break
            }
        }
    }
}
