//
//  PlayingCardDeck.swift
//  SetGame
//
//  Created by Maxim Panamarou on 9/16/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation

struct PlayingCardDeck {
    private var cards = [PlayingCard]()
    private (set) var identifireInDesk = [Int]()
    private var identifireOnTable = [Int]()
    private (set) var selectedIdentifire = [Int]()
    init() {
        var identifire  = 0
        for symbol in MapOptions.CardSymbol.allCases {
            for symbolCount in MapOptions.SymbolCount.allCases {
                for  symbolColor in MapOptions.SymbolColor.allCases {
                    for symbolFilling in MapOptions.SymbolFilling.allCases {
                        identifire += 1
                        let card = PlayingCard(cardSymbol: symbol,
                                               symbolCount: symbolCount,
                                               symbolColor: symbolColor,
                                               symbolFilling: symbolFilling,
                                               identifire: identifire)
                        cards.append(card)
                        identifireInDesk.append(identifire)
                    }
                }
            }
      }
      identifireInDesk.shuffle()
    }
    func findSet() -> [Int]? {
        guard identifireOnTable.count != 0 else { return nil }
        for first in 0..<identifireOnTable.count - 1 {
            for second in 1..<identifireOnTable.count - 1 {
                for third in 2..<identifireOnTable.count {
                    if first != second && second != third && first != third {
                         let combination = [identifireOnTable[first],
                                            identifireOnTable[second],
                                            identifireOnTable[third]]
                         if cards.filter({combination.contains($0.identifire)}).compareElements() {
                             return combination
                         }
                    }
                }
            }
        }
        return nil
    }
    mutating func giveCards(count: Int) -> [PlayingCard] {
        var currentRequest = [Int]()
        if identifireInDesk.count > 0 && count != 0 {
            for _ in 1...count {
                if let cardIdentifire = identifireInDesk.first {
                    identifireInDesk.remove(at: 0)
                    identifireOnTable.append(cardIdentifire)
                    currentRequest.append(cardIdentifire)
                }
            }
        }
      return cards.filter({currentRequest.contains($0.identifire)})
    }
  mutating func selectedCard(WithIdentifire identifire: Int, closure: (Bool, Bool?, [Int]?) -> Void) {
        for index in selectedIdentifire { guard identifire != index else {
            selectedIdentifire.remove(at: selectedIdentifire.index(of: identifire)!)
            closure(true, nil, nil)
            return} }
            selectedIdentifire.append(identifire)
        if selectedIdentifire.count == 3 {
            let test = selectedIdentifire
            if cards.filter({selectedIdentifire.contains($0.identifire)}).compareElements() {
                for itemToRemove in selectedIdentifire {
                    if let itemToRemoveIndex = identifireOnTable.index(of: itemToRemove) {
                        identifireOnTable.remove(at: itemToRemoveIndex)
                    }
                }
                selectedIdentifire.removeAll()
                closure(false, true, test)
                return
            } else {
                closure(false, false, selectedIdentifire)
            }
        }
        if selectedIdentifire.count > 3 {
            closure(false, nil, selectedIdentifire)
            selectedIdentifire.removeSubrange(0...2)
            return
        }
        closure(false, nil, nil)
    }
}
