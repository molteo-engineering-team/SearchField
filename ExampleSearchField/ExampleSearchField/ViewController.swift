//
//  ViewController.swift
//  ExampleSearchField
//
//  Created by Mustafa Khalil on 8/8/19.
//  Copyright © 2019 Molteo. All rights reserved.
//

import UIKit
import SearchField
import os.log

struct SomeImportantElement: SearchResult {
    var title: String = UUID().uuidString
}

class ExampleViewController: UIViewController, SearchViewControllerDelegate, SearchViewDelegate, SearchViewControllerDataSource {

    private var animation = FadingAnimation()
    
    private var searchController: SearchViewController<GenericCell<SomeImportantElement>, SomeImportantElement>?
    
    var someArray = [
        SomeImportantElement(),
        SomeImportantElement(),
        SomeImportantElement(),
    ]
    
    lazy var searchField: SearchFieldView = {
        let field = SearchFieldView()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.searchViewDelegate = self
        return field
    }()
    
    deinit {
        os_log("deinit ViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
        view.addSubview(searchField)
        searchField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        searchField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        searchField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        searchField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    func selected(searchResult: SearchResult) {
        print(searchResult)
    }
    
    func removeControllerFromView(_ controller: UIViewController) {
        controller.dismiss(animated: true)
    }

    func presentSearchViewController() {
        presentNormalResultsController()
    }
    
    func presentNormalResultsController() {
        let controller = SearchViewController<GenericCell<SomeImportantElement>, SomeImportantElement>()
        controller.resultsControllerPadding = .init(top: 10,
                                                    left: 20,
                                                    bottom: 10,
                                                    right: 20)
        controller.delegate = self
        controller.dataSource = self
        searchController = controller
        controller.transitioningDelegate = animation
        controller.modalPresentationStyle = .currentContext
        controller.searchableElements = someArray
        present(controller, animated: true)
    }
    
    func filter(text: String?) {
        guard let txt = text, !txt.isEmpty else {
            // Implement your own way to handle empty Text or might be cool to also implement this with a custom SearchResultsController more on how to do that in Section 2 part 2 of this readme
            searchController?.searchableElements = someArray
            return
        }
        // Filtering from someArray or a networking call and setting it to searchableElements
        let filtered = someArray.filter { (id) -> Bool in
            return id.title.contains(txt)
        }
        searchController?.searchableElements = filtered
    }
}

// MARK: - Second example view controller

class ClassifiedCell: GenericCell<SomeImportantElement> {
    
    override var item: SomeImportantElement? {
        didSet {
            textLabel?.text = item?.title
            textLabel?.textColor = .white
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .purple
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// Implementing a results custom table view
class CustomTableView: SearchResultsController<ClassifiedCell, SomeImportantElement> {}


class SecondExampleViewController: UIViewController, SearchViewControllerDelegate, SearchViewDelegate, SearchViewControllerDataSource {
    
    private var animation = FadingAnimation()
    
    private var searchController: SearchViewController<GenericCell<SomeImportantElement>, SomeImportantElement>?
    private var customResultsViewController: CustomTableView?
    
    var someArray = [
        SomeImportantElement(),
        SomeImportantElement(),
        SomeImportantElement(),
    ]
    
    lazy var searchField: SearchFieldView = {
        let field = SearchFieldView()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.searchViewDelegate = self
        return field
    }()
    
    deinit {
        os_log("deinit ViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
        view.addSubview(searchField)
        searchField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        searchField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        searchField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        searchField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    func selected(searchResult: SearchResult) {
        print(searchResult)
        //        ONLY NEEDED when creating a custom SearchResultsController
        searchController?.dismiss(animated: true)
    }
    
    func removeControllerFromView(_ controller: UIViewController) {
        controller.dismiss(animated: true)
    }
    
    func presentSearchViewController() {
                presentCustomTableView()
    }
    
    func presentCustomTableView() {
        let customTableView = CustomTableView(delegate: self)
        customResultsViewController = customTableView
        customResultsViewController?.filtered(searchItems: someArray)
        
        let controller = SearchViewController<GenericCell<SomeImportantElement>, SomeImportantElement>()
        controller.resultsControllerPadding = .init(top: 10,
                                                    left: 20,
                                                    bottom: 10,
                                                    right: 20)
        controller.delegate = self
        controller.resultsView = customTableView.view
        searchController = controller
        controller.modalPresentationStyle = .currentContext
        controller.transitioningDelegate = animation
        present(controller, animated: true)
    }
    
    func filter(text: String?) {
        guard let txt = text, !txt.isEmpty else {
            // Implement your own way to handle empty Text or might be cool to also implement this with a custom SearchResultsController more on how to do that in Section 2 part 2 of this readme
            customResultsViewController?.setItems(searchItems: someArray)
            return
        }
        // Filtering from someArray or a networking call and setting it to searchableElements
        let filtered = someArray.filter { (id) -> Bool in
            return id.title.contains(txt)
        }
        customResultsViewController?.filtered(searchItems: filtered)
    }
}

extension SecondExampleViewController: SearchResultsControllerDelegate {
    
}
