//
//  Array+ComparePlayingCards.swift
//  SetGame
//
//  Created by Maxim Panamarou on 9/17/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation

extension Array {
  func compareElements() -> Bool {
      if let cards = self as? [PlayingCard] {
          if cards.count == 3 {
            return  compareValue(objects: cards.map({$0.cardSymbol}))  &&
                    compareValue(objects: cards.map({$0.symbolCount})) &&
                    compareValue(objects: cards.map({$0.symbolColor})) &&
                    compareValue(objects: cards.map({$0.symbolFilling}))
          }
      }
      return false
  }
  private func compareValue<T: Equatable>(objects: [T]) -> Bool {
      let consistDiffrentObject = objects[0] == objects[1] &&
          objects[1] == objects[2]
      guard consistDiffrentObject == false else {return true}
      let consistSameObject = objects[0] != objects[1] &&
          objects[1] != objects[2] &&
          objects[0] != objects[2]
    return consistSameObject ? true : false
  }
}
