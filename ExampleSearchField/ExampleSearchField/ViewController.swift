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

struct Test: SearchAble {
    var id: UUID = UUID()
}

class TestCell: GenericCell<Test> {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .green
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TestController: SearchResultsController<TestCell, Test> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return count == 0 ? 250 : 0
    }
    
}

class ViewController: UIViewController, UITextFieldDelegate, SearchResultsControllerDelegate, SearchFieldDelegate {
    
    
    // only use when the user wants to actually fetch the data from a network the handleTextDidChange 
    func textfieldValueDidChangeWith(_ text: String?) {
        guard let txt = text, !txt.isEmpty else {
            searchResultController.shouldRefreshItems()
            return
        }
        let filtered = searchResultController.items.filter { (item) -> Bool in
            return item.id.uuidString.contains(txt)
        }
        searchResultController.filtered(searchItems: filtered)
    }
    
    func selected(searchResult: SearchAble) {
        print("Selected search result: \(searchResult)")
        searchField.dimissView()
    }
    
    lazy var searchResultController = TestController(delegate: self)
    
    lazy var searchField: SearchField<SearchResult> = {
        let field = SearchField<SearchResult>(delegate: self)
        field.translatesAutoresizingMaskIntoConstraints = false
//        field.resultsView = searchResultController.view
        return field
    }()
    
    deinit {
        os_log("deinit ViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(searchField)
        searchField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        searchField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        searchField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        searchField.heightAnchor.constraint(equalToConstant: 40).isActive = true
//                searchResultController.setItems(searchItems: [
//                    Test(),
//                    Test(),
//                    Test(),
//                    Test()
//                    ])
        searchField.filterInBase(searchResultsController: [SearchResult(),
                                                     SearchResult(),
                                                     SearchResult(),
                                                     SearchResult(),
                                                     SearchResult(),
                                                     SearchResult()])
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dimiss))
    }
    
    @objc func dimiss() {
        dismiss(animated: true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidReturn(_ textField: UITextField) {
        
    }
}

