//
//  SwiftUITextOutputFormat.swift
//
//  Created by Andrew Eades on 02/01/2020.
//  Copyright © 2020 Andrew Eades. All rights reserved.
//


#if canImport(SwiftUI)

import SwiftUI

import Foundation

/// Output format to use to generate an NSAttributedString from the
/// highlighted code. A `Theme` is used to determine what fonts and
/// colors to use for the various tokens.
@available(iOS 13, *)
@available(macOS 10.15, *)
@available(watchOS 6, *)
@available(tvOS 13, *)
public struct SwiftUITextOutputFormat: OutputFormat {
    public var theme: Theme
    
    public init(theme: Theme) {
        self.theme = theme
    }
    
    public func makeBuilder() -> Builder {
        return Builder(theme: theme)
    }
}

@available(iOS 13, *)
@available(macOS 10.15, *)
@available(watchOS 6, *)
@available(tvOS 13, *)
public extension SwiftUITextOutputFormat {
    struct Builder: OutputBuilder {
        private let theme: Theme
        private var texts = [Text]()
        
        fileprivate init(theme: Theme) {
            self.theme = theme
        }
        
        public mutating func addToken(_ token: String, ofType type: TokenType) {
            let tokenColor = swiftUIColor(forType: type)
                                        
            texts.append(Text(token).foregroundColor(tokenColor))
        }
        
        public mutating func addPlainText(_ plainText: String) {
            let tokenColor = SwiftUI.Color(theme.plainTextColor)

            texts.append(Text(plainText).foregroundColor(tokenColor))
        }
        
        public mutating func addWhitespace(_ whitespace: String) {
            let tokenColor = SwiftUI.Color.white
            
            texts.append(Text(whitespace).foregroundColor(tokenColor))
        }
        
        public func build() -> Text {
 
            let highlightedText = texts.reduce(Text(""), +)
            
            return highlightedText
        }
        
        private func swiftUIColor(forType type: TokenType) -> SwiftUI.Color {
            var tokenColor: SwiftUI.Color
            
            if let color = theme.tokenColors[type] {
                tokenColor = SwiftUI.Color(color)
            } else {
                tokenColor = SwiftUI.Color.white
            }
            
            return tokenColor
        }
        
    }
}

#endif
