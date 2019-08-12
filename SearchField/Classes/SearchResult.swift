//
//  SearchResult.swift
//  SearchField
//
//  Created by Mustafa Khalil on 8/8/19.
//  Copyright © 2019 Molteo. All rights reserved.
//

import Foundation

public protocol SearchAble {
    var id: UUID { get set }
}

public struct SearchResult: SearchAble {
    public var id: UUID = UUID()
    public init() {}
}
