//
//  SearchResult.swift
//  SearchField
//
//  Created by Mustafa Khalil on 8/8/19.
//  Copyright © 2019 Molteo. All rights reserved.
//

import Foundation


/// Searchable is the protocol that the user should confirm to fi they would be using the already implemented SearchResultsController
public protocol SearchResult {
    /// the title the user wants to show in the cells
    var title: String { get set }
}
