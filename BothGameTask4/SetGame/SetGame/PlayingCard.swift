//
//  PlayingCard.swift
//  SetGame
//
//  Created by Maxim Panamarou on 9/16/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation

struct PlayingCard: Hashable {
  static func ==(lhs: PlayingCard, rhs: PlayingCard) -> Bool {
    if lhs.cardSymbol == rhs.cardSymbol && lhs.symbolCount == rhs.symbolCount {
      if lhs.symbolColor == lhs.symbolColor && lhs.symbolColor == lhs.symbolColor {
        return true
      }
    }
    return false
  }
  var hashValue: Int {return 0}
  var cardSymbol: MapOptions.CardSymbol
  var symbolCount: MapOptions.SymbolCount
  var symbolColor: MapOptions.SymbolColor
  var symbolFilling: MapOptions.SymbolFilling
  let identifire: Int
}
