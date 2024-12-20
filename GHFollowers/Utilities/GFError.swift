//
//  GFError.swift
//  GHFollowers
//
//  Created by Dom Montalto on 13/7/2023.
//

import Foundation

enum GFError: String, Error {
    
    case invalidUsername = "This username created an invalid request. Please try again."
    case unableToComplete = "Unable to complete your request. Please check your internet connection."
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data from the server was invalid. Please try again."
    case unableToFavourite = "There was an error favouriting user. Please try again."
    case alreadyInFavourites = "You've already favourited this user."
}
