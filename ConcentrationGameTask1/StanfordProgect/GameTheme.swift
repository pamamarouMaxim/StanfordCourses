//
//  GameTheme.swift
//  StanfordProgect
//
//  Created by Maxim Panamarou on 9/9/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation
import UIKit

struct GameTheme {
    typealias cardTheme = (cardIcons: [String],background: UIColor,cardColor: UIColor)
    
    lazy var background = theme.background
    lazy var cardColor  = theme.cardColor
    lazy var cardIcons  = theme.cardIcons

    private lazy var theme = themeProperty

    private var themeProperty : cardTheme{
        let emojiCollectionIndex = arc4random() % UInt32(kindsEmoji.count)
        return  kindsEmoji[Int(emojiCollectionIndex)]
    }

    private var kindsEmoji = [
        (["🙈", "🐓", "🐝", "🦄", "🦐", "🐬", "🐊", "🐖"], #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)),
        (["😀", "🤣", "😅", "😇", "😍", "🤡", "😎", "🤠"], #colorLiteral(red: 0.9268351692, green: 0.4024443388, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.9686274529, green: 0.7221923752, blue: 0.5710856423, alpha: 1)),
        (["⚽️", "🏀", "🏈", "⚾️", "🎾", "🎱", "🏐", "🎲"], #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)),
        (["🚗", "🚜", "🚲", "🚔", "🚀", "✈️", "🛳", "🚡"], #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)),
        (["⌚️", "📱", "🖨", "🖥", "🕹", "📀", "📷", "☎️"], #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)),
        (["🇦🇷", "🇦🇹", "🇦🇺", "🇧🇾", "🇨🇦", "🇨🇿", "🇯🇵", "🇱🇷"], #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1))
    ]
}
