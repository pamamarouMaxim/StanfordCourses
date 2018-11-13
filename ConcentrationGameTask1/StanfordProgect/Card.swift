//
//  Card.swift
//  StanfordProgect
//
//  Created by Maxim Panamarou on 9/6/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation

struct Card: Hashable{
  
  var hashValue: Int{return emoji.hashValue}
  
  static func ==(lhs: Card, rhs: Card) -> Bool {
      return lhs.emoji == rhs.emoji
  }
  
    var isFaceUp = false
    var isMadched = false
    var wasOpen = false
    var emoji : String

    init(emoji: String) {
        self.emoji = emoji
    }
}
