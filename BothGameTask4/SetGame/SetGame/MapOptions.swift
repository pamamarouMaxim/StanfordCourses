//
//  MapOptions.swift
//  SetGame
//
//  Created by Maxim Panamarou on 9/17/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation

struct MapOptions {
    enum CardSymbol: CaseIterable {
        case wave
        case rhombus
        case oval
    }
    enum SymbolCount: Int, CaseIterable {
        case one = 1
        case two
        case three
    }
    enum SymbolColor: String, CaseIterable {
        case red
        case green
        case blue
    }
    enum SymbolFilling: CaseIterable {
        case empty
        case hatch
        case filled
    }
}
