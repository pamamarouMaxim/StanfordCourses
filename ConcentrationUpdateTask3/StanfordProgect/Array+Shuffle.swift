//
//  ArrayExtansion.swift
//  StanfordProgect
//
//  Created by Maxim Panamarou on 9/6/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation

extension Array{
    mutating func shuffle() {
        for _ in 0...self.count{
            let randomValue = arc4random() % UInt32(self.count)
            self.swapAt(Int(randomValue), 0)
        }
    }
}

