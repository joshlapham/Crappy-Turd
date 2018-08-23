//
//  UserDefaults+Helpers.swift
//  Crappy Turd
//
//  Created by jl on 24/8/18.
//  Copyright © 2018 Josh Lapham. All rights reserved.
//

import Foundation

struct UserDefaultsKey {
    static let HighScore = "HighScore"
}

extension UserDefaults {
    func getHighScore() -> Int? {
        return UserDefaults.standard.integer(forKey: UserDefaultsKey.HighScore)
    }
    
    func setHighScore(score: Int) {
        UserDefaults.standard.set(score, forKey: UserDefaultsKey.HighScore)
    }
}
