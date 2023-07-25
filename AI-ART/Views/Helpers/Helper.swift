//
//  RandomString.swift
//  DallETutorial
//
//  Created by Oleg Granchenko on 11.07.2023.
//

import Foundation

struct Helper {
    static func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }

    static func readKeyFromInfoDictionary(key: String) -> String? {
        if let infoDictionary = Bundle.main.infoDictionary,
           let value = infoDictionary[key] as? String {
            return value
        }
        return nil
    }
}

