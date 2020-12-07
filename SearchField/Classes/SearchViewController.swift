//
//  SearchViewController.swift
//  SearchField
//
//  Created by Mustafa Khalil on 8/14/19.
//  Copyright © 2019 Molteo. All rights reserved.
//

public protocol SearchViewControllerDelegate: NSObjectProtocol {
    
    /// Selected SearchResult that is sent from the SearchResultsViewController
    ///
    /// - Parameter searchResult: the selected element in the view
    func selected(searchResult: SearchResult)
    
    // removing from controller
    func removeControllerFromView(_ controller: UIViewController)
}

extension SearchViewControllerDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {}
    func textFieldShouldReturn(_ textField: UITextField) {}
    func textFieldShouldClear(_ textField: UITextField) {}
}


/// Search view controller datasource should only be implemented when the data is going to be requested from a network call, or a more custom filtering such as title and an enum
public protocol SearchViewControllerDataSource: NSObjectProtocol {
    
    /// returns the text that's being typed by the user to the object that's implementing the following protocol
    ///
    /// - Parameter text: the typed text from UITextField
    func filter(text: String?)
}

// TODO: - Documantation

public class SearchViewController<Cell: GenericCell<Element>, Element: SearchResult>: UIViewController, SearchResultsControllerDelegate, SearchFieldDelegate {

    
    public var searchPadding: UIEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20)
    public var resultsControllerPadding: UIEdgeInsets = .zero
    
    private var _searchableElements: [Element] = [] {
        didSet {
            _resultsController?.filtered(searchItems: _searchableElements)
        }
    }
    
    public var searchableElements: [Element] {
        get {
            return _searchableElements
        }
        set {
            _searchableElements = newValue
        }
    }
    
    // MARK: - Delegates & data sources
    
    public weak var delegate: SearchViewControllerDelegate?
    public weak var dataSource: SearchViewControllerDataSource?
    
    // MARK: - UI variables
    
    private var _resultsController: SearchResultsController<Cell,Element>?
    private var _resultsView: UIView?

    public lazy var searchField: SearchField = {
        let field = SearchField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.searchFieldDelegate = self
        return field
    }()
    
    public var resultsView: UIView {
        get {
            guard let results = _resultsView else {
                let controller = SearchResultsController<Cell, Element>(delegate: self)
                _resultsController = controller
                _resultsView = controller.view
                return controller.view
            }
            return results
        }
        set {
            _resultsView = newValue
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(searchField)
        view.addSubview(resultsView)
        searchField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: searchPadding.top).isActive = true
        searchField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: searchPadding.left).isActive = true
        searchField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -searchPadding.right).isActive = true
        searchField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        resultsView.fillSuperView(disregarding: .top, padding: resultsControllerPadding)
        resultsView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: resultsControllerPadding.top).isActive = true
        _resultsController?.setItems(searchItems: _searchableElements)
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchField.becomeFirstResponder()
    }
    
    public func dismissView() {
        searchField.resignFirstResponder()
        delegate?.removeControllerFromView(self)
    }
    
    internal func textDidChangeWith(_ text: String?) {
        guard dataSource == nil else {
            dataSource?.filter(text: text)
            return
        }
        _resultsController?.filter(text: text)
    }
    
    public func selected(searchResult: SearchResult) {
        delegate?.selected(searchResult: searchResult)
        dismissView()
    }
}

