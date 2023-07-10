//
//  ErrorMessage.swift
//  GHFollowers
//
//  Created by Dom Montalto on 10/7/2023.
//

import Foundation

enum ErrorMessage: String {
    case invalidUsername = "This username created an invalid request. Please try again."
    case unableToComplete = "Unable to complete your request. Please check your internet connection."
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data from the server was invalid. Please try again."
}