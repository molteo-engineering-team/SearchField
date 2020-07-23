//
//  GenericCell.swift
//  SearchField
//
//  Created by Mustafa Khalil on 8/12/19.
//  Copyright © 2019 Molteo. All rights reserved.
//

import Foundation

/// Generic Cell is a subclass of UITableViewCell that has the Genric  type, so it would render that type according to whatever object the user wants to display in the cell
open class GenericCell<Element: SearchResult>: UITableViewCell {
    // A generic type that can be set by the user
    open var item: Element? {
        didSet {
            guard let item = item else { return }
            textLabel?.text = item.title
        }
    }
    
    // MARK: - init
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
