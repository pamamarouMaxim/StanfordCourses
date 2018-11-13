//
//  Concentration.swift
//  StanfordProgect
//
//  Created by Maxim Panamarou on 9/6/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation
import UIKit

class Concentration {

  var gameTheme = GameTheme()
  
  var flipCount  = 0
  var score = 0
  var cards = [Card]()
  var choisedIndexes = [Int]()
  
  var acriveIndexes = [Int]()
  var matchedIndexes = [Int]()
  var deleted = [Int]()
  
  func  chooseCard(at index: Int) {
      if cards[index].isMadched == false{
          for i in choisedIndexes{ guard index != i else {return}}
          choisedIndexes.insert(index, at: 0)
          switch choisedIndexes.count {
          case 2:
              if cards[index] == cards[choisedIndexes[1]]{
              cards[index].isMadched = true
              cards[choisedIndexes[1]].isMadched = true
              score += 2
              }
          case 3:
              cards[choisedIndexes[1]].isFaceUp = false
              cards[choisedIndexes[2]].isFaceUp = false
              choisedIndexes.removeSubrange(1...2)
          default: break
          }
          if  cards[index].wasOpen == true{
              if cards[index].isMadched != true && choisedIndexes.count != 1{
                score -= 1
              }
          } else {
              cards[index].wasOpen = true
          }
          cards[index].isFaceUp = true
          flipCount += 1
        }
  }
  
  init(numberOfPairsOfCards: Int, theme: GameTheme.CurrentTheme?) {
      gameTheme.themeName = theme
      let choisedEmojiArray = gameTheme.cardIcons
      for i in 1...numberOfPairsOfCards {
          if numberOfPairsOfCards <= choisedEmojiArray.count{
              let card = Card(emoji: choisedEmojiArray[i - 1])
              cards += [card,card]
          }
      }
      cards.shuffle()
    }
}

