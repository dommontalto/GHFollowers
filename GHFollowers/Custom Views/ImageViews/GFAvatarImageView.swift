//
//  GFAvatarImageView.swift
//  GHFollowers
//
//  Created by Dom Montalto on 11/7/2023.
//

import UIKit

class GFAvatarImageView: UIImageView {
    
    let placeholderImage = Images.placeholder
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func downloadImage(fromURL url: String) {
        // Old way
        
//        NetworkManager.shared.downloadImage(from: url) { [weak self] image in
//            guard let self else { return }
//            DispatchQueue.main.async { self.image = image }
//        }
        
        // New way
        
        Task { image = await NetworkManager.shared.downloadImage(from: url) ?? placeholderImage }
    }
}
