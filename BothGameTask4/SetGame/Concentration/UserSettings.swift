//
//  UserSettings.swift
//  StanfordProgect
//
//  Created by Maxim Panamarou on 9/7/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation

private enum UserSettingsKey: String {
  case score
}

class UserSettings {
  static let `default` = UserSettings()
  private let userDefaults = UserDefaults.standard
}

protocol UserMaxScore {
  var maxScore: Int? { get set }
}

extension UserSettings: UserMaxScore {
  var maxScore: Int? {
    get {
      return userDefaults.value(forKey: UserSettingsKey.score.rawValue) as? Int
    }
    set {
      userDefaults.set(newValue, forKey: UserSettingsKey.score.rawValue)
    }
  }
}
