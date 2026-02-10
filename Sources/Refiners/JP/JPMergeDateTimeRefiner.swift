//
//  JPMergeDateTimeRefiner.swift
//  SwiftyChrono
//

import Foundation

class JPMergeDateTimeRefiner: MergeDateTimeRefiner {
    override var PATTERN: String { return "^\\s*$" }
    override var TAGS: TagUnit { return .jpMergeDateAndTimeRefiner }
}
