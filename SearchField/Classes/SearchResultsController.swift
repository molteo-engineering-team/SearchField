//
//  SearchFieldController.swift
//  SearchField
//
//  Created by Mustafa Khalil on 8/7/19.
//  Copyright © 2019 Molteo. All rights reserved.
//

import UIKit
import os.log

// TODO: - Documantation

public protocol SearchResultsControllerDelegate: NSObjectProtocol {
    func selected(searchResult: SearchResult)
}

open class SearchResultsController<Cell: GenericCell<Element>, Element: SearchResult>: UITableViewController {
    
    private let cellIdentity = "Search-field-cellID"
    
    private var _items: [SearchResult] = [] {
        didSet {
            _filteredItems = _items
        }
    }
    
    private var _filteredItems: [SearchResult] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    open var count: Int {
        get {
            return _filteredItems.count
        }
    }
    
    open var filteredItems: [SearchResult] {
        get {
            return _filteredItems
        }
    }
    
    open var items: [SearchResult] {
        get {
            return _items
        }
    }
    
    
    weak var delegate: SearchResultsControllerDelegate?
    
    
    public init(delegate: SearchResultsControllerDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        os_log("deinit SearchResultsController", type: .debug)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _filteredItems.count
    }
    
    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentity, for: indexPath) as! Cell
        cell.item = _filteredItems[indexPath.row] as? Element
        return cell
    }
    
    open override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = _filteredItems[indexPath.item]
        delegate?.selected(searchResult: item)
    }
}

extension SearchResultsController {
    
    public func setItems(searchItems: [SearchResult]) {
        _items = searchItems
    }
    
    public func filtered(searchItems: [SearchResult]) {
        _filteredItems = searchItems
    }
    
    func filter(text: String?) {
        guard let txt = text, !txt.isEmpty else {
            shouldRefreshItems()
            return
        }
        _filteredItems = items.filter { (item) -> Bool in
            return item.title.contains(txt)
        }
    }
    
    public func shouldRefreshItems() {
        _filteredItems = _items
    }
    
    public func reloadData() {
        tableView.reloadData()
    }
}

// MARK: - UI Setup

extension SearchResultsController {
    
    func setupTableView() {
        tableView.register(Cell.self, forCellReuseIdentifier: cellIdentity)
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .onDrag
        tableView.clipsToBounds = true
    }
}
