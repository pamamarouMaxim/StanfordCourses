//
//  PlayingCardView.swift
//  SetGame
//
//  Created by Maxim Panamarou on 9/16/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import UIKit
import Foundation

protocol DrawSymbolInRect {
    func drawSymbolInRect(in rect: CGRect)
}

protocol WriteSymbolInRect {
    func writeSymbolInRect(in rect: CGRect)
}

class PlayingCardView: UIView {
    static let maxCountSymbols = 3
    static let currentGame = GameParametrs.drawSymbol
    enum GameParametrs {
        case drawSymbol
        case writeСharacter
    }

    let symbol: MapOptions.CardSymbol
    let symbolCount: MapOptions.SymbolCount
    let symbolColor: MapOptions.SymbolColor
    let symbolFilling: MapOptions.SymbolFilling
    let identifire: Int
    var isFaceUp = false
    init (frame: CGRect, symbol: MapOptions.CardSymbol, symbolCount: MapOptions.SymbolCount,
          symbolColor: MapOptions.SymbolColor, symbolFilling: MapOptions.SymbolFilling, identifire: Int) {
          self.symbol = symbol
          self.symbolCount = symbolCount
          self.symbolColor = symbolColor
          self.symbolFilling = symbolFilling
          self.identifire = identifire
          super.init(frame: frame)
          self.backgroundColor = UIColor.clear
          layer.cornerRadius = 5
          layer.masksToBounds = true
    }
    required init?(coder aDecoder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        if isFaceUp {
          let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: 5)
          roundedRect.addClip()
          UIColor.white.setFill()
          UIColor.green.setStroke()
          roundedRect.stroke()
          roundedRect.fill()
          addSymbols()
        }
    }

    func addSymbols() {
        let startPoint = Int(bounds.maxY / CGFloat(PlayingCardView.maxCountSymbols * 2)) *
                            (PlayingCardView.maxCountSymbols - symbolCount.rawValue)
        for index in 0..<symbolCount.rawValue {
            let rectOrigin = startPoint + index * Int(bounds.maxY / CGFloat(PlayingCardView.maxCountSymbols))
            var rect = CGRect(origin: CGPoint(x: 0, y: rectOrigin),
                              size: CGSize(width: bounds.maxX,
                                           height: bounds.maxY / CGFloat(PlayingCardView.maxCountSymbols)))
            rect = rect.insetBy(dx: rect.width * 0.05,
                                dy: rect.height * 0.05)
            switch  PlayingCardView.currentGame {
            case .drawSymbol: drawSymbolInRect(in: rect)
            case .writeСharacter: writeSymbolInRect(in: rect)
            }
        }
    }

    func copyView() -> PlayingCardView {
        let playingCardViewCopy = PlayingCardView(frame: CGRect.zero,
                                                  symbol: symbol,
                                                  symbolCount: symbolCount,
                                                  symbolColor: symbolColor,
                                                  symbolFilling: symbolFilling,
                                                  identifire: identifire)
        return playingCardViewCopy
    }
}

extension PlayingCardView {
    func viewWasSelected(_ wasSelected: Bool) {
        var scaleAnimation : (scaleX: Float, scaleY: Float)
        scaleAnimation = wasSelected ? (1, 1) : (0.8, 0.8)
        UIView.animate(withDuration: 0.2) {
          self.transform = CGAffineTransform(scaleX: CGFloat(scaleAnimation.scaleX),
                                             y: CGFloat(scaleAnimation.scaleY))
      }
    }
    func containInSet() {
      if transform.a != 1 {
        UIView.animate(withDuration: 0.2, animations: {
          self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: { (_) in
          UIView.animate(withDuration: 0.2, animations: {
             self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
          })
        })
      } else {
        UIView.animate(withDuration: 0.2, animations: {
          self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: { (_) in
          UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
          })
        })
      }
    }
}

extension PlayingCardView: WriteSymbolInRect {
    func writeSymbolInRect(in rect: CGRect) {
        var text = String()
        var attributes = [NSAttributedString.Key: Any]()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        attributes[.strokeWidth] = -5
        attributes[.paragraphStyle] = paragraphStyle
        attributes[.font] = UIFont.systemFont(ofSize: rect.height)
        switch symbol {
        case .rhombus: text = "▲"
        case .oval: text = "●"
        case .wave: text = "■"
        }
        switch symbolColor {
        case .red: attributes[.strokeColor] = UIColor.red
        case .green: attributes[.strokeColor] = UIColor.green
        case .blue: attributes[.strokeColor] = UIColor.blue
        }
        let color = attributes[.strokeColor] as? UIColor
        switch symbolFilling {
        case .empty: attributes[.foregroundColor] = color?.withAlphaComponent(0)
        case .hatch: attributes[.foregroundColor] = color?.withAlphaComponent(0.5)
        case .filled: attributes[.foregroundColor] = color?.withAlphaComponent(1)
        }
        let string = NSAttributedString(string: text, attributes: attributes)
        string.draw(in: rect)
    }
}

extension PlayingCardView: DrawSymbolInRect {
    func drawSymbolInRect(in rect: CGRect) {
        var path = UIBezierPath()
        switch symbol {
        case .rhombus:
            path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        case .oval:
            path = UIBezierPath(ovalIn: rect)
        case .wave:
            path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        }
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        path.addClip()
        switch symbolColor {
        case .red:
            UIColor.red.setStroke()
            UIColor.red.setFill()
        case .green:
            UIColor.green.setStroke()
            UIColor.green.setFill()
        case .blue:
            UIColor.blue.setStroke()
            UIColor.blue.setFill()
        }
        switch symbolFilling {
        case .empty: break
        case .hatch:
            let step: CGFloat = 3
            var startX = rect.minX
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            for _ in 0...Int(rect.maxX/(step*2)) {
                startX += 3
                path.move(to: CGPoint(x: startX, y: rect.minY))
                path.addLine(to: CGPoint(x: startX, y: rect.maxY))
                startX += 3
                path.move(to: CGPoint(x: startX, y: rect.minY))
                path.addLine(to: CGPoint(x: startX, y: rect.minY))
            }
        case .filled:
            path.fill()
        }
        path.lineWidth = 3
        path.stroke()
        context?.restoreGState()
  }
}
